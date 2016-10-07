//
//  DemoFocusViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoFocusViewController.h"

@interface DemoFocusViewController ()

@end

@implementation DemoFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES ;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 100, 30, 30);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)tap:(UIButton *)button
{
    
//    FocusGuideViewController *vc = [FocusGuideViewController new];
//    [self presentViewController:vc animated:NO completion:^{
//        
//    }];
}
@end
