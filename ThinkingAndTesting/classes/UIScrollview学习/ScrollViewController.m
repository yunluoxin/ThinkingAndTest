//
//  ScrollViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/11/22.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView ;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor] ;
//    self.automaticallyAdjustsScrollViewInsets = NO ;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor redColor] colorWithAlphaComponent:0.5]] forBarMetrics:UIBarMetricsDefault] ;
    [self.navigationController setNavigationBarHidden:YES] ;

    
    [self.view addSubview:self.scrollView] ;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 100, 50)] ;
    label.text = @"爱丽丝大姐夫";
    label.textColor = [UIColor purpleColor] ;
    [self.view addSubview:label] ;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeContactAdd] ;
    [self.scrollView addSubview:button] ;
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside] ;
    button.frame = CGRectMake(0, 1000, self.view.dd_width, 30);
    _scrollView.contentSize = CGSizeMake(0, button.dd_bottom) ;
    
    DDLog(@"%@",_scrollView.gestureRecognizers) ;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, self.view.dd_width, self.view.dd_height-64)] ;
        _scrollView.delegate = self ;
        _scrollView.backgroundColor = [UIColor whiteColor] ;
        _scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) ;
        
    }
    return _scrollView ;
}

- (void)click
{
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DDLog(@"offset--->%@",NSStringFromCGPoint(scrollView.contentOffset)) ;
    DDLog(@"edgeInset--->%@",NSStringFromUIEdgeInsets(scrollView.contentInset)) ;
    DDLog(@"indicatorEdgeInset--->%@",NSStringFromUIEdgeInsets(scrollView.scrollIndicatorInsets)) ;
}
@end
