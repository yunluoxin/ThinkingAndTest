//
//  UIImage+DD.h
//  ThinkingAndTesting
//
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface UIImage (Compress)

/**
 *  返回一个以图片中部进行"填充"、"拉伸"后的图片，不改变外观（类似聊天气泡的拉伸）
 */
+ (instancetype)resizingImageWithName:(NSString *)imageName ;

/*
 * 直接经过缩放得到一张更小或者更大的图（不进行其他任何处理）
 */
+ (instancetype)scaleImage:(UIImage *)image toScale:(CGFloat)scale ;
@end
