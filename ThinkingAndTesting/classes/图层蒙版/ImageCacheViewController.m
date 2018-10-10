//
//  ImageCacheViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/2.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "ImageCacheViewController.h"

static NSString *const identifier = @"UITableViewCell";

#define DownloadImageStorageDir ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/download-imaegs"])

@interface ImageCacheViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation ImageCacheViewController
{
    NSMutableDictionary *imageCache;
    NSMutableDictionary *operationCache;
    NSOperationQueue    *downloadQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearCaches)];
//    CFDictionaryRef options = (__bridge NSDictionary *)(@{(__bridge NSString *)kCGImageSourceShouldCache: @(YES)});
//    CGImageSourceRef source = CGImageSourceCreateWithURL(CFURLCreateWithString(NULL, (__bridge NSString *)(@""), NULL), options);
//    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, options);
//    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    downloadQueue = [[NSOperationQueue alloc] init];
    downloadQueue.maxConcurrentOperationCount = 10;
    downloadQueue.name = @"com.dadong.download-image.queue";
    
    imageCache = @{}.mutableCopy;
    operationCache = @{}.mutableCopy;
    
    
    
    ///
    /// 用自定义文件夹的！！必须事先主动创建好！不会自动创建文件夹！！！否则无法写文件，导致失败！
    ///
    if (![[NSFileManager defaultManager] fileExistsAtPath:DownloadImageStorageDir]) {
        NSLog(@"即将创建文件夹");
        [[NSFileManager defaultManager] createDirectoryAtPath:DownloadImageStorageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%li, %li", indexPath.section, indexPath.row];
    
    NSString *imageName = [NSString stringWithFormat:@"image%li.jpeg", (indexPath.row % 3 + 1)];
    cell.imageView.image = [self fetchImageByName:imageName];
    
    return cell;
}

///
/// 返回一个图片
///
- (UIImage *)fetchImageByName:(NSString *)imageName {
    UIImage *image = [imageCache objectForKey:imageName];
    if (image) {
        return image;
    }
    
    // 检测磁盘中是否有文件，如果有则直接返回
    NSString *file = [DownloadImageStorageDir stringByAppendingPathComponent:imageName];
    image = [UIImage imageWithContentsOfFile:file];
    
    if (image) {
        [imageCache setObject:image forKey:imageName];
        return image;
    }
    
    // 检测任务是否正在下载中，如果有，则不要重复创建活动了
    if ([operationCache objectForKey:imageName]) {
        return nil;
    }
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"模拟下载开始");
        sleep(arc4random() % 10 + 2);
        NSLog(@"模拟下载完毕");
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *newImage = [UIImage imageWithData:data];
        if (newImage) {
            [imageCache setObject:newImage forKey:imageName];
            
            [data writeToFile:[DownloadImageStorageDir stringByAppendingPathComponent:imageName] atomically:YES];
            
            [operationCache removeObjectForKey:imageName];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
//            CGRect visualRect = CGRectMake(0, self.tableView.contentOffset.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
//            NSArray *indexPaths = [self.tableView indexPathsForRowsInRect:visualRect];
            
            NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
            
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }];
    
    // 加入到操作标识中，防止重复下载
    [operationCache setObject:operation forKey:imageName];
    
    // 把任务加入到队列中，开始下
    [downloadQueue addOperation:operation];
    
    return [UIImage imageNamed:@"discount_star"];   // 先返回一个占位图
}

- (void)clearCaches {
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:DownloadImageStorageDir isDirectory:&isDir];
    if (isDir && result) {
        NSError *error = nil;
        result = [[NSFileManager defaultManager] removeItemAtPath:DownloadImageStorageDir error:&error];
        if (!result && error) {
            NSLog(@"删除Cache失败, reason: %@",error);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [imageCache removeAllObjects];
    [operationCache removeAllObjects];
    [downloadQueue cancelAllOperations];
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
