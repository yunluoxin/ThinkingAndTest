//
//  UIImage+Compress.h
//  CoreAnimation
//
//  Created by ZhangXiaodong on 16/9/28.
//  Copyright © 2016年 ZhangXiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

/*
 * 经过缩放得到一张更小或者更大的图
 */
+ (instancetype)scaleImage:(UIImage *)image toScale:(CGFloat)scale ;
@end
