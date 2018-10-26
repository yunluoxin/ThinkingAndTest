//
//  CameraContainerView.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraContainerView : UIView

@property (readonly) UIView *maskView; ///< 高斯模糊遮罩视图

- (void)showMaskWithAnimation:(BOOL)animated andDuration:(NSTimeInterval)duration complete:(nullable void (^)(void))completeHandler;

- (void)hideMaskWithAnimation:(BOOL)animated andDuration:(NSTimeInterval)duration complete:(void (^)(void))completeHandler;

@end

NS_ASSUME_NONNULL_END
