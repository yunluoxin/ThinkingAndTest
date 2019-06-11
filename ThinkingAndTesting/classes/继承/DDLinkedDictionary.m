//
//  DDLinkedDictionary.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/6/3.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "DDLinkedDictionary.h"

@implementation DDLinkedDictionary

- (instancetype)init {
    if (self = [super init]) {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    if (self = [super init]) {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    _orderKeys = [NSMutableArray array];
    _interal = [NSMutableDictionary dictionary];
}

- (id)objectForKey:(id)aKey {
    if (!aKey) return nil;
    return [_interal objectForKey:aKey];
}

- (id)objectForKeyedSubscript:(id)key {
    if (!key) return nil;
    return [_interal objectForKeyedSubscript:key];
}

- (NSUInteger)count {
    return _orderKeys.count;
}

#pragma mark -  (NSExtendedMutableDictionary)

- (void)removeObjectForKey:(id)aKey {
    [_orderKeys removeObject:aKey];
    [_interal removeObjectForKey:aKey];
}

- (void)removeAllObjects {
    [_orderKeys removeAllObjects];
    [_interal removeAllObjects];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        NSAssert(false, @"-setObject:forKey:,key can't be nil");
        return;
    }
    // set key = nil时候，allKeys不能打印出来，所以需要去掉
    if (anObject == nil) {
        [_orderKeys removeObject:aKey];
        [_interal removeObjectForKey:aKey];
        return;
    }
    
    // 利用_interal去重
    if (!_interal[aKey]) {
        [_orderKeys addObject:aKey];
    }
    [_interal setObject:anObject forKey:aKey];
}

- (void)setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        NSAssert(false, @"-setObject:forKeyedSubscript:, key can't be nil");
        return;
    }
    // set key = nil时候，allKeys不能打印出来，所以需要去掉
    if (anObject == nil) {
        [_orderKeys removeObject:key];
        [_interal removeObjectForKey:key];
        return;
    }
    
    // 利用_interal去重
    if (!_interal[key]) {
        [_orderKeys addObject:key];
    }
    [_interal setObject:anObject forKeyedSubscript:key];
}

- (void)addEntriesFromDictionary:(DDLinkedDictionary *)otherDictionary {
    NSArray *otherOrderKeys = otherDictionary->_orderKeys.copy;
    for (id key in otherOrderKeys) {
        if (!self[key]) {
            [_orderKeys addObject:key];
        }
    }
    [_interal addEntriesFromDictionary:otherDictionary];
}

- (void)setDictionary:(DDLinkedDictionary *)otherDictionary {
    _orderKeys = otherDictionary->_orderKeys.mutableCopy;
    [_interal setDictionary:otherDictionary];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop))block {
    if (!block) return;
    
    BOOL stop = NO;
    
    for (id key in _orderKeys) {
        if (stop) break;

        block(key, self[key], &stop);
    }
}

- (NSEnumerator *)keyEnumerator {
    return [_orderKeys objectEnumerator];
}

@end


@implementation DDLinkedDictionary (NSExtendedDictionary)

- (NSArray *)allKeys {
    return _orderKeys.copy;
}

- (NSArray *)allKeysForObject:(id)anObject {
    NSMutableArray *keys = @{}.mutableCopy;
    for (id key in _orderKeys) {
        id value = _interal[key];
        if (value == anObject) {
            [keys addObject:key];
        }
    }
    if (keys.count > 0) {
        return keys.copy;
    }
    return nil;
}

- (NSArray *)allValues {
    NSMutableArray *values = @{}.mutableCopy;
    for (id key in _orderKeys) {
        id value = _interal[key];
        [values addObject:value];
    }
    return values.copy;
}

- (NSString *)description {
    NSMutableString *sb = [NSMutableString string];
    [sb appendString:@"{\n"];
    for (NSInteger i = 0; i < _orderKeys.count; i++) {
        id key = _orderKeys[i];
        id value = self[key];
        [sb appendFormat:@"%@ = %@;\n",key, value];
    }
    [sb appendString:@"\n}"];
    return sb.copy;
}

- (NSString *)debugDescription {
    NSMutableString *sb = [NSMutableString string];
    [sb appendString:@"{\n"];
    for (NSInteger i = 0; i < _orderKeys.count; i++) {
        id key = _orderKeys[i];
        id value = self[key];
        [sb appendFormat:@"%@ = %@;\n",key, value];
    }
    [sb appendString:@"\n}"];
    return sb.copy;
}

- (NSString *)descriptionInStringsFileFormat {
    return [self description];
}

/**
 调用NSDictionary的NSLog的时候，执行的是这个，而不是description方法
 @param locale 调试中发现是nil
 @return 要被打印的string
 */
- (NSString *)descriptionWithLocale:(nullable id)locale {
    return [self description];
}

- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [self description];
}

- (BOOL)isEqualToDictionary:(DDLinkedDictionary *)otherDictionary {
    if (!otherDictionary || ![otherDictionary isKindOfClass:DDLinkedDictionary.class]) {
        return NO;
    }
    return [_interal isEqualToDictionary:otherDictionary->_interal];
}

@end

