//
//  AMapConfigManager.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/12/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AMapConfigManager.h"

@implementation AMapConfigManager

+ (void)load
{
    [ConfigManager needToConfigure:self] ;
}

- (void)configure
{
    DDLog(@"高德配置过程") ;
}

@end
