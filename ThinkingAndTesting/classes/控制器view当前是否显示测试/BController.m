//
//  BController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BController.h"
#import "UIViewController+Swizzling.h"
@interface BController ()

@end

@implementation BController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor] ;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"testViewDisplay" object:nil userInfo:@{
                                                                                                        @"vc":@"B"
                                                                                                        }] ;
    
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}

@end
