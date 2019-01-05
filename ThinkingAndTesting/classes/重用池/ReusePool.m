//
//  ReusePool.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/23.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "ReusePool.h"

@implementation ReusePool {
    NSMutableArray *_usedObjs;
    NSMutableArray *_unusedObjs;
}

#pragma mark - Initialization

- (instancetype)init {
    if ([super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<ReusePoolDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _usedObjs = @[].mutableCopy;
    _unusedObjs = @[].mutableCopy;
}

#pragma mark - API

- (void)addNewObjectToPool:(id)obj {
    if (!obj) return;
    
    [_unusedObjs addObject:obj];
}

- (void)addObjectsToPool:(NSArray *)objs {
    if (!objs) return;
    
    NSAssert([objs isKindOfClass:NSArray.class], @"您必须传入数组");
    
    [_unusedObjs addObjectsFromArray:objs];
}

- (BOOL)returnToPool:(id)oldObj {
    
    if (!oldObj) return false;
    
    if (![_usedObjs containsObject:oldObj]) return false;
    
    [_usedObjs removeObject:oldObj];
    
    [_unusedObjs addObject:oldObj];
    
    return true;
}

- (id)getAnObjectFromPool {
    if (_unusedObjs.count == 0) {
        NSLog(@"当前pool为空");
        if (_delegate && [_delegate respondsToSelector:@selector(createNewInstanceToPool:)]) {
            NSLog(@"创建中...");
            id newObj = [_delegate createNewInstanceToPool:self];
            if (newObj) {
                [_usedObjs addObject:newObj];
                NSLog(@"创建成功");
                return newObj;
            }
        }
        return nil;
    }
    
    id lastObj = [_unusedObjs lastObject];
    [_unusedObjs removeLastObject];
    [_usedObjs addObject:lastObj];
    return lastObj;
}

- (void)resetPool {
    [_unusedObjs addObjectsFromArray:_usedObjs];
    
    [_usedObjs removeAllObjects];
}

- (void)emptyPool {
    [_unusedObjs removeAllObjects];
    
    [_usedObjs removeAllObjects];
}

@end
