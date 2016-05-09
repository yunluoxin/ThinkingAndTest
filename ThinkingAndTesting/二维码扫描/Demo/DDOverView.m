//
//  DDOverView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDOverView.h"

@implementation DDOverView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self ;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    if (context == nil) {
        return ;
    }
    
    [[[UIColor grayColor] colorWithAlphaComponent:0.75] setFill];
    UIRectFill(self.frame);
    
    [[UIColor clearColor] setFill ];
    CGFloat w = 200 ;
    CGFloat h = w ;
    CGFloat x = (self.dd_width - w ) / 2 ;
    CGFloat y = 150;
    UIRectFill(CGRectMake(x, y, w, h));
}

@end
