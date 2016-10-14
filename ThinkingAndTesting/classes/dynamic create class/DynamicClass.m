//
//  DynamicClass.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/13.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DynamicClass.h"
#import <objc/runtime.h>
@implementation DynamicClass

+ (Class)makeClassWithClassName:(NSString *)newClassName extentsClass:(Class)originClazz
{
   
    Class clazz = NSClassFromString(newClassName) ;
    if (clazz) {
        return clazz ;
    }
    
    if (!originClazz) {
        originClazz = [ NSObject class ] ;
    }
    
    clazz = objc_allocateClassPair(originClazz, newClassName.UTF8String, 0) ;
    
//    Method m = class_getInstanceMethod(originClazz, @selector(class)) ;
//    
//    class_addMethod(clazz, @selector(class), (IMP)kvo_class, method_getTypeEncoding(m)  ) ;
    
    objc_registerClassPair(clazz) ;
    
    return clazz ;
    
}

static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self)) ;
}

@end
