//
//  DDSlider_TitleView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDSlider_TitleView.h"

@interface DDSlider_TitleView ()

@property (nonatomic, strong)NSArray<UIView *> * titleViews ;

@property (nonatomic, weak) UIView *slider ;    //滑块
@property (nonatomic, weak) UIView *lastSelectedView ;

@end

@implementation DDSlider_TitleView

- (instancetype)initWithFrame:(CGRect)frame andTitleViews:(NSArray <UIView *> *) titleViews
{
    if (self = [super initWithFrame:frame]) {
        self.titleViews = titleViews ;
        [self initView];
    }
    return self ;
}

- (void)initView
{
    CGFloat width = self.dd_width / self.titleViews.count ; //每个宽度
    CGFloat height = self.dd_height ;               //每个高度
    CGFloat y = 0 ;
    
    //给几个标题布局
    for (int i = 0 ; i < self.titleViews.count; i ++) {
        CGFloat x = i * width ;
        UIView *view = self.titleViews[i];
        view.tag = i ;
        view.userInteractionEnabled = YES ;
        view.frame = CGRectMake(x, y, width, height);
        [self addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTitleView:)];
        [view addGestureRecognizer:tap];
    }
    
    //添加底部滑块
    UIView *slider = [[UIView alloc]initWithFrame:CGRectMake(0, height - 1, width, 1)];
    self.slider = slider ;
    slider.backgroundColor = [UIColor orangeColor];
    [self addSubview:slider];
    
    self.currentIndex = 0 ; //设置默认的选中项
}

#pragma mark - 点击了某个titleView

- (void)tapTitleView:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.whenClickAtIndex) {
        self.whenClickAtIndex(gestureRecognizer.view, gestureRecognizer.view.tag) ;
    }
}

- (void)setCurrentPosition:(CGFloat)currentPosition
{
    _currentPosition = currentPosition ;
    
    CGFloat deltaX = currentPosition * self.slider.dd_width ;
    CGFloat x = deltaX + self.slider.dd_width / 2 ;
    CGFloat y = self.slider.center.y ;
    self.slider.center = CGPointMake( x, y ) ;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex ;
    
    self.currentPosition = currentIndex ;
    
    UIView *subview = self.titleViews[currentIndex] ;
    if ([subview isKindOfClass:[UILabel class]]) {
        UILabel *lastLabel = (UILabel *)self.lastSelectedView ;
        lastLabel.textColor = [UIColor blackColor];
        UILabel *label = (UILabel *)subview ;
        label.textColor = [UIColor redColor];
        self.lastSelectedView = subview ;
    }
    
}
@end
