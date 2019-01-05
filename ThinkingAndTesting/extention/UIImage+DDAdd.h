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
/**
 通过图片名和bundle名加载一张图片
 
 @param imageName 图片名， 和系统的使用类似，如果是png的，可以只传名字，但是如果是jpg或者其他格式的，必须全名
 @param bundleName bundle名
 @return UIImage实例
 */
+ (instancetype)imageNamed:(NSString *)imageName inBundleNamed:(NSString *)bundleName;

/**
 通过文件名和bundle名加载一张图片

 @param imageFileName 图片文件名， 必须是全名!!！ 比如 icon_test_normal@2x.png, bg_beauty_hah.jpg
 @param bundleName bundle名
 @return UIImage实例
 */
+ (instancetype)imageFileNamed:(NSString *)imageFileName inBundleNamed:(NSString *)bundleName;
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

/**
 改变图片的朝向，生成新图片
 
 @param orientation UIImage的朝向
 @return 新的UIImage对象
 */
- (instancetype)transfromToOrientation:(UIImageOrientation)orientation;
+ (instancetype)transformImage:(UIImage *)originImage toOrientation:(UIImageOrientation)orientation;
@end

@interface UIImage (Tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end

@interface UIImage (Stretch)

/**
 扩展系统拉伸方法，左右同时拉伸图片，中间的保持不变
 @attention 这个拉伸的有个缺陷！必须知道目标图片的大小，也说明了，这个图片是不可二次拉伸的！！！必须放在那么大的容器！
 @param targetImageSize 目标图片的大小
 @return 拉伸后的图片
 */
- (UIImage *)dd_stretchLeftAndRightWithContainerSize:(CGSize)targetImageSize;

@end

NS_ASSUME_NONNULL_END
