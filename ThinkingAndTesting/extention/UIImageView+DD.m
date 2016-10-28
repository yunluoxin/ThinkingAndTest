//
//  UIImageView+DD.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/10/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UIImageView+DD.h"

@implementation UIImageView (DD)

- (void) setImageAndFill:(UIImage *)image
{
    if (CGRectEqualToRect(self.bounds, CGRectZero)) {
        self.image = image ;
        [self setNeedsLayout] ;
        return ;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        CGSize size = self.bounds.size ;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB() ;
        CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedFirst) ;
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage) ;
        CGImageRef imageRef = CGBitmapContextCreateImage(context) ;
        UIImage *newImage = [[UIImage alloc]initWithCGImage:imageRef] ;
        CGImageRelease(imageRef) ;
        CGColorSpaceRelease(colorSpace) ;
        CGContextRelease(context) ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = newImage ;
        });
    }) ;
}

@end
