//
//  NSObject+TestDynamicProperty.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSObject+TestDynamicProperty.h"
#import <objc/runtime.h>
@implementation NSObject (TestDynamicProperty)

DD_DYNAMIC_PROPERTY_TYPE(UIColor *, myColor, setMyColor, RETAIN_NONATOMIC)

@end
