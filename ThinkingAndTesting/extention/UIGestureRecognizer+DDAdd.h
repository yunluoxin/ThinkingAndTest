//
//  UIGestureRecognizer+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (DDAdd)

- (instancetype) initWithActionBlock:(void (^)(id sender))block ;

- (void)addActionBlock:(void (^)(id sender))block ;

- (void)removeAllBlocks ;

@end

NS_ASSUME_NONNULL_END
