//
//  VolumeButtonListener.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/31.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "VolumeButtonListener.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

static NSString * const kDDSystemVolumeDidChangeNotification = @"AVSystemController_SystemVolumeDidChangeNotification";
static NSString * const kDDVolumeChangeReason = @"AVSystemController_AudioVolumeChangeReasonNotificationParameter";
static NSString * const kDDCurrentVolumeValueKey = @"AVSystemController_AudioVolumeNotificationParameter";

@interface VolumeButtonListener ()

@property (strong, nonatomic) MPVolumeView *volumeView;   ///< 音量视图（用来屏蔽系统的音量视图的）

@property (strong, nonatomic) NSTimer *shortPressTimer;
@property (strong, nonatomic) NSTimer *longPressTimer;
@end

@implementation VolumeButtonListener
{
    BOOL isListening;                               ///< 是否正在监听中. 标志位，防止重复执行beginListening和endListening
    float volumeBeforeListening;                    ///< 在监听前的音量
    AVAudioSessionCategory categoryBeforeListening; ///< 在监听前的播放模式
    
    NSTimeInterval previousTriggerTime; ///< 上一次触发时间
    BOOL isLongPressing;                ///< 当前是否在长按中
}

- (instancetype)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    previousTriggerTime = 0;
}

#pragma mark - API

/// 开始监听
- (void)beginListening {
    if (isListening) return;
    isListening = YES;
    
    categoryBeforeListening = [[AVAudioSession sharedInstance] category];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    ADD_NOTIFICATION(kDDSystemVolumeDidChangeNotification);
    
    volumeBeforeListening = [AVAudioSession sharedInstance].outputVolume;       // 存储之前的音量 (如果没active audio session, 那么这个会话声音不会跟着系统变化，再次获取是有问题的！)
    DDLog(@"volumeBeforeListening: %f", volumeBeforeListening);
    [self showSystemVolumeView:NO];
}

/// 结束监听
- (void)endListening {
    if (!isListening) return;
    isListening = NO;
    
    // 模式改变了
    if (categoryBeforeListening != [AVAudioSession sharedInstance].category) {
        [[AVAudioSession sharedInstance] setCategory:categoryBeforeListening withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    REMOVE_NOTIFICATION();  // 移除通知或者 endReceivingRemoteControlEvents 必须在恢复音量之前！否则，恢复后又收到回调了！
    
    [self restoreSystemVolume];
    [self showSystemVolumeView:YES];
    
    if ([self.shortPressTimer isValid]) [self.shortPressTimer invalidate];
    if ([self.longPressTimer isValid]) [self.longPressTimer invalidate];
    
    // 如果是长按中，被取消监听，则直接回调完成长按
    if (isLongPressing) {
        [self readyToEndLongPress];
    }
}

#pragma mark - Actions

- (void)showSystemVolumeView:(BOOL)show {
    if (!show) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
    } else {
        [self.volumeView removeFromSuperview];
    }
}

/// 还原系统原来的音量
- (void)restoreSystemVolume {
    float currentVolume = [AVAudioSession sharedInstance].outputVolume;
    if (fabs(volumeBeforeListening - currentVolume) > DBL_EPSILON) {
        DDLog(@"还原音量中");
        [MPMusicPlayerController systemMusicPlayer].volume = volumeBeforeListening;
    }
}


- (void)readyToShortPress {
    if (!isListening) return;
    
    // 已经判定为短按了，取消其他的
    previousTriggerTime = 0;
    isLongPressing = NO;
    
    [self closeShortPressTimer];
    [self closeLongPressTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(volumeButtonListener:didReceiveShortPressAtTime:)]) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        [self.delegate volumeButtonListener:self didReceiveShortPressAtTime:currentTime];
    }
}

- (void)readyToEndLongPress {
    if (!isListening) return;
    
    previousTriggerTime = 0;
    isLongPressing = NO;
    
    [self closeShortPressTimer];
    [self closeLongPressTimer];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if (self.delegate && [self.delegate respondsToSelector:@selector(volumeButtonListener:endReceivingLongPressEventAtTime:)]) {
        [self.delegate volumeButtonListener:self endReceivingLongPressEventAtTime:currentTime];
    }
}

- (void)AVSystemController_SystemVolumeDidChangeNotification:(NSNotification *)note {
    if ([note.userInfo[kDDVolumeChangeReason] isEqualToString:@"ExplicitVolumeChange"]) {
        float currentVolume = [note.userInfo[kDDCurrentVolumeValueKey] floatValue];
        DDLog(@"%s, 当前音量值: %.2f", __func__, currentVolume);
        
        if (!isListening) return;
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        if (!isLongPressing && !previousTriggerTime) {          // 第一次进来
            previousTriggerTime = currentTime;
            [self openShortPressTimer];
        } else {
            NSTimeInterval passedTime = currentTime - previousTriggerTime;
            previousTriggerTime = currentTime;
            if (!isLongPressing && passedTime < 0.65 && passedTime > 0.55) {   // 说明是长按，长按--开始
                isLongPressing = YES;
                [self closeShortPressTimer];  ///< 取消短按的timer
                [self openLongPressTimer];
                if (self.delegate && [self.delegate respondsToSelector:@selector(volumeButtonListener:startReceivingLongPressEventAtTime:)]) {
                    [self.delegate volumeButtonListener:self startReceivingLongPressEventAtTime:currentTime];
                }
            } else if (isLongPressing && passedTime < 0.15) {   // 继续长按中
                [self closeLongPressTimer];
                [self openLongPressTimer];
                
            } else {                                            // 快速连按
                
            }
        }
    }
}

#pragma mark - Lazy load

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width, -[UIScreen mainScreen].bounds.size.width, 10, 10)];
        _volumeView.hidden = NO;
    }
    return _volumeView;
}

- (void)closeShortPressTimer {
    if (_shortPressTimer && [_shortPressTimer isValid]) {
        [_shortPressTimer invalidate];
        _shortPressTimer = nil;
    }
}

- (void)openShortPressTimer {
    if (!_shortPressTimer) {
        _shortPressTimer = [NSTimer timerWithTimeInterval:0.65 target:self selector:@selector(readyToShortPress) userInfo:nil repeats:NO];
    }
    [[NSRunLoop mainRunLoop] addTimer:_shortPressTimer forMode:NSRunLoopCommonModes];
}

- (void)closeLongPressTimer {
    if (_longPressTimer && [_longPressTimer isValid]) {
        [_longPressTimer invalidate];
        _longPressTimer = nil;
    }
}

- (void)openLongPressTimer {
    if (!_longPressTimer) {
        _longPressTimer = [NSTimer timerWithTimeInterval:0.15 target:self selector:@selector(readyToEndLongPress) userInfo:nil repeats:NO];
    }
    [[NSRunLoop mainRunLoop] addTimer:_longPressTimer forMode:NSRunLoopCommonModes];
}

@end
