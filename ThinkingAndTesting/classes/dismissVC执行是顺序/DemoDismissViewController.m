//
//  DemoDismissViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/22.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoDismissViewController.h"
#import "DismissViewController.h"

@interface DemoDismissViewController ()
{
    UIView *_redView ;
}
@end

@implementation DemoDismissViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    UIView *redView = [UIView new ] ;
    _redView = redView ;
    redView.backgroundColor = [UIColor purpleColor] ;
    [self.view addSubview:redView] ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)] ;
    [redView addGestureRecognizer:tap] ;
}

- (void)tap
{

    DismissViewController *vc = [DismissViewController new] ;
    [self presentViewController:vc animated:YES completion:^{
        DDLog(@"--------presentViewController之后的block") ;
    }] ;
    vc.whenPopVC = ^(){
//        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval:1] ;
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                DDLog(@"要关闭了vc" ) ;
//            });
//        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:2] ;
             DDLog(@"要关闭了vc" ) ;
            });
    };
    DDLog(@"%s",__func__) ;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews] ;
    _redView.frame = self.view.bounds ;
}
@end
