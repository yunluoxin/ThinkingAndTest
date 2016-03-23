//
//  CoordinateTranslateViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CoordinateTranslateViewController.h"

@interface CoordinateTranslateViewController ()

@end

@implementation CoordinateTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    purpleView.frame = CGRectMake(0, 64, 300, 100);
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    [purpleView addSubview:greenView];
    greenView.frame = CGRectMake(10, 0, 100, 100);
    
    
    DDLog(@"转换前%@",NSStringFromCGRect(greenView.frame));
    
    CGRect greenViewF = [purpleView convertRect:greenView.frame toView:self.view];
    DDLog(@"converRect:toView:之后%@",NSStringFromCGRect(greenViewF));
    
    CGRect greenViewF2 = [self.view convertRect:greenView.frame fromView:purpleView];
    DDLog(@"converRect:fromView:之后%@",NSStringFromCGRect(greenViewF2));
    
    CGPoint point = [purpleView convertPoint:greenView.center toView:self.view];
    DDLog(@"point---%@",NSStringFromCGPoint(point));
    
    CGPoint point2 = [self.view convertPoint:greenView.center fromView:purpleView];
    DDLog(@"point2--%@",NSStringFromCGPoint(point2));
    
    /**
     *  两种转换方法的结果是一样的，主体要分清楚，不要搞混。
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
