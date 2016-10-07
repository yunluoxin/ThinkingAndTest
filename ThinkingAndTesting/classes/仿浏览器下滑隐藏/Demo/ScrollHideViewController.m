//
//  ScrollHideViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ScrollHideViewController.h"

@interface ScrollHideViewController ()<UIScrollViewDelegate>
{
    CGFloat _currentOffsetY ;
}
@property (nonatomic, weak)UIScrollView *scrollView ;

@property (nonatomic, weak)UIView *bar ;
@end

@implementation ScrollHideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView = scrollView ;
    scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.view.dd_width, self.view.dd_height *5);
    scrollView.delegate = self ;
    scrollView.decelerationRate = 0.1 ;
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.dd_bottom, self.view.dd_width, 30)];
    bar.backgroundColor = [UIColor yellowColor];
    _bar = bar ;
    [self.view addSubview:bar];
    
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    [self.scrollView addGestureRecognizer:pan];
}



- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
       CGPoint deltaS =  [recognizer translationInView:self.view ] ;
        DDLog(@"%@",NSStringFromCGPoint(deltaS));
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 100) {
        CGFloat deltaY = scrollView.contentOffset.y - _currentOffsetY ;
        if (deltaY > 0) {
            [self hideBar:deltaY];
        }else{
            [self showBar:deltaY];
        }
    }else{
        
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _currentOffsetY = scrollView.contentOffset.y ;//重点。
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (!decelerate) {

    }else{
        CGFloat deltaY = scrollView.contentOffset.y - _currentOffsetY ;
        if (deltaY > 0) {
            [self hideBar:100];
        }else{
            [self showBar:100];
        }
    }
}


- (void)showBar:(CGFloat )deltaS
{
    deltaS = ABS(deltaS);
    CGFloat scale ;
    if (deltaS >= 50) {
        scale = 1 ;
    }else{
        scale = deltaS / 50 ;
    }
    
    [UIView animateWithDuration:0.1f animations:^{
        self.bar.frame = CGRectMake(0, self.view.dd_height - 30 * scale, self.view.dd_width, 30);
    }];
}

- (void) hideBar:(CGFloat )deltaS
{
    CGFloat scale ;
    if (deltaS >= 50) {
        scale = 1 ;
    }else{
        scale = deltaS / 50 ;
    }
    [UIView animateWithDuration:0.1f animations:^{
        self.bar.frame = CGRectMake(0, self.view.dd_height + 30 * scale, self.view.dd_width, 30);
    }];
}
@end
