//
//  UIImage+Compress.m
//  CoreAnimation
//
//  Created by ZhangXiaodong on 16/9/28.
//  Copyright © 2016年 ZhangXiaodong. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

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
    UIGraphicsBeginImageContextWithOptions(size, NO, 0 ) ;
    
    [image drawInRect:CGRectMake(0, 0, dw, dh) ] ;
    
    UIImage *dImage = UIGraphicsGetImageFromCurrentImageContext() ;
    
    UIGraphicsEndImageContext() ;
    
    return dImage ;
}

@end
