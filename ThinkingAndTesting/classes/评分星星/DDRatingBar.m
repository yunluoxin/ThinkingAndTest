//
//  DDRatingBar.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDRatingBar.h"

/**
 *  为了去掉高亮的按钮
 */
@interface DDRatingBarButton : UIButton

@end

@implementation DDRatingBarButton

- (void)setHighlighted:(BOOL)highlighted{}

@end

@implementation DDRatingBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5 ;
        _currentRating = 5 ;
        _mode = DDRatingBarReadOnlyMode ;
    }
    return self ;
}

- (void)setNumberOfStars:(NSUInteger)numberOfStars
{
    _numberOfStars = numberOfStars ;
    
    [self createStars] ;
    
    [self layout] ;
}

- (void)setMode:(DDRatingBarMode)mode
{
    _mode = mode ;
    
    [self.subviews makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@(mode)] ;
}

- (void)createStars
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
    
    CGFloat w = self.frame.size.width / _numberOfStars ;
    CGFloat h = self.frame.size.height ;
    
    //创建所有的星星
    for (int i = 0 ; i < _numberOfStars; i ++) {
        DDRatingBarButton * btn = [DDRatingBarButton buttonWithType:UIButtonTypeCustom] ;
        btn.adjustsImageWhenHighlighted = NO ;
        btn.tag = i ;
        [btn setImage:[UIImage imageNamed:@"star_comment"] forState:UIControlStateNormal] ;
        [btn setImage:[UIImage imageNamed:@"star_comment_selected"] forState:UIControlStateSelected] ;
        [btn addTarget:self action:@selector(rating:) forControlEvents:UIControlEventTouchDown] ;
        CGFloat x = w * i ;
        btn.frame = CGRectMake(x, 0 , w, h ) ;
        btn.userInteractionEnabled = self.mode ;
        [self addSubview:btn] ;
    }
}

- (void)setCurrentRating:(NSUInteger)currentRating
{
    _currentRating = currentRating ;
    
    [self layout] ;
}

- (void)layout
{
    for (int i = 0 ; i < _currentRating; i ++) {
        UIButton * btn = self.subviews[i] ;
        btn.selected = YES ;
    }
    
    for (NSUInteger i = _currentRating; i < _numberOfStars; i ++ ) {
        UIButton * btn = self.subviews[i] ;
        btn.selected = NO ;
    }
}

- (void)rating:(UIButton *)btn
{
    if (self.mode == DDRatingBarNormalMode) {
        self.currentRating = btn.tag + 1 ;
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview] ;
    
    [self createStars] ;
    
    [self layout] ;
}

@end


