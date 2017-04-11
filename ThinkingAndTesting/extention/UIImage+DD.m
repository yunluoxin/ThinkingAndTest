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



#import <Accelerate/Accelerate.h>

@implementation UIImage (Blur)

+ (UIImage *)blurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL) DDLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        DDLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

@end

