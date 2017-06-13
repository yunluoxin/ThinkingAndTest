//
//  DDCalendarMonthItem.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCalendarDayItem.h"

@interface DDCalendarMonthItem : NSObject

/**
 *  当前的月份
 */
@property (assign, nonatomic)NSUInteger month ;

/**
 *  当前的年份
 */
@property (assign, nonatomic)NSUInteger year ;

/**
 *  当前月份下的所有天数数据
 */
@property (strong, nonatomic)NSArray <DDCalendarDayItem *> * items ;

@end
