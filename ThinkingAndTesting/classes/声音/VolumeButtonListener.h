//
//  VolumeButtonListener.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/31.
//  Copyright © 2018 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VolumeButtonListener;

@protocol VolumeButtonListenerDelegate <NSObject>
@optional
- (void)volumeButtonListener:(VolumeButtonListener *)listener startReceivingLongPressEventAtTime:(NSTimeInterval)beginTime;
- (void)volumeButtonListener:(VolumeButtonListener *)listener endReceivingLongPressEventAtTime:(NSTimeInterval)endTime;
- (void)volumeButtonListener:(VolumeButtonListener *)listener didReceiveShortPressAtTime:(NSTimeInterval)endTime;
@end

NS_ASSUME_NONNULL_BEGIN

@interface VolumeButtonListener : NSObject
@property (weak, nonatomic) id<VolumeButtonListenerDelegate> delegate;

- (void)beginListening;
- (void)endListening;
@end

NS_ASSUME_NONNULL_END
