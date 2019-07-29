//
//  FileBrowseViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/26.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "FileBrowseViewController.h"
#import "FileBrowseUploadingView.h"
#import <GCDWebUploader.h>

@implementation DDFileModel

- (id)copyWithZone:(NSZone *)zone {
    DDFileModel *m = [[[self class] allocWithZone:zone] init];
    m.fileName = self.fileName;
    m.dir = self.dir;
    m.isDir = self.isDir;
    return m;
}

- (NSString *)filePath {
    NSString *dir = self.dir;
    if (!dir) {
        dir = NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES).firstObject;
    }
    return [dir stringByAppendingPathComponent:self.fileName];
}

@end

@interface FileBrowseViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    GCDWebUploaderDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *bottomBar;

@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic,   weak) FileBrowseUploadingView *uploadingView;
@property (nonatomic, strong) GCDWebUploader *webUploader;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) NSMutableArray<DDFileModel *> *files;
@end

@implementation FileBrowseViewController {
    CGFloat _bottomBarY;        /**< 底部bar显示时候所在的y值 */
    BOOL _isPullingToRefresh;   /**< 正在下拉刷新中 */
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
        self.tableView.tableHeaderView = self.uploadBtn;
    }
    
    [self.view addSubview:self.activityView];
    [self.view addSubview:self.tipsLabel];
    
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


#pragma mark - Utils

/**
 @return app沙盒的根文件夹路径
 */
- (NSString *)rootDir {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByDeletingLastPathComponent];
}

/**
 显示提示文本
 */
- (void)showTips:(NSString *)tips {
    self.tipsLabel.hidden = NO;
    self.tipsLabel.text = tips;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tipsLabel.hidden = YES;
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

/**
 双击了某个文件或者目录，修改文件名
 */
- (void)actionDoubleTapCell:(UITapGestureRecognizer *)gesture {
    if (!self.tableView.editing) return;
    
    UITableViewCell *cell = (UITableViewCell *)gesture.view;
    if (![cell isKindOfClass:UITableViewCell.class]) return;
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入新文件名" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = cell.textLabel.text;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) self = weakSelf;
        NSString *text = alert.textFields.firstObject.text;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        DDFileModel *file = self.files[indexPath.row];
        NSURL *originURL = [NSURL fileURLWithPath:file.filePath];
        
        file = file.copy;
        file.fileName = text;
        NSURL *targetURL = [NSURL fileURLWithPath:file.filePath];
        
        NSError *error;
        BOOL result = [[NSFileManager defaultManager] moveItemAtURL:originURL toURL:targetURL error:&error];
        if (result) {
            [self loadDatas];
        } else {
            NSLog(@"%@", error.localizedDescription);
            [self showTips:error.localizedDescription];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 上传文件 (进入上传文件的模式)
 */
- (void)actionUpload:(id)sender {
    NSString *dir = self.file.filePath ? : [self rootDir];
    self.webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:dir];
    self.webUploader.delegate = self;
    BOOL result = [self.webUploader start];
    
    if (result) {
        // 开启屏幕常亮，防止熄屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        FileBrowseUploadingView *view = [[FileBrowseUploadingView alloc] init];
        self.uploadingView = view;
        view.address = self.webUploader.serverURL.absoluteString;
        __weak typeof(self) weakSelf = self;
        view.exitUploadingMode = ^{
            // 关闭屏幕常亮
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            // 关闭web服务器
            [weakSelf.webUploader stop];
            // 刷新所有文件，这样如果在浏览器做的修改能直接体现出来
            [weakSelf loadDatas];
            
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.uploadingView.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf.uploadingView removeFromSuperview];
            }];
        };
        [self.view.window addSubview:view];

    } else {
        [self showTips:@"开启服务失败! 请重启app试试~"];
    }
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
        // 加入双击手势，修改文件名
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDoubleTapCell:)];
        tap.numberOfTapsRequired = 2;
        [cell addGestureRecognizer:tap];
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


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!_isPullingToRefresh && scrollView.contentOffset.y < -50) {
        _isPullingToRefresh = YES;
        [self loadDatas];
        _isPullingToRefresh = NO;
    }
}


#pragma mark - GCDWebServerDelegate & GCDWebUploaderDelegate

- (void)webServerDidCompleteBonjourRegistration:(GCDWebServer *)server {
    if (!server.serverURL) {
        self.uploadingView.address = server.bonjourServerURL.absoluteString;
    } else {
        self.uploadingView.address = [NSString stringWithFormat:@"%@\n 或 %@", server.serverURL.absoluteString, server.bonjourServerURL.absoluteString];
    }
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

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        _tipsLabel.center = self.view.center;
        _tipsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:15.0];
        _tipsLabel.hidden = YES;
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _tipsLabel;
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

- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 49.0)];
        _uploadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _uploadBtn.backgroundColor = [UIColor greenColor];
        [_uploadBtn setTitle:@"从电脑上传文件" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(actionUpload:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}
@end
