//
//  AD.h
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AD : NSObject
@property (nonatomic, copy)NSString * code ;                    // 活动编号,字符串类型
@property (nonatomic, copy)NSString * name ;                    // 活动名称
@property (nonatomic, copy)NSString * adImage ;                 // 活动广告图片
@property (nonatomic, copy)NSString * exhibition ;              // 活动钻展图片
@property (nonatomic, copy)NSString * page ;                    // 活动详情页面地址
@property (nonatomic, copy)NSString * startTime ;               // 活动开始时间
@property (nonatomic, copy)NSString * endTime ;                 // 活动结束时间
@end
