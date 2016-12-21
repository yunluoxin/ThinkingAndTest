//
//  UMengConfigManager.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/12/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UMengConfigManager.h"

@implementation UMengConfigManager

+ (void)load
{
    [ConfigManager needToConfigure:self] ;
}

- (void)configure
{
    DDLog(@"友盟配置过程") ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}
@end
