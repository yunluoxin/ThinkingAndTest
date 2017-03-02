//
//  TestHttpToolModel.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/2.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "TestHttpToolModel.h"
#import "DDHttpTool.h"

@implementation TestHttpToolModel

+ (void)test:(void (^)(id responseObj, NSError * error))block
{
    [DDHttpTool GET_url:@"hom1e/data" parameters:nil needLogin:NO response:^(id responseObject, NSError *err) {
        if (responseObject) {
            if (block) {
                block (responseObject, nil) ;
            }
        }else{
            if (err) {
                block(nil, err) ;
            }
        }
    }] ;
}

@end
