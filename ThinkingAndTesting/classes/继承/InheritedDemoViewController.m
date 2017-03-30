//
//  InheritedDemoViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/29.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "InheritedDemoViewController.h"
#import "ParentClassA.h"
#import "SubClassB.h"

@interface InheritedDemoViewController ()

@end

@implementation InheritedDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Inherited Demo" ;
    
    self.view.backgroundColor = RandomColor ;
    
    SubClassB * b = [SubClassB new] ;
    [b parentMethodA] ;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.view printSubviewsRecursively] ;
}

@end
