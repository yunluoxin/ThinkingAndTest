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
    
    FirstPageViewController *vc2 = [FirstPageViewController new] ;
    DDNavigationController *nav2 = [[DDNavigationController alloc]initWithRootViewController:vc2];
    [self addChildViewController:nav2] ;
    
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"第1页" image:[UIImage imageNamed:@"register_checkmark"] selectedImage:[UIImage imageNamed:@"register_checkmark_selected"]];
    nav.tabBarItem = item ;
    
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"第2页" image:[UIImage imageNamed:@"star_comment"] selectedImage:[UIImage imageNamed:@"star_comment_selected"]];
    nav2.tabBarItem = item2 ;
//    nav.title = @"第一页" ;
//    nav.tabBarItem.image = [UIImage imageNamed:@"register_checkmark"] ;
//    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"register_checkmark_selected"] ;
    
    
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor purpleColor]]] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
