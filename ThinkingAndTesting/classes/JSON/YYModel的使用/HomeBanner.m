//
//  HomeBanner.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "HomeBanner.h"

@implementation HomeBanner

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"test_b":HomeBannerTitle.class,
             @"test_c":HomeBannerTitle.class,
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"deviceLevel":@"device_level",
             };
}
@end

@implementation HomeBannerTitle
@end
