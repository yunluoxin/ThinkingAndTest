//
//  AppDelegate+DD_BackgroundSession.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (DD_BackgroundSession)

@property (nonatomic, copy) void (^backgroundSessionDidCompletedHandler)(void) ;

@end
