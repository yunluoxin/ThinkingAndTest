//
//  ConfigManager.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/12/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ConfigManager.h"

@interface ConfigManager ()

@property (nonatomic, strong) NSMutableArray * vendors ;

@end

@implementation ConfigManager

static id manager;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init] ;
    });
    return manager ;
}

+ (void)needToConfigure:(Class) clazz
{
    NSAssert(clazz, @"needToConfigure:不能传入空值") ;
    
    if ([clazz instancesRespondToSelector:@selector(configure)]) {
        [[ConfigManager sharedManager].vendors addObject:clazz] ;
    }
}

+ (void)configure
{
    for (Class clazz in [ConfigManager sharedManager].vendors) {
        
        id<ConfigManagerDelegate> instance = [clazz new] ;
        
        [instance performSelector:@selector(configure)] ;
    }
    
    // 全部配置完成后，进行清空，以释放出内存
    manager = nil;
}


#pragma mark - setter and getter

- (NSMutableArray *)vendors
{
    if (!_vendors) {
        _vendors = [NSMutableArray array] ;
    }
    return _vendors ;
}
@end

