//
//  ADViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/13.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ADViewController.h"
#import "DemoFocusViewController.h"
@interface ADViewController ()

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:[AdManager getAdImagePath]]];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
    imageV.contentMode = UIViewContentModeScaleAspectFill ;
    imageV.frame = self.view.bounds ;
    [self.view addSubview:imageV];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(step) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 0, 30, 30);
    
    
    typeof(self) __weak weakSelf = self ;
    
    //3秒后关闭本广告窗口
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf step];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //后台下载下一次的广告，存储起来
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AdManager loadAdImageFromNet];
    });
}


#pragma mark - 跳过广告显示
- (void)step
{
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [DemoFocusViewController new];//<----------这里改成广告显示完想要跳转的VC
}

- (BOOL)prefersStatusBarHidden
{
    return YES ;
}

@end
