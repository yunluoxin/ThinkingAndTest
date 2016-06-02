//
//  TagListView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TagListView.h"
#import "AutoSizeButton.h"

#define TagListViewLeft     100.0f
#define TagListViewMargin   8.0f
#define TagListViewSpacing  5.0f


@implementation TagListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self ;
}

- (void)initView
{
    CGFloat maxWidth = self.dd_width - TagListViewLeft - TagListViewMargin * 2 ;
    
    CGFloat ix = TagListViewLeft + TagListViewMargin ;
    
    CGFloat x = ix ;
    CGFloat y = 0 ;
    CGFloat maxW = maxWidth ;
    for (int i = 0 ; i < self.subviews.count ; i ++) {
        UIView *button = self.subviews[i];
        
        //如果存在key，就绑定
        if (self.keyArray && self.keyArray.count > i ) {
            button.tagString = self.keyArray[i];
        }
        
        
        if (button.dd_width < maxW) {
            button.frame = CGRectMake(x, y, button.dd_width, button.dd_height);
            x = button.dd_right + TagListViewSpacing ;
            
        }else{
            y = y + button.dd_height + TagListViewSpacing ;
            x = ix ;
            maxW = maxWidth ;
            
            CGFloat w  ;
            if (button.dd_width > maxW) {       //如果一行就只有一个，但是还是超出了最大宽度，就就要特殊设置
                w = maxW ;
            }else{
                w = button.dd_height ;
            }
            button.frame = CGRectMake(x, y, w, button.dd_height);
            x = button.dd_right + TagListViewSpacing ;
        }
        maxW = maxW - button.dd_width - TagListViewSpacing ;
    }
}

- (void)createUI
{
    for (int i = 0 ; i < self.tagContentArray.count ; i ++) {
        AutoSizeButton *button = [AutoSizeButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.tagContentArray[i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self createUI];
    [self initView];
}

@end
