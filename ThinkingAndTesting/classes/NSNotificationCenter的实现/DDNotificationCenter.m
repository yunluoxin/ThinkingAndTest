//
//  DDNotificationCenter.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDNotificationCenter.h"

#ifndef DDLog
#define DDLog(...) NSLog(__VA_ARGS__)
#endif

@interface _DDNotificationCenterInternalObserverStore : NSObject
/**
 *  订阅者对象
 */
@property (nonatomic, weak)id observer ;
/**
 *  订阅者对象的 对象地址
 */
@property (nonatomic, copy) NSString * observerAddress ;

/**
 *  执行的回调方法
 */
@property (assign , nonatomic)SEL callbackSelector ;
@end

@implementation _DDNotificationCenterInternalObserverStore

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES ;
    }
    
    if (!object) {
        return NO ;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO ;
    }
    
    _DDNotificationCenterInternalObserverStore * another = object ;
    if (_observer == another.observer) {
        return YES ;
    }
    return NO ;
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%p",_observer].hash ;
}
@end

@implementation DDNotification
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"WrongInitException" reason:@"please use '-initWithName:object:userInfo: to init"  userInfo:nil] ;
    return [self initWithName:@"" object:nil userInfo:nil] ;
}
- (instancetype)initWithName:(DDNotificationName)name object:(id)object userInfo:(NSDictionary *)userInfo
{
    if (self = [super init]) {
        _name = [name copy] ;
        _object = object ;
        _userInfo = userInfo ;
    }
    return self ;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"notificationName:%@, object:%@, userInfo:%@",_name,_object,_userInfo] ;
}
@end


@interface DDNotificationCenter ()

@property (nonatomic, strong) NSMutableDictionary * notifications ;

@end

@implementation DDNotificationCenter

+ (instancetype)defaultCenter
{
    static id center ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self alloc] init] ;
    });
    return center ;
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(DDNotificationName)aName object:(id)anObject
{
    if (!aName || aName.length < 1 || !observer) {
        DDLog(@"订阅失败") ;
        return ;
    }
    
    NSMutableDictionary * objs = self.notifications[aName] ;
    if (objs == nil) {
        objs = @{}.mutableCopy ;
        self.notifications[aName] = objs ;
    }
    
    NSString * type = anObject? [NSString stringWithFormat:@"%p",anObject]: @"common" ;
    
    NSMutableArray * observers = objs[type] ;
    if (observers == nil) {
        observers = @[].mutableCopy ;
        objs[type] = observers ;
    }
    
    _DDNotificationCenterInternalObserverStore * store = [_DDNotificationCenterInternalObserverStore new] ;
    store.observer = observer ;
    store.callbackSelector = aSelector ;
    store.observerAddress = [NSString stringWithFormat:@"%@",observer] ;
    [observers addObject:store] ;
}

- (void)postNotificationName:(DDNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    if (!aName || aName.length < 1) {
        DDLog(@"发布失败") ;
        return ;
    }
    
    NSMutableDictionary * dicM = self.notifications[aName] ;
    
    if (!dicM) {
        return ;
    }
    
    NSString * type = [NSString stringWithFormat:@"%p",anObject] ;

    // wrap the userInfo
    DDNotification * notification = [[DDNotification alloc] initWithName:aName object:anObject userInfo:aUserInfo] ;
    
    // 对定制有指定object的发送
    for (_DDNotificationCenterInternalObserverStore * store in dicM[type]) {
        if ([NSStringFromSelector(store.callbackSelector) hasSuffix:@":"]) {
            [store.observer performSelector:store.callbackSelector withObject:notification] ;
        }else{
            [store.observer performSelector:store.callbackSelector] ;
        }
    }
    
    // 对无特定定制的observer进行发送
    for (_DDNotificationCenterInternalObserverStore * store in dicM[@"common"]) {
        if ([NSStringFromSelector(store.callbackSelector) hasSuffix:@":"]) {
            [store.observer performSelector:store.callbackSelector withObject:notification] ;
        }else{
            [store.observer performSelector:store.callbackSelector] ;
        }
    }
    
    DDLog(@"send completely") ;
}


