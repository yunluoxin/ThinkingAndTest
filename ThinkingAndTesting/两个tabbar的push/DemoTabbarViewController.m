//
//  DemoTabbarViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/14.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoTabbarViewController.h"
#import "SecondLevelTabBarController.h"
@interface DemoTabbarViewController ()

@end

@implementation DemoTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"测试二层Tabbar";
    
    UIButton *fingerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fingerBtn setTitle:@"去第二个tabbar" forState:UIControlStateNormal];
    [fingerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    fingerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fingerBtn addTarget:self action:@selector(selectFingerToUnlock) forControlEvents:UIControlEventTouchUpInside];
    fingerBtn.frame = CGRectMake(100, 100, 200, 50);
    [self.view addSubview:fingerBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectFingerToUnlock
{
    SecondLevelTabBarController *tabVC = [SecondLevelTabBarController new];
    [self.navigationController pushViewController:tabVC animated:YES];
}

@end
