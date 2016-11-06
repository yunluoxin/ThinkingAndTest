//
//  UINavigationBar+CustomStyle.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UINavigationBar+CustomStyle.h"
#import <objc/runtime.h>

@implementation UINavigationBar (CustomStyle)

- (void)setBackgroundColor:(UIColor *)bgColor backIndicatorImage:(UIImage *)backIndicatorImage titleColor:(UIColor *)titleColor rightItemColor:(UIColor *)rightItemColor
{
    if (bgColor) {
        self.barTintColor = bgColor ;
    }
    
    if (backIndicatorImage) {
        self.backIndicatorImage = [backIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.backIndicatorTransitionMaskImage = backIndicatorImage ;
    }
    
    if (titleColor) {
        NSMutableDictionary *textAttributes = [self.titleTextAttributes mutableCopy];
        self.dd_originTitleColor = textAttributes [NSForegroundColorAttributeName] ;
        textAttributes[NSForegroundColorAttributeName] = titleColor ;
        self.titleTextAttributes = textAttributes ;
    }
    
    if (rightItemColor) {
        UINavigationItem *item = [self.items firstObject];
        for (int i = 0 ; i < item.rightBarButtonItems.count; i ++) {
            UIBarButtonItem *rightItem = item.rightBarButtonItems[i];
            NSMutableDictionary * textAttributes = [[rightItem titleTextAttributesForState:UIControlStateNormal] mutableCopy];
            UIColor * originColor =  textAttributes[NSForegroundColorAttributeName] ;
            if (originColor) {
                self.dd_originRightItemColor = originColor ;
                
                textAttributes[NSForegroundColorAttributeName] = rightItemColor ;
                [rightItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal] ;
            }else{
                self.dd_originRightItemColor = rightItem.tintColor ;
                
                rightItem.tintColor = rightItemColor ;
            }
        }
    }
}


- (void)restoreNavigationBar
{
    NSAssert(self.dd_originTitleColor && self.dd_originRightItemColor, @"没有使用-setBackgroundColor..方法之前，无法使用restoreNavigationBar") ;
    
    self.barTintColor = nil ;
    
    self.backIndicatorImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.backIndicatorTransitionMaskImage = self.backIndicatorImage ;
    
    
    NSMutableDictionary * dic = [[self titleTextAttributes] mutableCopy] ;
    dic[NSForegroundColorAttributeName] = self.dd_originTitleColor ;
    self.titleTextAttributes = dic ;
    
    
    UINavigationItem *item = [self.items firstObject];
    for (int i = 0 ; i < item.rightBarButtonItems.count; i ++) {
        UIBarButtonItem *rightItem = item.rightBarButtonItems[i];
        NSMutableDictionary * dic = [[rightItem titleTextAttributesForState:UIControlStateNormal] mutableCopy];
        
        UIColor * originColor =  dic[NSForegroundColorAttributeName] ;
        if (originColor) {
            dic[NSForegroundColorAttributeName] = self.dd_originRightItemColor ;
            [rightItem setTitleTextAttributes:dic forState:UIControlStateNormal] ;
        }else{
            rightItem.tintColor = self.dd_originRightItemColor ;
        }
    }
    
    self.dd_originTitleColor = nil ;
    self.dd_originRightItemColor = nil ;
}



- (void)setDd_originTitleColor:(UIColor *)dd_originTitleColor
{
    objc_setAssociatedObject(self, @selector(dd_originTitleColor), dd_originTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

- (UIColor *)dd_originTitleColor
{
    return objc_getAssociatedObject(self, _cmd) ;
}

- (void)setDd_originRightItemColor:(UIColor *)dd_originRightItemColor
{
    objc_setAssociatedObject(self, @selector(dd_originRightItemColor), dd_originRightItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

- (UIColor *)dd_originRightItemColor
{
    return objc_getAssociatedObject(self, _cmd) ;
}
@end
