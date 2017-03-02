//
//  DDHttpTool.h
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/2.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDHttpTool : NSObject

+ (void)GET_url:(NSString *)url parameters:(NSDictionary *)params needLogin:(BOOL)needLogin response:(void (^)(id responseObject, NSError * err))block ;

+ (void)POST_url:(NSString *)url parameters:(NSDictionary *)params needLogin:(BOOL)needLogin response:(void (^)(id responseObject, NSError * err))block ;

+ (void)PostWithJson_url:(NSString *)url parameters:(NSDictionary *)params needLogin:(BOOL)needLogin response:(void (^)(id responseObject, NSError * err))block ;

@end
