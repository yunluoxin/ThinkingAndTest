//
//  DDCalendarView.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDCalendarView ;
@class DDCalendarDayItem ;
@class DDCalendarMonthItem ;

@protocol DDCalendarViewDelegate <NSObject>
@optional
// 选择了日历中的某一天
- (void)calendarView:(DDCalendarView *)calendarView didSelectAtItem:(DDCalendarDayItem *)dayItem ;
// 滚动到某一个年月
- (void)calendarView:(DDCalendarView *)calendarView didScrollToItem:(DDCalendarMonthItem *)monthItem ;
@end


@interface DDCalendarView : UIView

/// 月份数据
@property (strong, nonatomic)NSArray<DDCalendarMonthItem *> * monthItems ;

@property (weak, nonatomic) id <DDCalendarViewDelegate> delegate ;

@end

/// 当前视图的高 ---- 固定值
FOUNDATION_EXPORT const CGFloat DDCalendarViewHeight ;
