//
//  DemoXibViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoXibViewController.h"
#import "TestXibViewController.h"
#import "TestXibController.h"
@interface DemoXibViewController ()

@end

@implementation DemoXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"这是第一个主要控制器" ;
    self.view.backgroundColor = [UIColor blueColor] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[TestXibViewController new] animated:YES] ;
//        [self.navigationController pushViewController:[TestXibController new] animated:YES] ;
}

@end
