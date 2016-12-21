//
//  ConfigManager.h
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/12/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConfigManagerDelegate <NSObject>

@required
/**
 *  各个配置器必须实现的方法
 */
- (void)configure ;

@end

@interface ConfigManager : NSObject
/**
 *  用来注册的
 */
+ (void)needToConfigure:(Class) clazz ;

/**
 *  开始配置所有的配置项目
 */
+ (void) configure ;

@end
