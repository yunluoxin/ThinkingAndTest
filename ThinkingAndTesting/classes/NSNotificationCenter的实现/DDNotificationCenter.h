//
//  DDNotificationCenter.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_3
typedef NSString *DDNotificationName NS_EXTENSIBLE_STRING_ENUM ;
#else
typedef NSString *DDNotificationName ;
#endif

@interface DDNotification : NSObject

@property (nonatomic, copy) NSString * name ;
@property (nonatomic, strong, readonly)id object ;
@property (nonatomic, strong, readonly)NSDictionary * userInfo ;

- (instancetype)initWithName:(DDNotificationName)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo NS_AVAILABLE(10_6, 4_0) NS_DESIGNATED_INITIALIZER;
//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@end

@interface DDNotificationCenter : NSObject

+ (instancetype)defaultCenter ;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable DDNotificationName)aName object:(nullable id)anObject ;

- (void)postNotificationName:(DDNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo ;

- (void)removeObserver:(id)observer ;
- (void)removeObserver:(id)observer name:(nullable DDNotificationName)aName object:(nullable id)anObject ;

/**
 @return 返回一个内部生成的Observer，用来移除通知的
 */
- (id <NSObject>)addObserverForName:(nullable NSNotificationName)name object:(nullable id)obj queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(DDNotification *note))block API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
@end



NS_ASSUME_NONNULL_END
