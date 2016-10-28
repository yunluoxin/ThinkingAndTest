//
//  UIImage+DD.h
//  ThinkingAndTesting
//
<<<<<<< HEAD
//  Created by ZhangXiaodong on 16/10/16.
=======
//  Created by dadong on 16/10/20.
>>>>>>> 3e63e7e698405506dea2f674b1b43a1c1fd86164
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DD)

<<<<<<< HEAD
+ (instancetype)dd_imageNamed:(NSString * )imageName ext:( NSString * _Nonnull )extType ;

@end
=======

@end

@interface UIImage (Util)

/**
 *  从指定的颜色生成一个1point * 1point的纯色图片
 */
+ (instancetype)imageWithColor:(UIColor *)color ;
/**从指定颜色生成一张size大小的纯色图片**/
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size ;

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
>>>>>>> 3e63e7e698405506dea2f674b1b43a1c1fd86164
