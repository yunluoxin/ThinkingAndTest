//
//  NSObject+Method.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NSObject+Method.h"
#import <objc/runtime.h>
@implementation NSObject (Method)
+ (void)load
{
    SEL sel[] =  {
        @selector(test),
        @selector(test2)
    };
    
    for (NSUInteger i = 0 ; i < sizeof(sel)/sizeof(SEL); i ++ ) {
        SEL originalSel = sel[i];
        SEL swizzledSel = NSSelectorFromString([@"dd_" stringByAppendingString:NSStringFromSelector(originalSel)]);
        Method originalMethod = class_getInstanceMethod(self, originalSel);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
        
        
//        method_exchangeImplementations(originalMethod, swizzledMethod);   //交换两者的实现方式
        
        //下面4行代码的功能和上面一行相同。就是交换实现方式
        IMP swizzledImp = class_getMethodImplementation(self, swizzledSel);
        IMP originImp = class_getMethodImplementation(self, originalSel);
        method_setImplementation(originalMethod, swizzledImp);
        method_setImplementation(swizzledMethod, originImp);
    }
    
    //------『方法名』还是一样的，只是交换了实现的代码
}

- (void)test
{
    DDLog(@"test");
}
- (void)dd_test
{
    DDLog(@"dd_test");
    
    [self dd_test];
}
- (void)test2
{
    DDLog(@"test2");
}

- (void)dd_test2
{
    DDLog(@"dd_test2");
}
@end
