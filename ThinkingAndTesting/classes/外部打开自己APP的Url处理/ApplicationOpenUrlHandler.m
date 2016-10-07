//
//  ApplicationOpenUrlHandler.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ApplicationOpenUrlHandler.h"

@implementation ApplicationOpenUrlHandler

DEF_SINGLETON(ApplicationOpenUrlHandler)

- (BOOL)handleOpenUrl:(NSURL *)url
{
    return [self handleOpenUrl:url sourceApplication:nil annotation:nil] ;
}

- (BOOL)handleOpenUrl:(NSURL *)url
              options:(NSDictionary<NSString *,id> *)options
{
    //注意： 这里面的UIApplicationOpenURLOptionsSourceApplicationKey也是只有ios9及以上才有！！！
    return [self handleOpenUrl:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  NO ;
}

@end
