//
//  UIResponder+Router.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/2/19.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routeEvent:(NSString *)eventName withInfo:(NSDictionary *)info {
    [[self nextResponder] routeEvent:eventName withInfo:info];
}

- (NSInvocation *)createInvocationForSelector:(SEL)selector {
    return [self createInvocationForSelector:selector andInfo:nil];
}

- (NSInvocation *)createInvocationForSelector:(SEL)selector andInfo:(NSDictionary *)info {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig) return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    if (info) {
        [invocation setArgument:&info atIndex:2];
    }
    return invocation;
}

@end
