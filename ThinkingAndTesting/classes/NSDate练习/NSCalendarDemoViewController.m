//
//  NSCalendarDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSCalendarDemoViewController.h"

#import "DDCalendarFactory.h"
#import "DDCalendarView.h"
@interface NSCalendarDemoViewController ()

@end

@implementation NSCalendarDemoViewController

static NSCalendar * currentCalendar ;

+ (void)initialize
{
    currentCalendar = [NSCalendar currentCalendar] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES ;
    [UIApplication sharedApplication].statusBarHidden = YES ;
    NSArray * months = [DDCalendarFactory generateMonthDatas] ;
    
    DDCalendarView * calendarView = [[DDCalendarView alloc] initWithFrame:self.view.bounds] ;
    [self.view addSubview:calendarView] ;
    calendarView.monthItems = months ;
}


- (void)test1
{
    DDLog(@"当前%zd号", [self day:[NSDate date]]) ;
    DDLog(@"当前%zd号", [self day1:[NSDate date]]) ;
    
    DDLog(@"本月共有%zd天",[self totalDaysInThisMonth:[NSDate date]]) ;
    
    DDLog(@"每周第一个工作日是%zd",[self firstWeekDay]) ;
    
    
    
}


// 尝试直接设置month，而不采用和某个日期相对加减！发现不行，这样子是直接设置成当年的某个月！
- (void)try
{
    NSDateComponents  *components = [currentCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]] ;
    
    components.month = - 2 ;
    
    NSDate * newDate = [currentCalendar dateFromComponents:components] ;
    
    DDLog(@"%@",newDate) ;
    // 2017-06-13 03:14:37: NSCalendarDemoViewController.m 第35行: 2016-10-12 16:00:00 +0000
}

/// 当前是这个月 几号
- (NSInteger)day:(NSDate *)date
{
    NSInteger component = [currentCalendar component:NSCalendarUnitDay fromDate:date] ;
    return component ;
}

- (NSInteger)day1:(NSDate *)date
{
    NSDateComponents  *components = [currentCalendar components:NSCalendarUnitDay fromDate:date] ;
    return components.day ;
}

// 一个月共有多少天
- (NSInteger)totalDaysInThisMonth:(NSDate *)date
{
    NSRange totalDaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totalDaysInMonth.length;
}

//
// firstWeekday指每周的第一个工作日是什么时候：//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
// 可以设置 calendar.firstWeekDay = 1 ; 就是从周日开始算第一个工作日。 2 就是周一开始
//
- (NSInteger)firstWeekDay
{
    return currentCalendar.firstWeekday ;
}

// 本月的第一天是第几个工作日。 （如果1是周日，则是星期+1）
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    // 每月第一天的日期
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
@end
