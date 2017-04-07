//
//  DDBaseCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDBaseCell.h"

@interface DDBaseCell ()

@property (strong, nonatomic)UIView * topLineView ;
@property (strong, nonatomic)UIView * bottomLineView ;
@end

@implementation DDBaseCell


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (_item.canHighlight) {
        [super setHighlighted:highlighted animated:animated] ;
    }else{

    }
}


#pragma mark - core method = > config cell
- (void)setItem:(DDBaseCellItem *)item
{
    
#define LineViewHeight 0.5
    
    _item = item ;

    if (item.hasTopLine) {
        if (item.isFirstOne) item.topLineIndent = 0 ;
        self.topLineView.frame = CGRectMake(item.topLineIndent, 0, self.dd_width - item.topLineIndent, LineViewHeight) ;
        self.topLineView.backgroundColor = item.topLineColor ;
    }else{
        [_topLineView removeFromSuperview] ;
        _topLineView = nil ;
    }
    
    if (item.hasBottomLine) {
        if (item.isLastOne) item.bottomLineIndent = 0 ;
        self.bottomLineView.frame = CGRectMake(item.bottomLineIndent, self.dd_height - LineViewHeight, self.dd_width - item.bottomLineIndent, LineViewHeight) ;
        self.bottomLineView.backgroundColor = item.bottomLineColor ;
    }else{
        [_bottomLineView removeFromSuperview] ;
        _bottomLineView = nil ;
    }
    
    
}


- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero] ;
        _topLineView.alpha = 0.4 ;
        [self addSubview:_topLineView] ;
    }
    return _topLineView ;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero] ;
        _bottomLineView.alpha = 0.4 ;
        [self addSubview:_bottomLineView] ;
    }
    return _bottomLineView ;
}

@end
