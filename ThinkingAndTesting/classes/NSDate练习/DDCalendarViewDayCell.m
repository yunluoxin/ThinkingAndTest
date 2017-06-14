//
//  DDCalendarViewDayCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDCalendarViewDayCell.h"

@interface DDCalendarViewDayCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel ;
@end

@implementation DDCalendarViewDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dayLabel.layer.masksToBounds = YES ;
    
}

- (void)setDayItem:(DDCalendarDayItem *)dayItem
{
    _dayItem = dayItem ;
    
    if (dayItem.today) {
        self.dayLabel.text = @"今天" ;
        self.dayLabel.font = [UIFont systemFontOfSize:12] ;
        self.dayLabel.textColor = [UIColor blueColor] ;
    }else{
        self.dayLabel.textColor = [UIColor blackColor] ;
        self.dayLabel.text = [NSString stringWithFormat:@"%ld",dayItem.day] ;
        self.dayLabel.font = [UIFont systemFontOfSize:15] ;
    }
    
    if (dayItem.selected) {
        self.dayLabel.backgroundColor = [UIColor orangeColor] ;
    }else{
        self.dayLabel.backgroundColor = [UIColor whiteColor] ;
    }
    
    if (dayItem.hasRecord) {
        self.dayLabel.layer.cornerRadius = self.dayLabel.frame.size.width / 2 ;
        self.dayLabel.layer.borderColor = [UIColor orangeColor].CGColor ;
        self.dayLabel.layer.borderWidth = 1 / IOS_SCALE ;
    }else{
        self.dayLabel.layer.borderWidth = 0 ;
    }
    
}
@end
