//
//  DDSlider_ContentView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDSlider_ContentView.h"

@interface DDSlider_ContentView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<UIView *> *contentViews ;

@end

@implementation DDSlider_ContentView

- (instancetype)initWithFrame:(CGRect)frame andContentViews:(NSArray<UIView *> *)contentViews
{
    if (self = [super initWithFrame:frame]) {
        self.contentViews = contentViews ;
        self.delegate = self ;
        [self initView];
    }
    return self ;
}

- (void)initView
{
    self.showsHorizontalScrollIndicator = NO ;
    self.showsVerticalScrollIndicator = NO ;
    self.pagingEnabled = YES ;
    
    CGFloat width  = self.dd_width  ;
    CGFloat height = self.dd_height ;
    CGFloat y = 0 ;
    
    for (int i = 0 ; i < self.contentViews.count; i ++) {
        UIView *subview = self.contentViews[i] ;
        CGFloat x = i * width ;
        subview.tag = i ;
        subview.frame = CGRectMake(x, y, width, height);
        [self addSubview:subview];
    }
    
    //设置contentSize
    self.contentSize = CGSizeMake(width * self.contentViews.count, height) ;
}


#pragma mark - UIScrollView的delegate方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x ;
    CGFloat pos = contentOffsetX / self.dd_width ;
    
    if (self.whenPositionChanged) {
        self.whenPositionChanged(pos) ;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x ;
    NSUInteger index = contentOffsetX / self.dd_width ;
    
    if (self.whenStopAtIndex) {
        self.whenStopAtIndex(index) ;
    }
}

- (void)setStepToIndex:(NSUInteger)stepToIndex
{
    _stepToIndex = stepToIndex ;
    
    CGFloat contentOffsetX = stepToIndex * self.dd_width ;
    [self setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    
    if (self.whenStopAtIndex) {
        self.whenStopAtIndex(stepToIndex) ;
    }
}
@end
