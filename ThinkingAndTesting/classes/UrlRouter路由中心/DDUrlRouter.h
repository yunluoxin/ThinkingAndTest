//
//  DDUrlRouter.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UrlRouterAllPagesConstants.h"

@protocol DDUrlRouterProtocol <NSObject>

@optional
- (void)configureWithParams:(NSDictionary *)params ;

@end


@interface DDUrlRouter : NSObject


+ (UIViewController *)viewControllerWithUrlFromWeb:(NSString *)url ;



+ (UIViewController *)viewControllerWithUrlFromNative:(NSString *)url ;
/**
 @param url 路径key
 @param params 用来传参数用的，里面可以放UIImage等其他对象，解决url字符串无法传对象问题。另外回调的block也可以写在里面
 @return 得到的一个viewcontroller实例
 */
+ (UIViewController *)viewControllerWithUrlFromNative:(NSString *)url params:(NSDictionary *)params ;

@end
