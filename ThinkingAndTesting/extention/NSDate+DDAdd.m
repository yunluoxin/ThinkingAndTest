//
//  NSDate+DDAdd.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/5.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "NSDate+DDAdd.h"

@implementation NSDate (DDAdd)

- (double)timeStamp {
    return [self timeIntervalSince1970];
}

- (instancetype)dateFromTimeStamp:(double)timeStamp {
    return [NSDate dateWithTimeIntervalSince1970:timeStamp];
}

+ (double)timeStampOfDate:(NSDate *)date {
    return [date timeIntervalSince1970];
}

+ (double)currentTimeStamp {
    return [[self date] timeStamp];
}

@end
