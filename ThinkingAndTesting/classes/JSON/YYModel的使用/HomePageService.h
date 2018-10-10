//
//  HomePageService.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageService : NSObject

+ (void)loadHomeBannerListWithCompleteHandler:(void (^)(id responseObject, NSError *error))handler;

@end
