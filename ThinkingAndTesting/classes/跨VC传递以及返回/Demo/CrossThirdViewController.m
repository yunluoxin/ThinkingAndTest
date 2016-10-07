//
//  CrossThirdViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CrossThirdViewController.h"

@interface CrossThirdViewController ()

@end

@implementation CrossThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第3个";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 50, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)adb:(UIButton *)sender
{
    if (self.whenPopVC) {
        self.whenPopVC(@"第三个的 的");
    }
    [self.navigationController popToViewController:self.backVC animated:YES];
}

@end
