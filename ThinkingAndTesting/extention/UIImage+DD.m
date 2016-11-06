//
//  UIImage+DD.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UIImage+DD.h"

@implementation UIImage (DD)

+ (instancetype)dd_imageNamed:(NSString * _Nonnull)imageName ext:( NSString * _Nonnull )extType
{
    if (!imageName) {
        return nil;
    }
    CGFloat scale = [UIScreen mainScreen].scale ;
    if (scale >= 2.0) {
        imageName = [NSString stringWithFormat:@"%@@%dx",imageName,(int)scale] ;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:extType] ;
    return [[UIImage alloc]initWithContentsOfFile:path] ;
}


+ (instancetype)dd_imageNamed:(NSString *)imageName
{
    if (!imageName) {
        return nil;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil] ;
    return [[UIImage alloc]initWithContentsOfFile:path] ;
}

@end

@implementation UIImage (Util)

+ (instancetype)imageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(1.0, 1.0) ;
    return [self imageWithColor:color size:size] ;
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        return nil ;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height) ;
    UIGraphicsBeginImageContextWithOptions(rect.size , NO, 1) ;
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    [color setFill] ;
    CGContextFillRect(context, rect) ;
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return newImage ;
}

@end




@implementation UIImage (Compress)

+ (instancetype)resizingImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image ;
}

+ (instancetype)scaleImage:(UIImage *)image toScale:(CGFloat)scale
{
    if (image == nil) {
        return nil ;
    }
    
    CGFloat ow = image.size.width ;
    CGFloat oh = image.size.height ;
    
    if (ow == 0 || oh == 0) {
        return nil ;
    }
    
    CGFloat dw = ow * scale ;
    CGFloat dh = oh * scale ;
    
    CGSize size = CGSizeMake(dw, dh) ;
    UIGraphicsBeginImageContextWithOptions(size, NO, 1) ;
    
    [image drawInRect:CGRectMake(0, 0, dw, dh) ] ;
    
    UIImage *dImage = UIGraphicsGetImageFromCurrentImageContext() ;
    
    UIGraphicsEndImageContext() ;

    return dImage ;
}



@end

