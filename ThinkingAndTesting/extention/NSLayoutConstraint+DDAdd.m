//
//  NSLayoutConstraint+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/23.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSLayoutConstraint+DDAdd.h"
#import <objc/runtime.h>

static char DDLayoutConstraintOriginalConstantKey ;
@implementation NSLayoutConstraint (DDAdd)

- (void)setDd_originalConstant:(CGFloat)dd_originalConstant
{
    objc_setAssociatedObject(self, &DDLayoutConstraintOriginalConstantKey, @(dd_originalConstant), OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

- (CGFloat)dd_originalConstant
{
    return [objc_getAssociatedObject(self, &DDLayoutConstraintOriginalConstantKey) floatValue] ;
}

@end
