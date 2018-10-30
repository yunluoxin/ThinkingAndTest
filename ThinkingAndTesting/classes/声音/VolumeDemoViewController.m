//
//  VolumeDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/30.
//  Copyright © 2018 dadong. All rights reserved.
//
//  音量监听的Demo
//

#import "VolumeDemoViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

static NSString * const kDDSystemVolumeDidChangeNotification = @"AVSystemController_SystemVolumeDidChangeNotification";
static NSString * const kDDVolumeChangeReason = @"AVSystemController_AudioVolumeChangeReasonNotificationParameter";
static NSString * const kDDCurrentVolumeValueKey = @"AVSystemController_AudioVolumeNotificationParameter";

@interface VolumeDemoViewController () {
    float volumeBeforeListening;                    ///< 在监听前的音量
    AVAudioSessionCategory categoryBeforeListening; ///< 在监听前的播放模式
}

@property (strong, nonatomic) MPVolumeView *volumeView;   ///< 音量视图（用来屏蔽系统的音量视图的）
@property (assign, nonatomic) BOOL isInBackground;        ///< 当前是否在后台

@end

@implementation VolumeDemoViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"Touch Me" forState:UIControlStateNormal];
    [button setTitle:@"Touch Me(selected)" forState:UIControlStateSelected];
    button.backgroundColor = [UIColor cyanColor];
    [button addTarget:self action:@selector(didPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

/// 开始监听
- (void)beginListening {
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
    // 模式改变了
    if (categoryBeforeListening != [AVAudioSession sharedInstance].category) {
        [[AVAudioSession sharedInstance] setCategory:categoryBeforeListening withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    REMOVE_NOTIFICATION();  // 移除通知或者 endReceivingRemoteControlEvents 必须在恢复音量之前！否则，恢复后又收到回调了！
    
    [self restoreSystemVolume];
    [self showSystemVolumeView:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self beginListening];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self endListening];
    [super viewWillDisappear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dd_navigateTo:[self.class new]];
}

- (void)didPress:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [self showSystemVolumeView:!sender.selected];
}

- (void)showSystemVolumeView:(BOOL)show {
    if (!show) {
        [self.view addSubview:self.volumeView];
    } else {
        [self.volumeView removeFromSuperview];
    }
}

/// 还原系统原来的音量
- (void)restoreSystemVolume {
    float currentVolume = [AVAudioSession sharedInstance].outputVolume;
    if (fabs(volumeBeforeListening - currentVolume) > DBL_EPSILON) {
        [MPMusicPlayerController systemMusicPlayer].volume = volumeBeforeListening;
    }
}

- (void)AVSystemController_SystemVolumeDidChangeNotification:(NSNotification *)note {
    DDLog(@"%@", note);
    if ([note.userInfo[kDDVolumeChangeReason] isEqualToString:@"ExplicitVolumeChange"]) {
        float currentVolume = [note.userInfo[kDDCurrentVolumeValueKey] floatValue];
        DDLog(@"当前音量值: %.2f", currentVolume);
    }
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-DD_SCREEN_WIDTH, -DD_SCREEN_WIDTH, 10, 10)];
        _volumeView.hidden = NO;
    }
    return _volumeView;
}

@end
