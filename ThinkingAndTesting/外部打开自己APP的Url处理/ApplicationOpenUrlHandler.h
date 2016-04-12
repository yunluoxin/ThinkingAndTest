//
//  ApplicationOpenUrlHandler.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonObject.h"
@interface ApplicationOpenUrlHandler : NSObject

AS_SINGLETON(ApplicationOpenUrlHandler)

- (BOOL)handleOpenUrl:(NSURL *)url ;
/**
 *  IOS9及以上才会调用的方法
 *
 */
- (BOOL)handleOpenUrl:(NSURL *)url
              options:(NSDictionary<NSString *,id> *)options ;

- (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation ;
@end
