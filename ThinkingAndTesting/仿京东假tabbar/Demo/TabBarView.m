//
//  TabBarView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TabBarView.h"
#import "UIButton+Block.h"
//#import "JDFirstViewController.h"
//#import "JDSecondViewController.h"


#define TabBarViewHeight        49.0f
#define TabBarViewWidth        DD_SCREEN_WIDTH

@interface TabBarView()
{
    __weak UIButton *_lastClickBtn ;
    
    //第几次设置
    NSInteger _times ;
}

@end

@implementation TabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self ;
}

- (void)initView
{
    
    
    self.frame = CGRectMake(self.dd_left, self.dd_top, TabBarViewWidth, TabBarViewHeight);
    
    self.backgroundColor = [UIColor greenColor ];
    
    [self addItemWithTitle:@"我的" normalImageName:nil selectedImageName:nil];
    
    [self addItemWithTitle:@"哈哈" normalImageName:nil selectedImageName:nil];
    
    [self relayout];
}

- (void)addItemWithTitle:(NSString *)title  normalImageName:(NSString *)normal  selectedImageName:(NSString *)selected
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(didBtnClicked:) forControlEvents:UIControlEventTouchDown];
    button.tag = self.subviews.count ;
    [self addSubview:button];
}

- (void)didBtnClicked:(UIButton *)sender
{
    if (sender == _lastClickBtn) {
        return ;
    }
    
    self.currentIndex = sender.tag ;
    
    if (self.whenBtnClicked) {
        self.whenBtnClicked(sender.tag);
    }
}

- (void)switchTab:(UIButton *)sender
{
    _lastClickBtn.selected = NO ;
    sender.selected = YES ;
    _lastClickBtn = sender ;
}


//重新布局
- (void)relayout
{
    NSInteger count = self.subviews.count;
    
    CGFloat x = 0 ;
    CGFloat w = TabBarViewWidth / count ;
    
    for (int i = 0 ; i < count; i ++ ) {
        UIButton *button = self.subviews[i];
        x = i * w ;
        button.frame = CGRectMake(x, 0, w, TabBarViewHeight);
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex == _currentIndex) {
        return ;
    }
    _currentIndex = currentIndex ;
    
    UIButton *btn = self.subviews[currentIndex];
    
    [self switchTab:btn];
    
    if (_times == 0) {
        if (self.whenBtnClicked) {
            self.whenBtnClicked(currentIndex);
        }
        _times++ ;
    }
}

@end
