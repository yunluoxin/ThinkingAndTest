//
//  CameraContainerView.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "CameraContainerView.h"

@interface CameraContainerView ()
@property (strong, nonatomic, readwrite) UIView *maskView;
@end

@implementation CameraContainerView

- (void)showMaskWithAnimation:(BOOL)animated andDuration:(NSTimeInterval)duration complete:(void (^)(void))completeHandler {
    TIK(3);
    UIImage *snapshotImage =  [self snapshotImage];
    UIImage *blurImage = [snapshotImage blurWithBlurNumber:1];
    TOCK(3);
    self.maskView.layer.contents = (id)blurImage.CGImage;
    
    [self addSubview:self.maskView];
    
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            self.maskView.alpha = 1.0f;
        }completion:^(BOOL finished) {
            if (finished && completeHandler) completeHandler();
        }];
    } else {
        self.maskView.alpha = 1.0f;
        
        if (completeHandler) completeHandler();
    }
}

- (void)hideMaskWithAnimation:(BOOL)animated andDuration:(NSTimeInterval)duration complete:(void (^)(void))completeHandler {
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            self.maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            self.maskView.layer.contents = nil;
            
            if (finished && completeHandler) completeHandler();
        }];
    } else {
        [self.maskView removeFromSuperview];
        self.maskView.layer.contents = nil;
        self.maskView.alpha = 0;
        
        if (completeHandler) completeHandler();
    }
}

#pragma mark - override
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.maskView.frame = self.bounds;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    DDLog(@"%@", NSStringFromCGRect(self.frame));
//    DDLog(@"%@", NSStringFromCGRect(self.maskView.frame));
//    self.maskView.frame = self.bounds;
}

#pragma mark - Lazy load

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor grayColor];
        _maskView.alpha = 0.0f;
    }
    return _maskView;
}

@end
