//
//  UIView+DD.m
//  卡车妈妈
//
//  Created by 张小冬 on 15/12/17.
//  Copyright © 2015年 张小东. All rights reserved.
//

#import "UIView+DD.h"
#import <objc/runtime.h>
#undef	KEY_DATA
#define KEY_DATA	"UIVIEW.data"
#undef TAG_STRING
#define TAG_STRING "TagString"
@implementation UIView (DD)
- (void)setData:(id)data
{
    if (data) {
        objc_setAssociatedObject(self, KEY_DATA, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        [self unbindData];
    }
    [self dataDidChanged];
}
- (id)data{
    return objc_getAssociatedObject(self, KEY_DATA);
}
- (void)unbindData{
    objc_setAssociatedObject(self, KEY_DATA, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)dataDidChanged{
    
}

- (void)setTagString:(NSString *)tagString
{
    if (tagString==nil) {
        objc_setAssociatedObject(self, TAG_STRING, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        objc_setAssociatedObject(self, TAG_STRING, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (NSString *)tagString
{
    return objc_getAssociatedObject(self, TAG_STRING);
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

//- (void)dealloc
//{
//    objc_setAssociatedObject(self, KEY_DATA, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(self, TAG_STRING, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
@end
