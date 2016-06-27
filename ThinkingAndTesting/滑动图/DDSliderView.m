//
//  DDSliderView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDSliderView.h"
#import "DDSlider_TitleView.h"
#import "DDSlider_ContentView.h"

NSString * const KeyPath = @"currentIndex" ;

@interface DDSliderView ()

@property (nonatomic, strong) NSArray<UIView *> *contentViews ;
@property (nonatomic, strong) NSArray<UIView *> * titleViews ;
@property (nonatomic, assign) CGFloat titleViewHeight ;

@property (nonatomic, weak) DDSlider_TitleView *titleView ;

@end

@implementation DDSliderView

- (instancetype)initWithFrame:(CGRect)frame withTitleViewHeight:(CGFloat)height titleViews:(NSArray <UIView *> *) titleViews andContentViews:(NSArray<UIView *> *)contentViews
{
    if (self = [super initWithFrame:frame]) {
        self.titleViews = titleViews ;
        self.contentViews = contentViews ;
        self.titleViewHeight = height ;
        [self initView];
    }
    return self ;
}

- (void)initView
{
    
    //顶上的选项卡
    DDSlider_TitleView *titleView = [[DDSlider_TitleView alloc]initWithFrame:CGRectMake(0, 0, self.dd_width, self.titleViewHeight) andTitleViews:self.titleViews];
    self.titleView = titleView ;
    [self addSubview:titleView];
    
    //底部的view
    DDSlider_ContentView *contentView = [[DDSlider_ContentView alloc]initWithFrame:CGRectMake(0, titleView.dd_height, self.dd_width, self.dd_height - titleView.dd_bottom) andContentViews:self.contentViews];
    [self addSubview:contentView];
    
    titleView.whenClickAtIndex = ^(UIView *clickView, NSUInteger index){
        contentView.stepToIndex = index ;
    };
    
    contentView.whenPositionChanged = ^(CGFloat pos){
        titleView.currentPosition = pos ;
    };
    
    contentView.whenStopAtIndex = ^(NSUInteger index){
        titleView.currentIndex = index ;
    };
    
    [titleView addObserver:self forKeyPath:KeyPath options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([KeyPath isEqualToString:keyPath ]) {
        DDLog(@"%@",change[@"new"]);
    }
}

- (void)dealloc
{
    [self.titleView removeObserver:self forKeyPath:KeyPath context:NULL];
}
@end
