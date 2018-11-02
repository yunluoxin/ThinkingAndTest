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

@property (strong, nonatomic) dispatch_source_t shortPressTimer;
@property (strong, nonatomic) dispatch_source_t longPressTimer;
@end

@implementation VolumeButtonListener
{
    BOOL isListening;                               ///< 是否正在监听中. 标志位，防止重复执行beginListening和endListening
    float volumeBeforeListening;                    ///< 在监听前的音量
    AVAudioSessionCategory categoryBeforeListening; ///< 在监听前的播放模式
    
    NSTimeInterval previousTriggerTime; ///< 上一次触发时间
    BOOL isLongPressing;                ///< 当前是否在长按中
    
    NSTimeInterval freezeAtTime;         ///< 冷却开始的时间
    BOOL isFrezzing;                    ///< 当前是否在冷却期
}

- (instancetype)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    previousTriggerTime = 0;
    freezeAtTime = 0;
    isFrezzing = NO;
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
    
    // 如果是长按中，被取消监听，则直接回调完成长按
    if (isLongPressing) {
        [self readyToEndLongPress];
    }
    
    [self p_resetAllStatus];
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
    
    // 已经判定为短按了，取消其他的，整个事件结束
    [self p_resetAllStatus];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(volumeButtonListener:didReceiveShortPressAtTime:)]) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        [self.delegate volumeButtonListener:self didReceiveShortPressAtTime:currentTime];
        
        // 响应一个事件后冷却固定时间
        freezeAtTime = [[NSDate date] timeIntervalSince1970];
        isFrezzing = YES;
    }
}

- (void)readyToEndLongPress {
    if (!isListening) return;
    
    // 已经判定为长按结束，整个事件结束
    [self p_resetAllStatus];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(volumeButtonListener:endReceivingLongPressEventAtTime:)]) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        [self.delegate volumeButtonListener:self endReceivingLongPressEventAtTime:currentTime];
        
        // 响应一个事件后冷却固定时间
        freezeAtTime = [[NSDate date] timeIntervalSince1970];
        isFrezzing = YES;
    }
}

- (void)AVSystemController_SystemVolumeDidChangeNotification:(NSNotification *)notification {
    if (![notification.userInfo[kDDVolumeChangeReason] isEqualToString:@"ExplicitVolumeChange"]) {
        return;
    }
    
    float currentVolume = [notification.userInfo[kDDCurrentVolumeValueKey] floatValue];
    DDLog(@"%s, 当前音量值: %.2f", __func__, currentVolume);
    
    if (!isListening) return;
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    if (isFrezzing && currentTime - freezeAtTime > 0.65) {
        isFrezzing = NO;
    }
    
    if (isFrezzing) return;
    
    if (!isLongPressing && !previousTriggerTime) {                         // 第一次进来
        previousTriggerTime = currentTime;
        [self openShortPressTimer];
    } else {
        NSTimeInterval passedTime = currentTime - previousTriggerTime;
        previousTriggerTime = currentTime;
        if (passedTime < 0.65 && passedTime > 0.55) {
            if (!isLongPressing) {                                         // 说明是长按，长按--开始
                [self p_secondTimeToTriggleVolumeChangeNotification];
            } else {
                // 来到这里说明每一次的notification回调卡顿了
                if (self.longPressTimer) {
                    [self closeLongPressTimer];
                    [self openLongPressTimer];
                } else {
                    DDLog(@"长按中，但是longPressTimer结束了，还没清除标志位isLongPressing??有问题");
                    [self readyToEndLongPress];
                }
            }
        } else if (passedTime < 0.15) {
            if (isLongPressing) {                                           // 继续长按中
                [self closeLongPressTimer];
                [self openLongPressTimer];
            } else {
                //
                // 按的速度神了！！两次间隔小于150ms. 我测试了好久终于出现一次
                // 直接判断为 -- 短按
                //
                [self readyToShortPress];
            }
        } else if (passedTime >= 0.15 && passedTime <= 0.55){
            if (!isLongPressing) {                                         // 快速连按
                if (passedTime < 0.3) { // 这里0.3是可以修改的。。。只是一个感觉
                    // 好吧，实在按的太块了！直接当成要执行 -- 短按
                    [self readyToShortPress];
                } else {
                    // 放弃掉第一次的，重新开始！
                    [self closeShortPressTimer];
                    [self openShortPressTimer];
                }
            } else {
                if (self.longPressTimer) {
                    // 长按中，但是之后卡了
                    [self closeLongPressTimer];
                    [self openLongPressTimer];
                } else {
                    DDLog(@"长按中，但是longPressTimer结束了，还没清除标志位isLongPressing??有问题");
                    [self readyToEndLongPress];
                }
            }
        } else {
            if (!isLongPressing && self.shortPressTimer) {
                DDLog(@"说明首次进入后，第二次就开始卡顿了");
                [self p_secondTimeToTriggleVolumeChangeNotification];
            } else if (isLongPressing && self.longPressTimer) {
                // 长按中，但是之后卡了
                [self closeLongPressTimer];
                [self openLongPressTimer];
            } else if (isLongPressing && self.shortPressTimer) {
                // 长按中，竟然还有shortTimer!
                [self closeShortPressTimer];
                [self closeLongPressTimer];
                [self openLongPressTimer];
            } else if (!isLongPressing && !self.longPressTimer) {
                // ??? 都没计时器，不是第一次进来麽。
                DDLog(@"超过了0.65s, 未知情况....可能延迟后，但是timer先结束了! %d, %f", isLongPressing, passedTime);
            }
        }
    }
}

#pragma mark - Private Methods

/// 第二次触发音量回调且要被判断为->长按开始
- (void)p_secondTimeToTriggleVolumeChangeNotification {
    isLongPressing = YES;
    
    // 取消短按的timer
    [self closeShortPressTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(volumeButtonListener:startReceivingLongPressEventAtTime:)]) {
        [self.delegate volumeButtonListener:self startReceivingLongPressEventAtTime:[[NSDate date] timeIntervalSince1970]];
    }
    
    // @patch 低端机太卡的补丁。。。
    previousTriggerTime = [[NSDate date] timeIntervalSince1970];
    
    [self openLongPressTimer];
}

/// 重置所有的状态
- (void)p_resetAllStatus {
    previousTriggerTime = 0;
    isLongPressing = NO;
    [self closeShortPressTimer];
    [self closeLongPressTimer];
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
    if (_shortPressTimer) {
        dispatch_cancel(_shortPressTimer);
        _shortPressTimer = nil;
    }
}

- (void)openShortPressTimer {
    if (!_shortPressTimer) {
        _shortPressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC));
    dispatch_source_set_timer(_shortPressTimer, start, 0, 0);
    dispatch_source_set_event_handler(_shortPressTimer, ^{
        [self readyToShortPress];
    });
    dispatch_resume(_shortPressTimer);
}

- (void)closeLongPressTimer {
    if (_longPressTimer) {
        dispatch_cancel(_longPressTimer);
        _longPressTimer = nil;
    }
}

- (void)openLongPressTimer {
    if (!_longPressTimer) {
        _longPressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC));
    dispatch_source_set_timer(_longPressTimer, start, 0, 0);
    dispatch_source_set_event_handler(_longPressTimer, ^{
        [self readyToEndLongPress];
    });
    dispatch_resume(_longPressTimer);
}
@end
