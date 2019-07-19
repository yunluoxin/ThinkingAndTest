//
//  CrashKiller.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/18.
//  Copyright © 2019 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CKLog(format, ...)     \
NSString *r = [NSString stringWithFormat:format, ##__VA_ARGS__]; \
[[CrashKiller shared] ck_log:r];

NS_ASSUME_NONNULL_BEGIN

@protocol CKLogger <NSObject>
@required
/* 常规的输出 */
- (void)logText:(NSString *)txt;
@optional
/* 准备，即将开始log的通知，可以在里面做一些准备 */
- (void)readyToLog;
/* 结束输出，做收尾工作 */
- (void)stopLog;
@end

typedef NS_OPTIONS(NSInteger, CKLogOptions) {
    CKLogConsole    = 1 ,
    CKLogFile       = 1 << 1,
    CKLogFabric     = 1 << 2,
};

@interface CrashKiller : NSObject

+ (instancetype)shared;
- (void)startWithOptions:(CKLogOptions)options;

- (void)ck_log:(NSString *)content;

/** 除了内置支持的几个输出，增加额外的输出器 */
- (void)addLogger:(id<CKLogger>)logger;
@end

NS_ASSUME_NONNULL_END
