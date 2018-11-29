//
//  MainThreadChecker.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/29.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "MainThreadChecker.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>
#import "JRSwizzle.h"

@implementation MainThreadChecker

@end

@interface UIView (MainThreadChecker)

@end

@implementation UIView (MainThreadChecker)

+ (void)load {
    [self jr_swizzleMethod:@selector(setNeedsDisplay) withMethod:@selector(dd_setNeedsDisplay) error:nil];
    [self jr_swizzleMethod:@selector(setNeedsDisplayInRect:) withMethod:@selector(dd_setNeedsDisplayInRect:) error:nil];
    [self jr_swizzleMethod:@selector(setNeedsLayout) withMethod:@selector(dd_setNeedsLayout) error:nil];
    [self jr_swizzleMethod:@selector(init) withMethod:@selector(dd_init) error:nil];
    [self jr_swizzleMethod:@selector(initWithFrame:) withMethod:@selector(dd_initWithFrame:) error:nil];

}

- (void)dd_setNeedsDisplay {
    NSAssert(pthread_main_np(), @"您必须在主线程上执行-[%@ setNeedsDisplay]代码！ 调用栈为\n %@ \n", NSStringFromClass(self.class), [NSThread callStackSymbols]);
    
    [self dd_setNeedsDisplay];
}

- (void)dd_setNeedsDisplayInRect:(CGRect)rect {
    NSAssert(pthread_main_np(), @"您必须在主线程上执行-[%@ setNeedsDisplayInRect:]代码！ 调用栈为\n %@ \n", NSStringFromClass(self.class),  [NSThread callStackSymbols]);
    
    [self dd_setNeedsDisplayInRect:rect];
}

- (void)dd_setNeedsLayout {
    NSAssert(pthread_main_np(), @"您必须在主线程上执行-[%@ setNeedsLayout]代码！ 调用栈为\n %@ \n", NSStringFromClass(self.class), [NSThread callStackSymbols]);
    
    [self dd_setNeedsLayout];
}

- (instancetype)dd_init {
    NSAssert(pthread_main_np(), @"您必须在主线程上执行-[%@ init]代码！ 调用栈为\n %@ \n", NSStringFromClass(self.class), [NSThread callStackSymbols]);
    return [self dd_init];
}

- (instancetype)dd_initWithFrame:(CGRect)frame {
    NSAssert(pthread_main_np(), @"您必须在主线程上执行-[%@ initWithFrame]代码！ 调用栈为\n %@ \n", NSStringFromClass(self.class), [NSThread callStackSymbols]);
    return [self dd_initWithFrame:frame];
}

@end


@interface CALayer (MainThreadChecker)

@end

@implementation CALayer (MainThreadChecker)


@end
