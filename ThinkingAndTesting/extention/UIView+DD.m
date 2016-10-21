//
//  UIView+DD.m
//  卡车妈妈
//
//  Created by 张小冬 on 15/12/17.
//  Copyright © 2015年 张小东. All rights reserved.
//

#import "UIView+DD.h"
#import <objc/runtime.h>

const char * kUIViewData = "UIView.data" ;
const char * kUIViewTagString = "UIView.TagString" ;

@implementation UIView (DD)

- (void)setData:(id)data
{
    objc_setAssociatedObject(self, kUIViewData, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self respondsToSelector:@selector(dataDidChanged)]) {
        [self dataDidChanged] ;
    }
}
- (id)data
{
    return objc_getAssociatedObject(self, kUIViewData);
}

//- (void)dataDidChanged{}

- (void)setTagString:(NSString *)tagString
{
    objc_setAssociatedObject(self, kUIViewTagString, tagString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tagString
{
    return objc_getAssociatedObject(self, kUIViewTagString);
}

- (CGFloat) dd_height
{
    return self.bounds.size.height ;
}
- (CGFloat) dd_width
{
    return self.bounds.size.width ;
}
- (CGFloat) dd_left
{
    return self.frame.origin.x ;
}
- (CGFloat) dd_right
{
    return [self dd_left] + [self dd_width];
}
- (CGFloat) dd_top
{
    return self.frame.origin.y ;
}
- (CGFloat) dd_bottom
{
    return [self dd_top] + [self dd_height] ;
}

- (CGPoint) dd_center
{
    return CGPointMake([self dd_left] + [self dd_width]/2, [self dd_top] + [self dd_height]/2);
}

- (void)setDd_height:(CGFloat)dd_height
{
    CGRect frame = self.frame ;
    frame.size.height = dd_height ;
    self.frame = frame ;
}

- (void)setDd_width:(CGFloat)dd_width
{
    CGRect frame = self.frame ;
    frame.size.width = dd_width ;
    self.frame = frame ;
}

- (void)setDd_top:(CGFloat)dd_top
{
    CGRect frame = self.frame ;
    frame.origin.y = dd_top ;
    self.frame = frame ;
}

- (void)setDd_left:(CGFloat)dd_left
{
    CGRect frame = self.frame ;
    frame.origin.x = dd_left ;
    self.frame = frame ;
}

- (void)setDd_center:(CGPoint)dd_center
{
    self.center = dd_center ;
}

- (UIView *)findCurrentFirstResponder
{
    if (self && [self isFirstResponder]) {
        return self ;
    }
    for (UIView * subView in self.subviews) {
        UIView *v = [subView findCurrentFirstResponder] ;
        if (v) {
            return v ;
        }
    }
    return nil ;
}

- (void)printSubviews
{
    NSLog(@"------开始输出%@的所有子类(不包括子类的子类)------",self) ;
    for (int i = 0 ; i < self.subviews.count ; i ++ ) {
        UIView * subView = self.subviews[i] ;
        NSLog(@"--%d--%@",i, subView) ;
    }
    NSLog(@"-------------输出结束----------------") ;
}
@end
