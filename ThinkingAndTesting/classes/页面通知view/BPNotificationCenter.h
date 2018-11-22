//
//  BPNotificationCenter.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/21.
//  Copyright © 2018 dadong. All rights reserved.
//

#define enable_intercept_notification 0     // 是否开启通知，1为开启，0为不开启
#ifndef DEBUG
enable_intercept_notification 0
#endif


#if enable_intercept_notification
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPNotificationCenter : NSNotificationCenter

@end

NS_ASSUME_NONNULL_END

#endif
