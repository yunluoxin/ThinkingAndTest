//
//  DDCalendarFactory.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDCalendarFactory.h"

static const NSInteger kMonthCount = 24 ;

@implementation DDCalendarFactory

+ (NSArray *)generateMonthDatas
{
    NSMutableArray * months = @[].mutableCopy ;
    
    NSCalendar * currentCalendar = [NSCalendar currentCalendar] ;
    currentCalendar.firstWeekday = 1 ;
    
    NSDate * now = [NSDate date] ;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    for (NSUInteger index = 0; index < kMonthCount; index ++) {
        dateComponents.month = - kMonthCount / 2 + index ;
        NSDate * temp  = [currentCalendar dateByAddingComponents:dateComponents toDate:now options:0] ;
        
        DDCalendarMonthItem * monthItem = [DDCalendarMonthItem new] ;
        NSDateComponents * components = [currentCalendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:temp] ;
        monthItem.month = components.month ;
        monthItem.year  = components.year ;
        [months addObject:monthItem] ;
        
        // 当月总天数
        NSInteger totalDays = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:temp].length ;
        
        NSMutableArray * days = [NSMutableArray arrayWithCapacity:totalDays] ;
        
        // 每个月里面的数据
        for (NSUInteger j = 0; j < totalDays; j ++)
        {
            DDCalendarDayItem * dayItem = [DDCalendarDayItem new] ;
            [days addObject:dayItem] ;
            
            components.day = j + 1 ;
            NSDate * tempDate = [currentCalendar dateFromComponents:components] ;
            
            dayItem.day   = components.day ;
            dayItem.date  = tempDate ;
            dayItem.today = [currentCalendar isDate:tempDate equalToDate:now toUnitGranularity:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear] ;
            
            // 优化。 直接第一天才计算是第几个工作日
//            if (j == 0) {
//                dayItem.weekday = [currentCalendar component:NSCalendarUnitWeekday fromDate:tempDate] ;
                dayItem.weekday = [currentCalendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:tempDate] ;
//            }
        }
        monthItem.items = days.copy ;
        DDLog(@"%@",monthItem) ;
    }
    
    return months.copy ;
}

@end
