//
//  UINavigationBar+CustomStyle.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UINavigationBar+CustomStyle.h"

@implementation UINavigationBar (CustomStyle)

- (void)setBackgroundColor:(UIColor *)bgColor backIndicatorImage:(UIImage *)backIndicatorImage titleColor:(UIColor *)titleColor rightItemColor:(UIColor *)rightItemColor
{
    if (bgColor) {
//        self.backgroundColor = bgColor ;
        self.barTintColor = bgColor ;
    }
    
    if (backIndicatorImage) {
        self.backIndicatorImage = [backIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.backIndicatorTransitionMaskImage = backIndicatorImage ;
    }
    
    if (titleColor) {
        self.titleTextAttributes = @{
                                     NSForegroundColorAttributeName:titleColor //设置title的颜色
                                     };
    }
    
    if (rightItemColor) {
        UINavigationItem *item = [self.items firstObject];
        for (int i = 0 ; i < item.rightBarButtonItems.count; i ++) {
            UIBarButtonItem *rightItem = item.rightBarButtonItems[i];
            rightItem.tintColor = rightItemColor ;
        }
    }
}


- (void)restoreNavigationBar
{
    self.barTintColor = nil ;
    
    self.backIndicatorImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.backIndicatorTransitionMaskImage = self.backIndicatorImage ;
    
    self.titleTextAttributes = @{
                                 NSForegroundColorAttributeName:[UIColor blackColor] //设置title的颜色
                                 };
    
    UINavigationItem *item = [self.items firstObject];
    for (int i = 0 ; i < item.rightBarButtonItems.count; i ++) {
        UIBarButtonItem *rightItem = item.rightBarButtonItems[i];
        rightItem.tintColor = [UIColor blackColor] ;    //右边项目的颜色
    }
}

@end
