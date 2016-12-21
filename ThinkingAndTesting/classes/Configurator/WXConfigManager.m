//
//  WXConfigManager.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/12/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "WXConfigManager.h"

@implementation WXConfigManager

+ (void)load
{
    [ConfigManager needToConfigure:self] ;
}

- (void)configure
{
    DDLog(@"微信配置过程") ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}
@end
