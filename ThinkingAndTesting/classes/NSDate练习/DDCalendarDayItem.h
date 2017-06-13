//
//  DDCalendarDayItem.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCalendarDayItem : NSObject

/**
 *  是否当天
 */
@property (assign, nonatomic, getter=isToday)BOOL today ;

/**
 *  当前的日期
 */
@property (strong, nonatomic)NSDate * date ;

/**
 *  是否当前选中状态
 */
@property (assign, nonatomic, getter=isSelected)BOOL selected ;

/**
 *  当前是否存在回款记录
 */
@property (assign, nonatomic)BOOL hasRecord ;

/**
 *  当前是几号
 */
@property (assign, nonatomic)NSUInteger day ;

/**
 *  当前是本周第几个工作日
 */
@property (assign, nonatomic)NSUInteger weekday ;
@end
