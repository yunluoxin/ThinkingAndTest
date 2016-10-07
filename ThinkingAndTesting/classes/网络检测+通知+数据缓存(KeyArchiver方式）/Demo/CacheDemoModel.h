//
//  CacheDemoModel.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

//#import "DDModel.h"
#import "NSObject+DDModel.h"
FOUNDATION_EXPORT NSString * const DDGoodsDetailNotification ;

@interface CacheDemoModel : NSObject
- (void) getSomethingById:(NSString *)somethingId;
//+ (NSString *)getSomethingById:(NSString *)somethingId;
@end
