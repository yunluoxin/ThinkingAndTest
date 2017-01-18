//
//  NSObject+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSObject+DDAdd.h"
#import <objc/runtime.h>

DDSYNTH_DUMMY_CLASS(NSObject_DDAdd)

@implementation NSObject (DDAdd)

- (void)setAssociateValue:(id)value forKey:(const void *) key
{
    if (!key) return ;
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

- (id)getAssociateValueByKey:(const void *)key
{
    if (!key) return nil ;
    return objc_getAssociatedObject(self, key) ;
}

- (void)setAssociateWeakValue:(id)value forKey:(const void *)key
{
    if(!key) return ;
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN) ;
}

- (void)removeAllAssociateValues
{
    objc_removeAssociatedObjects(self) ;
}

@end
