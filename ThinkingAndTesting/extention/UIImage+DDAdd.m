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

@implementation UIImage (Tint)

//保留透明度信息
- (UIImage *) imageWithTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

//保留灰度信息
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end

@implementation UIImage (Stretch)

///
/// 经过实验发现，拉伸的区域范围最好是整数，否则会出现缝！ 另外，被拉伸后的目地区域最好也要是整数，不然也会有缝出现！
/// 比如你的宽是200.5， 原长为100，要拉伸100.5，那由于可拉伸区域是1，那碰到0.5就不知道如何处理，就会透明掉，导致出现缝！
///
- (UIImage *)dd_stretchLeftAndRightWithContainerSize:(CGSize)imageViewSize {
    
    CGSize imageSize = self.size;
    CGSize bgSize = CGSizeMake(imageViewSize.width, imageViewSize.height); //imageView的宽高取整，否则会出现横竖两条缝
    
    CGFloat factor = 0.8;
    CGFloat top = (NSInteger)(imageSize.height / 2);
    CGFloat bottom = imageSize.height - top - 1;
    CGFloat left = (NSInteger)(imageSize.width * factor);
    CGFloat right = imageSize.width - left - 1;
    UIImage *image = [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeTile];
    
    CGFloat tempWidth = (NSInteger)(bgSize.width / 2 + imageSize.width / 2);
    CGFloat tempHeight = (NSInteger)bgSize.height;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, tempHeight), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, tempWidth, tempHeight)];
    UIImage *firstStrechImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    top = (NSInteger)(imageSize.height / 2);
    left = (NSInteger)(imageSize.width * (1 - factor));
    right = tempWidth - left - 1;
    bottom = tempHeight - top - 1;
    UIImage *secondStrechImage = [firstStrechImage resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
    
    return secondStrechImage;
}

@end
