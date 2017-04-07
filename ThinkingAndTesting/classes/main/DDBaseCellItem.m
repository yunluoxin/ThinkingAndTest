//
//  DDBaseItem.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDBaseCellItem.h"

@implementation DDBaseCellItem

- (instancetype)init
{
    if (self = [super init]) {
        _canHighlight = YES ;
    }
    return self ;
}

- (UIColor *)topLineColor
{
    if (!_topLineColor) {
        return [UIColor lightGrayColor] ;
    }
    return _topLineColor ;
}

- (UIColor *)bottomLineColor
{
    if (!_bottomLineColor) {
        return [UIColor lightGrayColor] ;
    }
    return _bottomLineColor ;
}

- (void)setTopLineIndent:(CGFloat)topLineIndent
{
    if (topLineIndent < 0) {
        topLineIndent = 0 ;
    }
    
    _topLineIndent = topLineIndent ;
}

- (void)setBottomLineIndent:(CGFloat)bottomLineIndent
{
    if (bottomLineIndent < 0) {
        bottomLineIndent = 0 ;
    }
    
    _bottomLineIndent = bottomLineIndent ;
}

@end
