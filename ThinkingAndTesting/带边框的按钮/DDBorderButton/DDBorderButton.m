//
//  DDBorderButton.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDBorderButton.h"

@implementation DDBorderButton
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self ;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self ;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self ;
}

//初始化View
- (void)initView
{
    // 按钮边框宽度
    self.layer.borderWidth = 0.8;
    // 设置圆角
    self.layer.cornerRadius = 3;
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//默认字体颜色
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//默认字体颜色
    self.titleLabel.textAlignment = NSTextAlignmentCenter ;
    self.titleLabel.font = [UIFont systemFontOfSize:13];//默认字体
    
    //默认边框颜色
    self.borderColor = [UIColor blackColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor ;
    
    // 设置颜色空间为rgb，用于生成ColorRef
    CGColorRef colorRef = borderColor.CGColor ;
    
    // 设置边框颜色
    self.layer.borderColor = colorRef ;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (borderWidth < 0) {
        borderWidth = 0 ;
    }
    _borderWidth = borderWidth ;
    self.layer.borderWidth = borderWidth;
}
@end
