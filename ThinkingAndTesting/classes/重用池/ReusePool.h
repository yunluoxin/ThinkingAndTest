//
//  ReusePool.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/23.
//  Copyright © 2018 dadong. All rights reserved.
//  重用池

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ReusePool;

@protocol ReusePoolDelegate <NSObject>
- (id)createNewInstanceToPool:(ReusePool *)pool;
@end

@interface ReusePool<T> : NSObject

@property (nonatomic, weak) id<ReusePoolDelegate> delegate;

- (instancetype)initWithDelegate:(id <ReusePoolDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)addNewObjectToPool:(T)obj;
- (void)addObjectsToPool:(NSArray<T> *)objs;

/// 从pool获取一个对象
- (T)getAnObjectFromPool;

/// 归还对象，重回pool
- (BOOL)returnToPool:(T)oldObj;

/// 重置pool, 会把已经使用的归到未使用中
- (void)resetPool;

/// 清空pool
- (void)emptyPool;

@end

NS_ASSUME_NONNULL_END
