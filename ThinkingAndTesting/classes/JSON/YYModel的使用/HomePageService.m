//
//  HomePageService.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "HomePageService.h"

#import "YYModel.h"
#import "NSObject+DDAddForSerialization.h"
#import "HomeBanner.h"

@implementation HomePageService

+ (void)loadHomeBannerListWithCompleteHandler:(void (^)(id, NSError *))handler {
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"homeBannerList.json" ofType:nil];
    NSString *jsonStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSDictionary *data = [jsonStr dd_jsonObject];
        if (data) {
            NSArray *bannerList = [NSArray yy_modelArrayWithClass:HomeBanner.class json:data[@"data"]];
            NSLog(@"%@",bannerList);
            if (handler) {
                handler(bannerList, nil);
            }
        }
    }else{
        if (handler) {
            handler(nil, error);
        }
    }
}

@end
