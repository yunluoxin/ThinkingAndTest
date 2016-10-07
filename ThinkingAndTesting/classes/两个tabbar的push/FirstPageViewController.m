//
//  FirstPageViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/14.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FirstPageViewController.h"
#import "SecondPageViewController.h"
@interface FirstPageViewController ()

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第一页" ;
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *fingerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fingerBtn setTitle:@"去第二页" forState:UIControlStateNormal];
    [fingerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    fingerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fingerBtn addTarget:self action:@selector(selectFingerToUnlock) forControlEvents:UIControlEventTouchUpInside];
    fingerBtn.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:fingerBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectFingerToUnlock
{
    SecondPageViewController *vc = [SecondPageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
