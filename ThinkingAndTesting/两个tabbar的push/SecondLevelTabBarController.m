//
//  SecondLevelTabBarController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/14.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "SecondLevelTabBarController.h"
#import "FirstPageViewController.h"
#import "DDNavigationController.h"
@interface SecondLevelTabBarController ()

@end

@implementation SecondLevelTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES ;
    FirstPageViewController *vc = [FirstPageViewController new] ;
    DDNavigationController *nav = [[DDNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav] ;
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"第一页" image:[UIImage imageNamed:@"register_checkmark"] selectedImage:[UIImage imageNamed:@"register_checkmark_selected"]];
    nav.tabBarItem = item ;
//    nav.title = @"第一页" ;
//    nav.tabBarItem.image = [UIImage imageNamed:@"register_checkmark"] ;
//    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"register_checkmark_selected"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
