//
//  NSDate+DDAdd.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/5.
//  Copyright © 2018 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DDAdd)
/// 当前的时间戳
+ (double)currentTimeStamp;

/**
 当前对象->时间戳
 */
- (double)timeStamp;

/**
 指定时间的时间戳
 */
+ (double)timeStampOfDate:(NSDate *)date;

/**
 从时间戳得到Date对象

 @param timeStamp 时间戳
 @return 一个NSDate对象
 */
- (instancetype)dateFromTimeStamp:(double)timeStamp;

@end

NS_ASSUME_NONNULL_END
