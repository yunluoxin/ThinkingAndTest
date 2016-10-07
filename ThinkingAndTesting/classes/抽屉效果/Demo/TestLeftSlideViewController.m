//
//  TestLeftSlideViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TestLeftSlideViewController.h"
#import "LeftSlideViewController.h"
#import "LeftViewController.h"
#import "DrawerMainViewController.h"
@interface TestLeftSlideViewController ()

@end

@implementation TestLeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    DrawerMainViewController *mainVC = [[DrawerMainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    
    LeftSlideViewController *slide = [[LeftSlideViewController alloc]initWithLeftVC:leftVC andMainVC:nav];
    [self addChildViewController:slide];
    [self.view addSubview:slide.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
