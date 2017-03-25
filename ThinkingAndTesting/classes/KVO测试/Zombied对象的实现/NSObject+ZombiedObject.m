
//
//  NSObject+ZombiedObject.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/25.
//  Copyright © 2017年 dadong. All rights reserved.
//

#if __has_feature(objc_arc)
#error "NSObject+ZombiedObject.m file need to complie with non-arc, please set flag `-fno-objc-arc'"
#endif

#import "NSObject+ZombiedObject.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>
static NSString * const DDZombiedObjectPrefix = @"_DDZombiedObject_" ;

@implementation NSObject (ZombiedObject)

void EnabledZombiedMode()
{
    
    Method method = class_getInstanceMethod([NSObject class], NSSelectorFromString(@"dealloc")) ;
    method_setImplementation(method, (IMP)zombied_dealloc) ;
    
    NSLog(@"\n\n\n\n\n Zombie Mode Starts \n\n\n\n\n" );
}


static void zombied_dealloc(id instance, SEL _cmd)
{
    if (![@(object_getClassName(instance)) hasPrefix:DDZombiedObjectPrefix])
    {
        @synchronized (instance)
        {
            Class clazz = generateZombiedClass(instance) ;
            
            // zombiefy this object
            object_setClass(instance, clazz) ;
        }
    }else{
        
        @throw [NSException exceptionWithName:@"FatalError" reason:@"a dealloced object dealloc again, it's unbelievable" userInfo:nil] ;
    }
}

static void zombied_initailize(id self, SEL _cmd){}

static NSMethodSignature* zombied_methodSignatureForSelector(id self, SEL _cmd, SEL aSelector)
{
    NSString * className = @(object_getClassName(self)) ;
    NSString * originalClassName = [className substringFromIndex:DDZombiedObjectPrefix.length] ;
    
    NSLog(@"selector `%s` send to a dealloced instance `%@`",(void *)aSelector, originalClassName) ;
    
    abort();
}


static Class generateZombiedClass(id instance)
{
    NSString * name = @(object_getClassName(instance)) ;
    
    NSString * newClassName = [DDZombiedObjectPrefix stringByAppendingString:name] ;
    
    Class newClass = NSClassFromString(newClassName) ;
    
    if (newClass) {
        return newClass ;
    }
    
    newClass = objc_allocateClassPair(nil, newClassName.UTF8String, 0) ;
    
    // 重写 +initialize 为空
    class_addMethod(object_getClass(newClass), @selector(initialize), (IMP)zombied_initailize, "v@:") ;
    
    // 重写 -methodSignatureForSelector 转发方法
    class_addMethod(newClass, @selector(methodSignatureForSelector:), (IMP)zombied_methodSignatureForSelector, "@@::") ;
    
    objc_registerClassPair(newClass) ;
    
    return newClass ;
}

+ (void)dump
{
    NSObject * o = [NSObject new] ;
    [o release] ;
    [o class] ;
}

@end
