//
//  FileBrowseMediaViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/8/29.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "FileBrowseMediaViewController.h"
#import "FileBrowseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FileBrowseMediaViewController () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) UIButton *btnPlay;        /**< 音乐播放按钮 */
@end

@implementation FileBrowseMediaViewController

- (void)dealloc {
    [self.player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)setupUI {
    self.navigationItem.title = self.file.fileName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupRightItemShareIcon];

    [self.view addSubview:self.btnPlay];
}

- (void)setupRightItemShareIcon {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareSingleFile:)];
}


#pragma mark - Actions

/**
 分享当前文件
 */
- (void)actionShareSingleFile:(id)sender {
    if (self.file.isDir) return;
    
    NSURL *fileURL = [NSURL fileURLWithPath:self.file.filePath];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didBtnPlayClicked:(id)sender {
    if (self.player.isPlaying) {
        [self.player pause];
        [self.btnPlay setTitle:@"播放" forState:UIControlStateNormal];
    } else {
        BOOL ret = [self.player play];
        if (ret) {
            [self.btnPlay setTitle:@"暂停" forState:UIControlStateNormal];
        } else {
            DDLog(@"无法开始播放");
        }
    }
}


#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        DDLog(@"播放完毕");
        [self.btnPlay setTitle:@"播放" forState:UIControlStateNormal];
    } else {
        DDLog(@"播放不正常");
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    DDLog(@"%@", error);
}


#pragma mark - lazy load

- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _btnPlay.backgroundColor = [UIColor redColor];
        _btnPlay.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [_btnPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnPlay setTitle:@"播放" forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(didBtnPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnPlay.layer.cornerRadius = 10;
        _btnPlay.center = self.view.center;
    }
    return _btnPlay;
}

- (AVAudioPlayer *)player {
    if (!_player) {
        NSError *error;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.file.filePath] error:&error];
        if (error) {
            DDLog(@"%@", error.localizedDescription);
            return nil;
        }
        _player.delegate = self;
        _player.volume = 1.0; // 默认最大音量
        BOOL ret = [_player prepareToPlay];
        if (!ret) {
            DDLog(@"player无法准备");
        }
    }
    return _player;
}
@end
