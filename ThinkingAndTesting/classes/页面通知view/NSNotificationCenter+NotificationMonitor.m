//
//  NSNotificationCenter+NotificationMonitor.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/21.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "NSNotificationCenter+NotificationMonitor.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"

@implementation NSNotificationCenter (NotificationMonitor)

+ (void)load {
//    {
//        SEL originSel = @selector(addObserver:selector:name:object:);
//        SEL targetSel = @selector(dd_addObserver:selector:name:object:);
//        [self jr_swizzleMethod:originSel withMethod:targetSel error:nil];
//    }
//
//    {
//        SEL originSel = @selector(addObserverForName:object:queue:usingBlock:);
//        SEL targetSel = @selector(dd_addObserverForName:object:queue:usingBlock:);
//        [self jr_swizzleMethod:originSel withMethod:targetSel error:nil];
//    }
}

- (void)dd_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    if ([aName isEqualToString:UIApplicationDidBecomeActiveNotification] || [aName isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        NSHashTable *observers = [self dd_observers];
        [observers addObject:observer];
    }
    DDLog(@"will add observer: %@", observer);
    [self dd_addObserver:observer selector:aSelector name:aName object:anObject];
}

- (id<NSObject>)dd_addObserverForName:(NSNotificationName)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification * _Nonnull))block {
    id observer = [self dd_addObserverForName:name object:obj queue:queue usingBlock:block];
    if ([name isEqualToString:UIApplicationDidBecomeActiveNotification] || [name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        NSHashTable *observers = [self dd_observers];
        [observers addObject:observer];
    }
    DDLog(@"will add observer: %@", observer);
    return observer;
}

- (NSHashTable *)dd_observers {
    NSHashTable *observers = objc_getAssociatedObject(self, @selector(dd_observers));
    if (!observers) {
        observers = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        objc_setAssociatedObject(self, @selector(dd_observers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observers;
}

@end
