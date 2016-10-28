//
//  CALayer+DD.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CALayer+DD.h"

@implementation CALayer (DD)

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
    return self.dd_left + self.dd_width ;
}
- (CGFloat) dd_top
{
    return self.frame.origin.y ;
}
- (CGFloat) dd_bottom
{
    return self.dd_top + self.dd_height ;
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

@end
