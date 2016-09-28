//
//  DismissViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/22.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DismissViewController.h"

@interface DismissViewController ()
{
    UIView *_redView ;
}
@end

@implementation DismissViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *redView = [UIView new ] ;
    _redView = redView ;
    [self.view addSubview:redView] ;
    redView.backgroundColor = [UIColor redColor] ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)] ;
    [redView addGestureRecognizer:tap] ;
}

- (void)tap
{

    [self dismissViewControllerAnimated:YES completion:^{
        DDLog(@"---dismissViewcontroller之后的completion-------") ;
    }] ;
    self.whenPopVC() ;

    DDLog(@"%s",__func__) ;
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    
    DDLog(@"%s",__func__) ;
}
- (void)viewWillDisappear:(BOOL)animated
{
        DDLog(@"%s",__func__) ;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews] ;
    _redView.frame = self.view.bounds ;
}

- (void)dealloc
{
        DDLog(@"%s",__func__) ;
}
@end
