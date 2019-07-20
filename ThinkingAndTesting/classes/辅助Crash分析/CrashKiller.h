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

@class CrashKillerEvent;
@protocol CKLogger <NSObject>
@optional
/* 准备，即将开始log的通知，可以在里面做一些准备 */
- (void)readyToLog;
/* 常规的输出, 包含时间和id等，要输出的内容格式统一了 */
- (void)logText:(NSString *)txt;
/* 自定义输出内容的格式，拿到原始数据进行组装（常规和自定义的，建议自实现一个，否则会重复，造成浪费） */
- (void)customLogWithData:(CrashKillerEvent *)data;
/* 结束输出，做收尾工作 */
- (void)stopLog;
@end

/* 内置的几个logger */
typedef NS_OPTIONS(NSInteger, CKLogOptions) {
    CKLogConsole    = 1 ,       /**< 控制台 */
    CKLogFile       = 1 << 1,   /**< 文件log */
    CKLogFabric     = 1 << 2,   /**< 上报第三方平台Fabric */
};

@interface CrashKiller : NSObject

+ (instancetype)shared;
/**
 启动Log
 @param options 需要开启的日志选项
 */
- (void)startWithOptions:(CKLogOptions)options;

- (void)ck_log:(NSString *)content;

/** 除了内置支持的几个输出，增加额外的输出器 */
- (void)addLogger:(id<CKLogger>)logger;
@end

@interface CrashKillerEvent : NSObject
@property (nonatomic, assign, readonly) long ckId;                  /**< 事件id */
@property (nonatomic,   copy, readonly) NSString *content;          /**< 真正输出的内容 */
@property (nonatomic,   copy, readonly) NSString *onScreenPageName; /**< 当前在屏幕的VC名字 */
@property (nonatomic,   copy, readonly) NSString *createTime;       /**< 创建这个log的事件 */
@end

NS_ASSUME_NONNULL_END
