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
    UIGraphicsBeginImageContextWithOptions(rect.size , NO, 0) ;
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
    UIGraphicsBeginImageContextWithOptions(size, NO, 0) ;
    
    [image drawInRect:CGRectMake(0, 0, dw, dh) ] ;
    
    UIImage *dImage = UIGraphicsGetImageFromCurrentImageContext() ;
    
    UIGraphicsEndImageContext() ;

    return dImage ;
}



/// ========================================================
/// 对于fit模式，放大 `大`的部分，拉伸或者缩小成和目标相应一样的
/// 对于scale模式， 放大 `小` 的部分, 拉伸或者缩小成和目标对应的一样的
/// ========================================================

- (UIImage *)cropToSize:(CGSize)size mode:(DDImageCropMode)mode
{
    NSAssert(!CGSizeEqualToSize(size, CGSizeZero), @"size can't be zero!") ;
    
    CGFloat originalW = self.size.width ;
    CGFloat originalH = self.size.height ;
    CGFloat originalFactor = originalW/originalH ;
    
    CGFloat targetW = size.width ;
    CGFloat targetH = size.height ;
    CGFloat targetFactor = targetW/targetH ;
    
    CGFloat x = 0 ;
    CGFloat y = 0 ;
    CGFloat w = targetW ;
    CGFloat h = targetH ;
    
    /// 算出Frame
    switch (mode) {
        case DDImageCropFitMode:
        {
            if (originalFactor > targetFactor)
            {
                /// w被弄成一样，高被压缩
                w = targetW ;
                h = w / originalFactor ;
                y = (targetH - h) / 2 ;
                x = 0 ;
            }
            else
            {
                /// h被弄成一样，宽被压缩
                h = targetH ;
                w = h * originalFactor ;
                x = (targetW - w) / 2 ;
                y = 0 ;
            }
            break;
        }
        case DDImageCropFillMode:
        {
            /// 直接使用设置x,y,w,h的时候已经赋值的默认值
            break;
        }
        case DDImageCropScaleMode:
        {
            if (originalFactor > targetFactor)
            {
                /// h被弄成一样， w被拉伸
                h = targetH ;
                w = h * originalFactor ;
                x = (targetW - w) / 2 ;
                y = 0 ;
            }
            else
            {
                /// w被弄成一样，h被拉伸
                w = targetW ;
                h = w / originalFactor ;
                y = (targetH - h) / 2 ;
                x = 0 ;
            }
            break;
        }
    }

    /// 绘制
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0) ;
//    [self drawInRect:CGRectMake(x, y, w, h)] ;
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext() ;
//    UIGraphicsEndImageContext() ;
    
    /// 推荐这种写法，可以异步绘制
    CGFloat scale = [UIScreen mainScreen].scale ;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB() ;
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, size.width * 4 * scale, colorSpace, kCGImageAlphaPremultipliedFirst) ;
    CGContextDrawImage(context, CGRectMake(x*scale,y*scale,w*scale,h*scale), self.CGImage) ;
    CGImageRef imageRef = CGBitmapContextCreateImage(context) ;
    UIImage *newImage = [[UIImage alloc]initWithCGImage:imageRef scale:scale orientation:self.imageOrientation] ;
    CGImageRelease(imageRef) ;
    CGColorSpaceRelease(colorSpace) ;
    CGContextRelease(context) ;
    
    return newImage ;
}

- (UIImage *)fillToSize:(CGSize)size {
    return [self cropToSize:size mode:DDImageCropFillMode] ;
}
- (UIImage *)fitToSize: (CGSize)size {
    return [self cropToSize:size mode:DDImageCropFitMode] ;
}
- (UIImage *)scaleToSize:(CGSize)size {
    return [self cropToSize:size mode:DDImageCropScaleMode] ;
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

