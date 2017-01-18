//
//  NSObject+DDAddKVO.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
    用block来回调kvo结果
 */
@interface NSObject (DDAddKVO)


/**
 增加一个KVO，用block回调
 --此方法可多次调用，互不影响

 @param block 检测到变化后，回调的block
 @param keyPath 指定的属性keyPath
 */
- (void)addObserverForKeyPath:(NSString *)keyPath block:(void (^)(__nonnull id obj, __nonnull id oldValue, __nonnull id newValue)) block ;


/**
 移除指定keyPath的blocks

 @param keyPath 指定的keyPath
 */
- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath ;


/**
    移除此对象所有的KVO blocks
 */
- (void)removeAllObserverBlocks ;

@end

NS_ASSUME_NONNULL_END
