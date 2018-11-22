//
//  BPNotificationCenter.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/21.
//  Copyright © 2018 dadong. All rights reserved.
//

#if enable_intercept_notification
#import "BPNotificationCenter.h"
#import <objc/runtime.h>
#import "DDNotificationCenter.h"
#ifndef DDLog
#define DDString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DDLog(...) printf("%s: %s 第%d行: %s\n\n",[[BPNotificationCenter currentDateString] UTF8String], [DDString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#endif

@interface BPNotificationCenter (Log)
+ (NSString *)currentDateString;
@end

@implementation BPNotificationCenter (Log)
+ (NSString *)currentDateString {
    static NSDateFormatter *dateFormatter = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
    });
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}
@end

static NSMutableSet *excludeObserverClassNames; ///< 排除监视的列表
static NSMutableDictionary *observers;

@implementation BPNotificationCenter

+ (void)initialize {
    NSArray *excludeObserverClassNames_ = @[
                                            UIScreen.class,
                                            UIWindow.class,
                                            object_getClass(UIScreen.class),
                                            object_getClass(UIWindow.class),
//                                            NSClassFromString(@"__NSObserver"),
//                                            NSClassFromString(@"UIMotionEvent"),
//                                            NSClassFromString(@"AVPlayer"),
//                                            NSClassFromString(@"WKContentView"),
//                                            NSClassFromString(@"CMMotionManager"),
                                            ];
    excludeObserverClassNames = [NSMutableSet setWithArray:excludeObserverClassNames_];
    observers = @{}.mutableCopy;
}

+ (void)load {
    //确保两个类大小一样，也就是说aClass不能声明任何 ivar 或者合成属性
    NSAssert(class_getInstanceSize([self class]) == class_getInstanceSize([NSNotificationCenter class]), @"Classes must be the same size to swizzle.");
    object_setClass([NSNotificationCenter defaultCenter], self);
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    if (
        ([aName isEqualToString:UIApplicationWillEnterForegroundNotification] || [aName isEqualToString:UIApplicationDidBecomeActiveNotification]) &&
        ![excludeObserverClassNames containsObject:[observer class]] &&
        ![NSStringFromClass([observer class]) hasPrefix:@"UI"] &&
        ![NSStringFromClass([observer class]) hasPrefix:@"_UI"] &&
        ![observer isKindOfClass:NSClassFromString(@"__NSObserver")]
        ) {
        DDLog(@"will add observer %@ for %@", observer, aName);
        NSHashTable *os = observers[aName];
        if (!os) {
            os = [NSHashTable weakObjectsHashTable];
            observers[aName] = os;
        }
        [os addObject:observer];
        [[DDNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
        return;
    }
    [super addObserver:observer selector:aSelector name:aName object:anObject];
}

- (id<NSObject>)addObserverForName:(NSNotificationName)aName object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification * _Nonnull))block {
    id observer = [super addObserverForName:aName object:obj queue:queue usingBlock:block];
    return observer;
}

- (void)postNotificationName:(NSNotificationName)name object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    if (
        ([name isEqualToString:UIApplicationWillEnterForegroundNotification] || [name isEqualToString:UIApplicationDidBecomeActiveNotification])
        ) {
        //        DDLog(@"\n\n\nUIApplicationWillEnterForegroundNotification: %@\n\n\n\n",[observers[UIApplicationWillEnterForegroundNotification] allObjects]);
        DDLog(@"ready to post notification, name is %@", name);
        double start = CFAbsoluteTimeGetCurrent();
        //        [super postNotificationName:name object:anObject userInfo:aUserInfo];
        [[DDNotificationCenter defaultCenter] postNotificationName:name object:anObject userInfo:aUserInfo];
        DDLog(@"end posting notification, name is %@, cost %fs", name, CFAbsoluteTimeGetCurrent() - start);
    }
    
    [super postNotificationName:name object:anObject userInfo:aUserInfo];
    
}

- (void)removeObserver:(id)observer {
    [super removeObserver:observer];
    [[DDNotificationCenter defaultCenter] removeObserver:observer];
}

- (void)removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject {
    [super removeObserver:observer name:aName object:anObject];
    [[DDNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
}

- (NSString *)description {
    return [super description];
}

- (NSString *)debugDescription {
    return [super debugDescription];
}

- (Class)class {
    return class_getSuperclass(object_getClass(self));
}
@end
#endif
