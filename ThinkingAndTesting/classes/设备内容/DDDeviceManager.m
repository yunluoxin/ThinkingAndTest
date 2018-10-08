//
// DDDeviceManager.m
// ThinkingAndTesting
//
// Created by zhangxiaodong on 2018/9/30.
// Copyright © 2018年 dadong. All rights reserved.
//

#import"DDDeviceManager.h"

#include <sys/types.h>
#include <sys/sysctl.h>

static char *const kSysctlDeviceModelName = "hw.machine";

@implementation DDDeviceManager

/// 可通过苹果Review
+ (NSString *)getDeviceModelInternalString {
    size_t size;
    sysctlbyname(kSysctlDeviceModelName, NULL, &size, NULL, 0);
    
    char *machine = (char*)malloc(size);
    sysctlbyname(kSysctlDeviceModelName, machine, &size, NULL, 0);
    
    NSString *platform =[NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}



+ (NSString *)currentDeviceModel {
    NSString *platform = [self getDeviceModelInternalString];
    if([platform
    isEqualToString:@"iPhone1,1"])return@"iPhone1G";
    if([platform
    isEqualToString:@"iPhone1,2"])return@"iPhone3G";
    if([platform
    isEqualToString:@"iPhone2,1"])return@"iPhone3GS";
    if([platform
    isEqualToString:@"iPhone3,1"])return@"iPhone4";
    if([platform isEqualToString:@"iPhone3,2"])
    return@"VerizoniPhone4";
    if([platform
    isEqualToString:@"iPod1,1"])return@"iPodTouch1G";
    if([platform
    isEqualToString:@"iPod2,1"])return@"iPodTouch2G";
    if([platform
    isEqualToString:@"iPod3,1"])return@"iPodTouch3G";
    if([platform
    isEqualToString:@"iPod4,1"])return@"iPodTouch4G";
    if([platform
    isEqualToString:@"iPad1,1"])return@"iPad";
    if([platform
    isEqualToString:@"iPad2,1"])return@"iPad2(WiFi)";
    if([platform
    isEqualToString:@"iPad2,2"])return@"iPad2(GSM)";
    if([platform
    isEqualToString:@"iPad2,3"])return@"iPad2(CDMA)";
    if([platform
    isEqualToString:@"i386"]) return@"Simulator";

    return platform;
}


@end

// 输出：
// @"iPad1,1"
// @"iPad2,1"
// @"i386"


// 逗号后面数字解释：(i386是指模拟器)
// 1-WiFi版
// 2-GSM/WCDMA3G版
// 3-CDMA版

