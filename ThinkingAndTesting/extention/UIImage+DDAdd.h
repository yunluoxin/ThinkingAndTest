//
//  UIImage+DDAdd.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DDAdd)

@end

@interface UIImage (Filter)

///
/// 利用 vImage
/// @param blur 必须0<=blur<=1
///
+ (UIImage *)blurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

- (UIImage *)blurWithBlurNumber:(CGFloat)blur;

@end

@interface UIImage (ImageOrientation)
- (instancetype)transfromToOrientation:(UIImageOrientation)orientation;
+ (instancetype)transformImage:(UIImage *)originImage toOrientation:(UIImageOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
