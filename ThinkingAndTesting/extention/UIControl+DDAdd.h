//
//  UIControl+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (DDAdd)


/**
 重写对某一个事件已经注册的目标动作

 @param target 目标
 @param action 动作
 @param controlEvents 事件
 */
- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents ;

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block ;
- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block ;
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents ;

@end

NS_ASSUME_NONNULL_END
