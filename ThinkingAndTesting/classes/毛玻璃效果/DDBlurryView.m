//
//  DDBlurryView.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/16.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDBlurryView.h"

@interface DDBlurryView ()
{
    UIImageView * _backgroundImageView ;
    UIVisualEffectView * _visualEffectView ;
}
@end

@implementation DDBlurryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI] ;
    }
    return self ;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor] ;
    
    //选择一种VisaulEffect样式
    UIVisualEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] ;
    
    //创建一个系统自带的VisualEffectView
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect] ;
    _visualEffectView.frame = self.frame ;
    
    
    //要设置成毛玻璃效果的图像
    _backgroundImageView = [[UIImageView alloc] initWithImage: [[UIApplication sharedApplication].keyWindow snapshotImage]] ;
    
    [self addSubview:_backgroundImageView] ;
    [self addSubview:_visualEffectView] ;
}

- (void)flashImageDueToScreenUpdate
{
    _backgroundImageView = [[UIImageView alloc] initWithImage: [[UIApplication sharedApplication].keyWindow snapshotImage]] ;
}




@end
