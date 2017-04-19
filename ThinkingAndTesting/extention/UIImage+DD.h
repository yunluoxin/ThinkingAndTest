//
//  UIImage+DD.h
//  ThinkingAndTesting
//
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DD)

+ (instancetype)dd_imageNamed:(NSString * )imageName ext:( NSString * _Nonnull )extType ;

@end

@interface UIImage (Util)

/**
 *  从指定的颜色生成一个1point * 1point的纯色图片
 */
+ (instancetype)imageWithColor:(UIColor *)color ;
/**从指定颜色生成一张size大小的纯色图片**/
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size ;


/**
 *  通过路径加载，以Data方式加载一张图片，没有原本imageNamed:方法存在的缓存
 *
 *  @param imageName 图片全名：如 logo@3x.png
 *
 */
+ (instancetype)dd_imageNamed:(NSString * _Nonnull)imageName ;

@end

/**
    图像裁剪模式
 */
typedef NS_ENUM(NSUInteger,DDImageCropMode) {
    DDImageCropFillMode     =  0 ,      /// 填充模式（容易变形）
    DDImageCropFitMode      =  1 ,      /// 适应模式
    DDImageCropScaleMode    =  2        /// 缩放模式
};

@interface UIImage (Compress)

/**
 *  返回一个以图片中部进行"填充"、"拉伸"后的图片，不改变外观（类似聊天气泡的拉伸）
 */
+ (instancetype)resizingImageWithName:(NSString *)imageName ;

/*
 * 直接经过`等比例`对长和宽进行操作得到一张更小或者更大的图（不进行其他任何处理）
 */
+ (instancetype)scaleImage:(UIImage *)image toScale:(CGFloat)scale ;


/**
 以某种裁剪模式，裁剪图片以适应size, 会生成新图片
 @param size 目标大小
 @param mode 裁剪模式
 @return 新生成的图片
 */
- (UIImage *)cropToSize:(CGSize)size mode:(DDImageCropMode)mode ;
- (UIImage *)fillToSize:(CGSize)size ;
- (UIImage *)fitToSize: (CGSize)size ;
- (UIImage *)scaleToSize:(CGSize)size ;

@end


@interface UIImage (Blur)

///
/// 利用 vImage
/// @param blur 必须0<=blur<=1
///
+ (UIImage *)blurImage:(UIImage *)image withBlurNumber:(CGFloat)blur ;

@end

NS_ASSUME_NONNULL_END
