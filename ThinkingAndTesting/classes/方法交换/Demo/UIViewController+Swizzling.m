//
//  UIViewController+Swizzling.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load
{
    return ;
    
    SEL sel[4] = {
        @selector(viewWillAppear:),
        @selector(viewDidAppear:),
        @selector(viewWillDisappear:),
        @selector(viewDidDisappear:)
    };
    for(int i = 0 ; i < sizeof(sel)/sizeof(SEL); i ++ ){
        SEL originSel = sel[i] ;
        NSString *swizz = [NSString stringWithFormat:@"dd_swizzling_vc_%@",NSStringFromSelector(originSel)];
        SEL swizzlingSel = NSSelectorFromString(swizz) ;
        
        [self swapOriginSel:originSel andSwizzlingSel:swizzlingSel] ;
    }
}

+ (void)swapOriginSel:(SEL)originSel andSwizzlingSel:(SEL)swizzlingSel
{
    Method originMethod = class_getInstanceMethod(self, originSel) ;
    Method swizzlingMethod = class_getInstanceMethod(self, swizzlingSel) ;
    //重写方法实现
    
    IMP originImp = method_getImplementation(originMethod) ;
    IMP swizzlingImp = method_getImplementation(swizzlingMethod) ;
    if ( originImp != NULL && swizzlingImp != NULL) {
        method_exchangeImplementations(originMethod, swizzlingMethod) ;
    }
    
}

- (void)dd_swizzling_vc_viewDidAppear:(BOOL)animated
{
    DDLog(@"%@---%@",self,NSStringFromSelector(_cmd)) ;
    [self dd_swizzling_vc_viewDidAppear:animated] ;
}

- (void)dd_swizzling_vc_viewWillAppear:(BOOL)animated
{
    DDLog(@"%@---%@",self,NSStringFromSelector(_cmd)) ;
    [self dd_swizzling_vc_viewWillAppear:animated] ;
}

- (void)dd_swizzling_vc_viewWillDisappear:(BOOL)animated
{
    DDLog(@"%@---%@",self,NSStringFromSelector(_cmd)) ;
    [self dd_swizzling_vc_viewWillDisappear:animated] ;
}

- (void)dd_swizzling_vc_viewDidDisappear:(BOOL)animated
{
    DDLog(@"%@---%@",self,NSStringFromSelector(_cmd)) ;
    [self dd_swizzling_vc_viewDidDisappear:animated] ;
}
@end
