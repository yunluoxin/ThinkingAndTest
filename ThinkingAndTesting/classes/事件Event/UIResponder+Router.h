//
//  UIResponder+Router.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/2/19.
//  Copyright © 2019 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)

/**
 路由事件，在事件传递链上进行传递
 @param eventName 事件名
 @param info 消息
 */
- (void)routeEvent:(NSString *)eventName withInfo:(nullable NSDictionary *)info;

- (NSInvocation *)createInvocationForSelector:(SEL)selector;
/**
 以当前对象为target,和参数seletor创建一个NSInvocation
 @param selector 方法名
 @param info 方法携带的参数
 @return 创建的NSInvocation
 */
- (NSInvocation *)createInvocationForSelector:(SEL)selector andInfo:(NSDictionary *)info;

@end
