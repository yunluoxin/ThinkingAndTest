//
//  DDNotifications.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDNotifications.h"

#define DEF_NOTIFICATION(__name)\
        - (NSString *)__name \
        { \
            return [NSString stringWithFormat:@"%s", #__name]; \
        }\
        + (NSString *)__name \
        { \
            return [NSString stringWithFormat:@"%s", #__name]; \
        }

@implementation DDNotifications

DEF_NOTIFICATION(ERROR_NOT_NETWORK)
DEF_NOTIFICATION(DATA_ERROR_NOT_NETWORK)
DEF_NOTIFICATION(NETWORK_BROKEN)
DEF_NOTIFICATION(NETWORK_COME)
@end
