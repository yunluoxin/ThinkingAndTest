//
//  URRequest.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/28.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, URRequestType){
    URRequestTypeWeb ,
    URRequestTypeNative,
    URRequestTypeNotification,
    URRequestTypeInterApp
};

@interface URRequest : NSObject

/** 原始请求的Url */
@property (nonatomic,   copy, readonly) NSString      *  originalUrl ;
@property (nonatomic, assign, readonly) URRequestType    requestType ;


/// 便利的获取方法
/** 根据originalURL生成的NSURL对象 */
@property (nonatomic, readonly) NSURL    *  URL ;
@property (nonatomic, readonly) NSString * scheme ;
@property (nonatomic, readonly) NSString * host ;
@property (nonatomic, readonly) NSString * path ;
@property (nonatomic, readonly) NSString * fullPath ;   // host + path
@property (nonatomic, readonly) NSDictionary * params ;

- (instancetype) initWithUrl:(NSString *)originalUrl    withType:(URRequestType)type NS_DESIGNATED_INITIALIZER ;
+ (instancetype) requestWithUrl:(NSString *)originalUrl withType:(URRequestType)type ;

@end
