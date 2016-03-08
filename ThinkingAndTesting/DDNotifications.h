//
//  DDNotifications.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

/**添加一个通知**/
#define ADD_NOTIFICATION(notificationName) ([[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString([NSString stringWithFormat:@"%@:",notificationName]) name:notificationName object:nil])

/**发送一个通知**/
#define POST_NOTIFICATION(notificationName,userinfo) ([[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userinfo])

/**移除所有通知**/
#define REMOVE_NOTIFICATION() ([[NSNotificationCenter defaultCenter] removeObserver:self])

#import <Foundation/Foundation.h>

#define AS_NOTIFICATION(__name)\
        - (NSString *)__name;\
		+ (NSString *)__name;

@interface DDNotifications : NSObject

#pragma mark - 网络模块

//无网络
AS_NOTIFICATION(ERROR_NOT_NETWORK)

//获取数据失败（由于无网络）
AS_NOTIFICATION(DATA_ERROR_NOT_NETWORK)

//网络连接中断
AS_NOTIFICATION(NETWORK_BROKEN)

//网络连接恢复
AS_NOTIFICATION(NETWORK_COME)


@end
