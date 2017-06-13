//
//  DDCalendarViewMonthCell.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarMonthItem.h"

@interface DDCalendarViewMonthCell : UICollectionViewCell
@property (strong, nonatomic)DDCalendarMonthItem * monthItem ;

@property (copy, nonatomic) void (^whenSelectAtIndex)(DDCalendarViewMonthCell *, DDCalendarDayItem *,NSInteger) ;
@end
