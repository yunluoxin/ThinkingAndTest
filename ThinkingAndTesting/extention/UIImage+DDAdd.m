//
//  UIImage+DDAdd.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "UIImage+DDAdd.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (DDAdd)

+ (instancetype)imageNamed:(NSString *)imageName inBundleNamed:(NSString *)bundleName {
    if (!imageName) return nil;
    
    if ([imageName containsString:@"."]) {
        return [self imageFileNamed:imageName inBundleNamed:bundleName];
    } else {
        NSAssert([imageName containsString:@"@"], @"图片文件名传的有问题哦！要么写全名，要么不写。别传\"abc@2x\"这种");

        int scale = (int)[UIScreen mainScreen].scale;
        NSString *imageFileName = imageName;
        if (scale >= 2) {
            imageFileName = [imageName stringByAppendingFormat:@"%@@%dx.png", imageName, scale];
        }
        return [self imageNamed:imageFileName inBundleNamed:bundleName];
    }
}

+ (instancetype)imageFileNamed:(NSString *)imageFileName inBundleNamed:(NSString *)bundleName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *imageFilePath = [bundle pathForResource:imageFileName ofType:nil];
    return [[UIImage alloc] initWithContentsOfFile:imageFilePath];
}

@end

@implementation UIImage (Filter)

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

- (UIImage *)blurWithBlurNumber:(CGFloat)blur {
    return [UIImage blurImage:self withBlurNumber:blur];
}
@end

@implementation UIImage (ImageOrientation)

- (instancetype)transfromToOrientation:(UIImageOrientation)orientation {
    CGImageRef imageRef = self.CGImage;
    return [[UIImage alloc] initWithCGImage:imageRef scale:self.scale orientation:orientation];
}

+ (instancetype)transformImage:(UIImage *)originImage toOrientation:(UIImageOrientation)orientation {
    if (!originImage || ![originImage isKindOfClass:UIImage.class]) return nil;
    
    return [originImage transfromToOrientation:orientation];
}

@end
