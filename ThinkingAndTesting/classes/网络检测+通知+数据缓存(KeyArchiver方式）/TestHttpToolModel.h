//
//  TestHttpToolModel.h
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/2.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestHttpToolModel : NSObject
+ (void)test:(void (^)(id responseObj, NSError * error))block ;
@end
