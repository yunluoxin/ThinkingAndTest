//
//  CircleIndicatorsView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CircleIndicatorsView.h"

#define CircleWidth  15.0f

@implementation CircleIndicatorsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self ;
}

- (void)initView
{
    _totalCount = 4 ;
    _currentTintCount = 0 ;
    _tintColor = [UIColor orangeColor];
    _normalColor = [UIColor grayColor] ;
}


- (void)didMoveToSuperview
{
    CGFloat height = self.dd_height;
    CGFloat width = self.dd_width / self.totalCount ;
    
    CGFloat x = ( width - CircleWidth ) / 2 ;
    CGFloat y = ( height - CircleWidth) / 2 ;
    
    for (int i = 0 ; i < self.totalCount; i ++ ) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = self.normalColor ;
        view.layer.cornerRadius = CircleWidth / 2 ;
        [self addSubview:view];
        
        CGFloat xx = x + i * width ;
        view.frame = CGRectMake(xx , y, CircleWidth, CircleWidth );
    }
}


- (void)setCurrentTintCount:(NSInteger)currentTintCount
{
    if (currentTintCount > self.totalCount) {
        currentTintCount = self.totalCount ;
    }
    if (currentTintCount < 0 ) {
        currentTintCount = 0 ;
    }
    
    _currentTintCount = currentTintCount ;
    
    for (int i = 0 ; i < self.subviews.count; i ++ ) {
        UIView *view = self.subviews[i];
        if (i < self.currentTintCount) {
            view.backgroundColor = self.tintColor ;
        }else{
            view.backgroundColor = self.normalColor ;
        }
    }
    
}
@end
