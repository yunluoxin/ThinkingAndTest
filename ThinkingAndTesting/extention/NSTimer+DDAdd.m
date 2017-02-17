//
//  NSTimer+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/16.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSTimer+DDAdd.h"

@implementation NSTimer (DDAdd)

+ (void)_dd_doSomething:(NSTimer *)timer
{
    void (^block)(NSTimer *) = timer.userInfo[@"block"] ;
    if (block) block(timer) ;
}

+ (instancetype)dd_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block
{
    return [self timerWithTimeInterval:interval target:self selector:@selector(_dd_doSomething:) userInfo:@{@"block":[block copy]} repeats:repeats] ;
}

+ (instancetype)dd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(_dd_doSomething:) userInfo:@{@"block":[block copy]} repeats:repeats] ;
}

@end
