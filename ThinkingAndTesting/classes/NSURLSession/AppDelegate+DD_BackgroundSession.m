//
//  AppDelegate+DD_BackgroundSession.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "AppDelegate+DD_BackgroundSession.h"

#import <objc/runtime.h>

static char backgroundSessionDidCompletedHandlerKey ;

@implementation AppDelegate (DD_BackgroundSession)

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    DDLog(@"handleEventsForBackgroundURLSession:(NSString *)identifier:%@",identifier) ;
    
    self.backgroundSessionDidCompletedHandler = completionHandler ;
}

- (void (^)(void))backgroundSessionDidCompletedHandler
{
    return objc_getAssociatedObject(self, &backgroundSessionDidCompletedHandlerKey) ;
}


- (void)setBackgroundSessionDidCompletedHandler:(void (^)(void))backgroundSessionDidCompletedHandler
{
    objc_setAssociatedObject(self, &backgroundSessionDidCompletedHandlerKey, backgroundSessionDidCompletedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC) ;
}
@end
