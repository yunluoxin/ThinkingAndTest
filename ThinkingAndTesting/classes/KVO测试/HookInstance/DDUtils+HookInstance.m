//
//  DDUtils+HookInstance.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/24.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDUtils+HookInstance.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString * const DDUtilsHookInstancePrefix = @"_DDUtilsHookInstancePrefix_" ;

@implementation DDUtils (HookInstance)

#pragma mark - API (Public)
+ (BOOL)hookInstance:(id)instance originalSel:(SEL)originalSel withTargetSel:(SEL)targetSel
{
    NSAssert(instance && originalSel && targetSel, @"parameters can't be nil") ;
    
    if (![instance respondsToSelector:originalSel] || ![instance respondsToSelector:targetSel]) {
        return NO ;
    }
    
    Class clazz = object_getClass(instance) ;
    
    if (![NSStringFromClass(clazz) hasPrefix:DDUtilsHookInstancePrefix]) {
        
        clazz = [self generateSubclassOfClass:clazz] ;
        
        if (clazz == nil) {
            return NO ;
        }
        
        object_setClass(instance, clazz) ;
    }
    
    // 如果这个临时类已经有了此方法，那说明之前这个方法已经被hook过了。直接pass.
    if (![self instances:instance hasSelector:originalSel])
    {
        Method originalMethod = class_getInstanceMethod(clazz, originalSel) ;
        Method targetMethod   = class_getInstanceMethod(clazz, targetSel) ;
        IMP originalImp       = method_getImplementation(originalMethod) ;
        IMP targetImp         = method_getImplementation(targetMethod) ;
        const char * types = method_getTypeEncoding(originalMethod) ;
        
        BOOL result = class_addMethod(clazz, originalSel, targetImp, types) ;
        if (result) {
            result = class_addMethod(clazz, targetSel, originalImp, types) ;
            return result ;
        }
    }
    
    return NO ;
}

+ (BOOL)hookInstance:(id)instance originalSel:(SEL)originalSel replaceWith:(IMP)targetImp
{
    NSAssert(instance && originalSel && targetImp, @"parameters can't be nil") ;
    
    if (![instance respondsToSelector:originalSel]) {
        return NO ;
    }
    
    Class clazz = object_getClass(instance) ;
    
    if (![NSStringFromClass(clazz) hasPrefix:DDUtilsHookInstancePrefix]) {
        
        clazz = [self generateSubclassOfClass:clazz] ;
        
        if (clazz == nil) {
            return NO ;
        }
        
        object_setClass(instance, clazz) ;
    }
    
    // 如果这个临时类已经有了此方法，那说明之前这个方法已经被hook过了。直接pass.
    if (![self instances:instance hasSelector:originalSel])
    {
        Method originalMethod = class_getInstanceMethod(clazz, originalSel) ;

        IMP originalImp = method_setImplementation(originalMethod, targetImp) ;
        
        return originalImp ;
    }
    
    return NO ;
}

+ (NSArray<NSString *> *)allInstanceMethodNames:(Class)clazz
{
    NSAssert(clazz, @"class can't be nil") ;
    unsigned int count = 0 ;
    NSMutableArray * list = @[].mutableCopy ;
    Method * methodList = class_copyMethodList(clazz, &count) ;
    for (int i = 0; i < count; i ++) {
        SEL sel = method_getName(methodList[i]) ;
        [list addObject:NSStringFromSelector(sel)] ;
    }
    free(methodList) ;
    return list.copy ;
}

+ (NSArray<NSString *> *)allIVarsOfClass:(Class)clazz
{
    NSAssert(clazz, @"class can't be nil") ;
    unsigned int count = 0 ;
    NSMutableArray * list = @[].mutableCopy ;
    Ivar * ivars = class_copyIvarList(clazz, &count) ;
    for (unsigned int i = 0; i < count; i ++) {
        [list addObject:@(ivar_getName(ivars[i]))] ;
    }
    free(ivars) ;
    return list.copy ;
}

+ (NSArray<NSString *> *)allPropertiesOfClass:(Class)clazz
{
    NSAssert(clazz, @"class can't be nil") ;
    unsigned int count = 0 ;
    NSMutableArray * list = @[].mutableCopy ;
    objc_property_t * properties = class_copyPropertyList(clazz, &count) ;
    
    for (unsigned int i = 0; i < count; i ++) {
        NSString * str = [NSString stringWithFormat:@"%s, %s", property_getName(properties[i]), property_getAttributes(properties[i]) ] ;
        [list addObject: str] ;
    }
    free(properties) ;
    return list ;
}

+ (BOOL)instances:(id)instance hasSelector:(SEL)selector
{
    NSAssert(instance && selector, @"can't be nil") ;
    BOOL flag = NO ;
    unsigned int count = 0 ;
    Method * methodList = class_copyMethodList(object_getClass(instance), &count) ;
    for (int i = 0; i < count; i ++) {
        SEL sel = method_getName(methodList[i]) ;
        if (sel == selector) {
            flag = YES ;
            break ;
        }
    }
    free(methodList) ;
    return flag ;
}



#pragma mark - private methods

+ (Class)generateSubclassOfClass:(Class)clazz
{
    NSString *newClassName = [DDUtilsHookInstancePrefix stringByAppendingString:NSStringFromClass(clazz)] ;
    Class newClass = NSClassFromString(newClassName) ;
    if (newClass) {
        return newClass ;
    }
    
    newClass = objc_allocateClassPair(clazz, newClassName.UTF8String, 0) ;
    
    if (!newClass) {
        DDLog(@"create new class failed") ;
        return nil ;
    }
    
    const char * types = method_getTypeEncoding(class_getInstanceMethod(clazz, @selector(class))) ;
    class_addMethod(newClass, @selector(class), (IMP)_hook_class, types) ;
    
    objc_registerClassPair(newClass) ;
    
    return newClass ;
}

static Class _hook_class(id self, SEL _cmd){
    return class_getSuperclass(object_getClass(self)) ;
}

@end
