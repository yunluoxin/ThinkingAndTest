//
//  DDNotificationCenter.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *DDNotificationName NS_EXTENSIBLE_STRING_ENUM ;


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

- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo ;

- (void)removeObserver:(id)observer ;
- (void)removeObserver:(id)observer name:(nullable DDNotificationName)aName object:(nullable id)anObject ;

@end



NS_ASSUME_NONNULL_END
