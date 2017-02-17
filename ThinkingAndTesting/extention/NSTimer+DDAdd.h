//
//  NSTimer+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/16.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (DDAdd)

/**
 创建一个定时器，需要"手动开启"才能开始执行事件
 
 @param interval 时间间隔
 @param repeats 是否循环
 @param block 要执行的事件
 @return NSTimer定时器
 */
+ (instancetype)dd_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * __nonnull timer))block ;


/**
 创建一个定时器计划执行事件，"自动开始"执行

 @param interval 时间间隔
 @param repeats 是否循环
 @param block 要执行的事件
 @return NSTimer定时器
 */
+ (instancetype)dd_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *__nonnull timer))block ;

@end

NS_ASSUME_NONNULL_END
