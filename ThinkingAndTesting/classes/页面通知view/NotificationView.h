//
//  NotificationView.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/4.
//  Copyright © 2016年 dadong. All rights reserved.
//

/*
    ||
    ||   
    ||
 
 */

#import <UIKit/UIKit.h>

@interface NotificationView : UIView

+ (instancetype) notificationView ;

@property (nonatomic, copy) NSString * content ;

@property (nonatomic, strong) UIColor * contentColor ;

@property (nonatomic, strong) UIColor * contentBackgroundColor ;

@end
