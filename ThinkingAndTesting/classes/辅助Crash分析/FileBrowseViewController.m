//
//  FileBrowseViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/26.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "FileBrowseViewController.h"

@implementation DDFileModel

- (NSString *)filePath {
    NSString *dir = self.dir;
    if (!dir) {
        dir = NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES).firstObject;
    }
    return [dir stringByAppendingPathComponent:self.fileName];
}

@end

@interface FileBrowseViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) NSMutableArray<DDFileModel *> *files;
@end

@implementation FileBrowseViewController {
    CGFloat _bottomBarY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.file.fileName ? : @"根目录";
    
    if (self.file && !self.file.isDir) {
        // 当前页面是文件模式
        [self setupRightItemShareIcon];
        [self.view addSubview:self.textView];
    } else {
        // 当前页面是文件夹模式
        [self setupRightItemEditIcon];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.bottomBar];
    }
    
    [self.view addSubview:self.activityView];
    
    [self loadDatas];
}

- (void)setupRightItemEditIcon {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
}

- (void)setupRightItemDoneIcon {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionEdit:)];
}

- (void)setupRightItemShareIcon {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareSingleFile:)];
}

- (NSString *)rootDir {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByDeletingLastPathComponent];
}

- (void)loadDatas {
    [self.activityView startAnimating];
    
    asyn_global(^{
        NSFileManager *manager = [NSFileManager defaultManager];
        if (_textView) {
            NSString *content = [[NSString alloc] initWithContentsOfFile:self.file.filePath encoding:NSUTF8StringEncoding error:nil];
            asyn_main(^{
                [self.activityView stopAnimating];
                self.textView.text = content;
            });
            return;
        }
        
        NSMutableArray *files = @[].mutableCopy;
        NSString *dir = self.file.filePath;
        if (!dir) {
            dir = [self rootDir];
        }
        NSError *error;
        NSArray *subFiles = [manager contentsOfDirectoryAtPath:dir error:&error];
        if (subFiles.count > 0) {
            for (NSString *fileName in subFiles) {
                DDFileModel *file = [DDFileModel new];
                file.dir = dir;
                file.fileName = fileName;
                
                BOOL isDir;
                BOOL isExist = [manager fileExistsAtPath:file.filePath isDirectory:&isDir];
                if (isExist) {
                    file.isDir = isDir;
                    [files addObject:file];
                } else {
//                    NSAssert(false, @"不可能不存在!拼接错误？");
                }
            }
        }
        
        asyn_main(^{
            self.files = files;
            [self.tableView reloadData];
            [self.activityView stopAnimating];
        });
    });
}


#pragma mark - Actions

/**
 进入编辑模式
 */
- (void)actionEdit:(id)sender {
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        [self setupRightItemDoneIcon];
    } else {
        [self setupRightItemEditIcon];
    }
    
    __block CGRect frame = self.bottomBar.bounds;
    if (self.tableView.editing) {
        [UIView animateWithDuration:0.4 animations:^{
            frame.origin.y = _bottomBarY;
            self.bottomBar.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            frame.origin.y = self.view.bounds.size.height;
            self.bottomBar.frame = frame;
        }];
    }
}


/**
 批量删除 文件/目录
 */
- (void)actionDelete:(id)sender {
    NSArray *indexPathes = self.tableView.indexPathsForSelectedRows;
    if (indexPathes.count < 1) return;
    
    [self.activityView startAnimating];

    asyn_global(^{
        NSMutableArray *successDelIndexs = @[].mutableCopy;
        NSMutableArray *successDelFiles  = @[].mutableCopy;
        for (NSIndexPath *indexPath in indexPathes) {
            DDFileModel *file = self.files[indexPath.row];
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:file.filePath error:nil];
            if (success) {
                [successDelIndexs addObject:indexPath];
                [successDelFiles addObject:file];
            }
        }
        
        asyn_main(^{
            [self.activityView stopAnimating];
            
            if (successDelFiles.count > 0) {
                [self.files removeObjectsInArray:successDelFiles.copy];
                [self.tableView deleteRowsAtIndexPaths:successDelIndexs withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        });
    });
}

/**
 编辑模式下，选中多文件进行分享
 */
- (void)actionShare:(id)sender {
    NSArray *indexPathes = self.tableView.indexPathsForSelectedRows;
    
    NSMutableArray *items = @[].mutableCopy;
    for (NSIndexPath *indexPath in indexPathes) {
        DDFileModel *file = self.files[indexPath.row];
        [items addObject:[NSURL fileURLWithPath:file.filePath]];
    }
    
    if (items.count > 0) {
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items.copy applicationActivities:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

/**
 分享当前文件
 */
- (void)actionShareSingleFile:(id)sender {
    if (self.file.isDir) return;
    
    NSURL *fileURL = [NSURL fileURLWithPath:self.file.filePath];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    DDFileModel *file = self.files[indexPath.row];
    cell.textLabel.text = file.fileName;
    if (file.isDir) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

/* 点击了 详情 按钮 */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DDFileModel *file = self.files[indexPath.row];
    if (!file.isDir) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        
        NSDictionary<NSFileAttributeKey, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:file.filePath error:nil];
        NSNumber *fileSize = attrs[NSFileSize];
        NSDate *createData = attrs[NSFileCreationDate];
        NSDate *modifyDate = attrs[NSFileModificationDate];
        NSString *content = [NSString stringWithFormat:@"文件大小:%.2f KB\n创建时间:%@\n修改时间:%@",
                             fileSize.floatValue/1000, [df stringFromDate:createData], [df stringFromDate:modifyDate]];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文件信息" message:content preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 正在编辑中，直接返回
    if (tableView.editing) return;
    
    DDFileModel *file = self.files[indexPath.row];
    FileBrowseViewController *vc = [FileBrowseViewController new];
    vc.file = file;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Lazy load

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
        _activityView.backgroundColor = [UIColor lightGrayColor];
    }
    return _activityView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    }
    return _textView;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        CGFloat h = 49.0;
        CGFloat w = self.view.bounds.size.width;
        CGFloat x = 0;
        CGFloat y = self.view.bounds.size.height - h;
        _bottomBarY = y;
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(x, self.view.bounds.size.height, w, h)];
        _bottomBar.backgroundColor = [UIColor redColor];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
        delBtn.frame = CGRectMake(0, 0, w / 2, h);
        [_bottomBar addSubview:delBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(actionShare:) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.frame = CGRectMake(w / 2, 0, w / 2, h);
        [_bottomBar addSubview:shareBtn];
    }
    return _bottomBar;
}
@end
