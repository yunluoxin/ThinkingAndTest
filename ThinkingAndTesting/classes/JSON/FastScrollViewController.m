//
//  FastScrollViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "FastScrollViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "HomeBanner.h"
#import "HomePageService.h"

#import "UITableViewCell+DDAddForFastScroll.h"

static NSString *const identifier = @"UITableViewCell";

#ifndef IMAGE_URL
#define IMAGE_URL(url) [NSString stringWithFormat:@"https://source.unsplash.com/collection/%d/80x80", (int)url]
#endif

@interface FastScrollViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<HomeBanner *> *items;

@end

@implementation FastScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [HomePageService loadHomeBannerListWithCompleteHandler:^(id responseObject, NSError *error) {
//        if (!error) {
//            self.items = [responseObject mutableCopy];
//            sync_main_safe(^{
//               [self.tableView reloadData];
//            });
//        }
//    }];
    
    ///
    /// @attention 为了防止多线程并发的可能（多次循环一直调用self.xx），最好建立局部变量先存储！最后再将数据赋值给self.xx
    ///
    asyn_global(^{
        NSMutableArray *items = @[].mutableCopy;
        for (int i = 0; i < 3000; i++) {
            HomeBanner *banner = [HomeBanner new];
            banner.test_b = [HomeBannerTitle new];
            banner.test_b.title_1 = [NSString stringWithFormat:@"%d",i];
            banner.picture = IMAGE_URL(i);
            [items addObject:banner];
            [NSThread sleepForTimeInterval:0.002];
        }
        asyn_main(^{
            self.items = items;
            [self.tableView reloadData];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items ? self.items.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    HomeBanner *banner = self.items[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", banner.test_b.title_1];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", banner.test_b.title_2];
    @weak(cell);
    cell.dd_cellData = banner;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:banner.picture] placeholderImage:[UIImage imageNamed:@"image1.jpeg"] options:SDWebImageAvoidAutoSetImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dd_safe_asyn_main(^{
            if (!weakcell) return ;
            @strong(cell);
            if ([[(HomeBanner *)strongcell.dd_cellData picture] isEqualToString:imageURL.absoluteString]) {
                strongcell.imageView.image = image;
//                strongcell.dd_cellData = nil; // 由于此回调block可能二次调用（比如设置延迟设置placeholder），所以那些情况下不能清空，一旦清空了！下载好了，哪怕没变也是肯定就无法设置了！
            }else{
                NSLog(@"此cell可能在快速滑动中已经改变了对象，不用再设置进去了! 下载好的url: %@, cell现在的url: %@", imageURL.absoluteString, [strongcell.dd_cellData picture]);
            }
        });
    }];
    
    return cell;
}

#pragma mark - UITableView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80.0f;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