- (void)removeObserver:(id)observer
{
    if (observer == nil) {
        return ;
    }
    NSEnumerator * enumerator = self.notifications.objectEnumerator ;
    NSMutableDictionary * objs = nil ;
    while (objs = [enumerator nextObject]) {
        NSEnumerator * enumerator2 = objs.objectEnumerator ;
        NSMutableArray * arrayM = nil ;
        while (arrayM = [enumerator2 nextObject]) {
            NSEnumerator * enumerator3 = arrayM.objectEnumerator ;
            _DDNotificationCenterInternalObserverStore * store = nil ;
            while (store = [enumerator3 nextObject]) {
                if (store.observer == observer ||
                    (!store.observer && [store.observerAddress isEqualToString:[NSString stringWithFormat:@"%@",observer]]))
                {
                    [arrayM removeObject:store] ;
                    break ;
                }
            }
        }
    }
}

- (void)removeObserver:(id)observer name:(DDNotificationName)aName object:(id)anObject
{
    if (!observer) {
        return ;
    }

    if ((!aName || aName.length == 0) && !anObject) {
        [self removeObserver:observer] ;
        return ;
    }
    
    if (aName && aName.length > 0 && !anObject) {

        NSMutableDictionary * objs = self.notifications[aName] ;
        NSEnumerator * enumerator2 = objs.objectEnumerator ;
        NSMutableArray * arrayM = nil ;
        while (arrayM = [enumerator2 nextObject]) {
            NSEnumerator * enumerator3 = arrayM.objectEnumerator ;
            _DDNotificationCenterInternalObserverStore * store = nil ;
            while (store = [enumerator3 nextObject]) {
                if (store.observer == observer ||
                    (!store.observer && [store.observerAddress isEqualToString:[NSString stringWithFormat:@"%@",observer]]))
                {
                    [arrayM removeObject:store] ;
                    break ;
                }
            }
        }
        
        return ;
    }
    
    if (aName && aName.length > 0 && anObject){
        NSMutableDictionary * objs = self.notifications[aName] ;
        NSMutableArray * arrayM = objs[[NSString stringWithFormat:@"%p",anObject]] ;
        NSEnumerator * enumerator3 = arrayM.objectEnumerator ;
        _DDNotificationCenterInternalObserverStore * store = nil ;
        while (store = [enumerator3 nextObject]) {
            if (store.observer == observer ||
                (!store.observer && [store.observerAddress isEqualToString:[NSString stringWithFormat:@"%@",observer]]))
            {
                [arrayM removeObject:store] ;
                if (arrayM.count == 0) {
                    objs[[NSString stringWithFormat:@"%p",anObject]] = nil ;
                    [objs removeObjectForKey:[NSString stringWithFormat:@"%p",anObject]] ;
                    return ;
                }
            }
        }
        return ;
    }
    
    
    NSEnumerator * enumerator = self.notifications.objectEnumerator ;
    NSMutableDictionary * objs = nil ;
    while (objs = [enumerator nextObject]) {
        NSMutableArray * arrayM = objs[[NSString stringWithFormat:@"%p",anObject]] ;
        NSEnumerator * enumerator3 = arrayM.objectEnumerator ;
        _DDNotificationCenterInternalObserverStore * store = nil ;
        while (store = [enumerator3 nextObject]) {
            if (store.observer == observer ||
                (!store.observer && [store.observerAddress isEqualToString:[NSString stringWithFormat:@"%@",observer]]))
            {
                [arrayM removeObject:store] ;
                if (arrayM.count == 0) {
                    objs[[NSString stringWithFormat:@"%p",anObject]] = nil ;
                    [objs removeObjectForKey:[NSString stringWithFormat:@"%p",anObject]] ;
                    break ;
                }
            }
        }
    }
}


#pragma mark - lazy load

- (NSMutableDictionary *)notifications
{
    if (!_notifications) {
        _notifications = @{}.mutableCopy ;
    }
    return _notifications ;
}

- (void)dealloc
{
    [_notifications removeAllObjects] ;
    _notifications = nil ;
}

@end

