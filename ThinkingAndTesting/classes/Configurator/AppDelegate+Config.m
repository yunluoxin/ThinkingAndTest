//
//  AppDelegate+Config.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/9/30.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "AppDelegate+Config.h"

@implementation AppDelegate (Config)

- (void)config {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidFinishLauchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

///
/// 在主线程执行！  在 - rootViewController的viewDidLoad 前执行
///
- (void)didReceiveApplicationDidFinishLauchingNotification:(NSNotification *)notification {

    NSLog(@"%@",[NSThread currentThread]);  // <NSThread: 0x600000063240>{number = 1, name = main}
    
//    sleep(5);
    
    // 只要执行一次，直接移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
}
@end
