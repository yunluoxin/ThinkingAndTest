//
//  DDDeviceManager.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/9/30.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDeviceManager : NSObject


/**
 获取当前的设备型号
 
 @return 设备型号字符串
 */
+ (NSString *)currentDeviceModel;

@end
