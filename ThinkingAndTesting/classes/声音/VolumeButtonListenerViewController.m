//
//  VolumeButtonListenerViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/31.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "VolumeButtonListenerViewController.h"
#import "VolumeButtonListener.h"

@interface VolumeButtonListenerViewController () <VolumeButtonListenerDelegate>
@property (strong, nonatomic) VolumeButtonListener *listener;
@property (strong, nonatomic) NSTimer *longPressTimer;
@end

@implementation VolumeButtonListenerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listener = [VolumeButtonListener new];
    self.listener.delegate = self;
    [self.listener beginListening];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

#pragma mark - VolumeButtonListenerDelegate

- (void)volumeButtonListener:(VolumeButtonListener *)listener startReceivingLongPressEventAtTime:(NSTimeInterval)beginTime {
    DDLog(@"%s", __func__);
    sleep(2);
    [self openLongPressTimer];
}

- (void)volumeButtonListener:(VolumeButtonListener *)listener endReceivingLongPressEventAtTime:(NSTimeInterval)endTime {
    DDLog(@"%s", __func__);
    [self closeLongPressTimer];
}

- (void)volumeButtonListener:(VolumeButtonListener *)listener didReceiveShortPressAtTime:(NSTimeInterval)endTime {
    DDLog(@"%s", __func__);
}

- (void)readyToEndLongPress {
//    DDLog(@"%s", __func__);
    [NSThread sleepForTimeInterval:0.6];
}

- (void)closeLongPressTimer {
    if (_longPressTimer && [_longPressTimer isValid]) {
        [_longPressTimer invalidate];
        _longPressTimer = nil;
    }
}

- (void)openLongPressTimer {
    if (!_longPressTimer) {
        _longPressTimer = [NSTimer timerWithTimeInterval:0.04 target:self selector:@selector(readyToEndLongPress) userInfo:nil repeats:YES];
    }
    [[NSRunLoop mainRunLoop] addTimer:_longPressTimer forMode:NSRunLoopCommonModes];
}
@end
