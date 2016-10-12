//
//  BMethodObject+Swizzling.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BMethodObject+Swizzling.h"
#import <objc/runtime.h>

static IMP imp = NULL ;

@implementation BMethodObject (Swizzling)

+ (void)load
{
    Method originMethod = class_getInstanceMethod(self, @selector(abc)) ;
    Method swizzlingMethod = class_getInstanceMethod(self, @selector(dd_abc)) ;
    
    bool result = class_addMethod(self, @selector(abc), method_getImplementation(swizzlingMethod), "v") ;
    if (result) {
        DDLog(@"成功增加") ;
        IMP originImp = method_getImplementation(originMethod) ;
        if (originImp) {
            class_replaceMethod(self, @selector(dd_abc), originImp , method_getTypeEncoding(originMethod) );
        }else{
            class_replaceMethod(self, @selector(dd_abc), (IMP)case_for_exception, "v@:") ;
        }
        
    }else{
        DDLog(@"失败") ; //说明已经存在实现
        method_exchangeImplementations(originMethod, swizzlingMethod) ;
    }
}

- (void)testImp
{
    if (imp) {
        imp() ;
    }
}

- (void)dd_abc
{
    DDLog(@"交换里面的dd_abc") ;
    [self dd_abc] ;
}

static void case_for_exception(id s,SEL _cmd){
    NSLog(@"%@ original selector -%@ not be implemented ",[s class], NSStringFromSelector(_cmd));
}
@end
