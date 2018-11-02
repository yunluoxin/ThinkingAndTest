//
//  VolumeButtonObserverViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/2.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "VolumeButtonObserverViewController.h"
#import <AVKit/AVKit.h>
#import <MediaToolbox/MediaToolbox.h>
@interface VolumeButtonObserverViewController ()

@end

@implementation VolumeButtonObserverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL resutl = [self addHardKeyVolumeListener];
    DDLog(@"%@", resutl ? @"YES": @"NO");
    
    dispatch_time_t triggleTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC));
//    sleep(2);
    dispatch_time_t now = dispatch_time(DISPATCH_TIME_NOW, 0);
    DDLog(@"%lld", now);
    DDLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    DDLog(@"%d", now > triggleTime);
}

- (BOOL)addHardKeyVolumeListener
{
    OSStatus s = AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                                 volumeListenerCallback,
                                                 NULL);
    return s == kAudioSessionNoError;
}

void volumeListenerCallback (
                             void                      *inClientData,
                             AudioSessionPropertyID    inID,
                             UInt32                    inDataSize,
                             const void                *inData
                             ){
    const float *volumePointer = inData;
    float volume = *volumePointer;
    NSLog(@"volumeListenerCallback %f", volume);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_time_t now = dispatch_time(DISPATCH_TIME_NOW, 0);
    DDLog(@"%lld", now);
}
@end
