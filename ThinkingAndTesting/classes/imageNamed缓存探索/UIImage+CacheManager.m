//
//  UIImage+CacheManager.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/7.
//  Copyright © 2018 dadong. All rights reserved.
//  用自己的图片做了测试，6M JPG， imageNamed耗时 0.075650s   initWithContentsOfFile: 耗时0.021050s

#import "UIImage+CacheManager.h"
#import <objc/runtime.h>

#define ENABLE_SMART_IMAGE_CACHE 0      // 是否开启智能图片缓存

static const NSUInteger CacheImageMaxImagePixelSize = 1024 * 30;

static NSCache *imageCaches;

@implementation UIImage (CacheManager)

#if ENABLE_SMART_IMAGE_CACHE

+ (void)load {
    if (![NSStringFromClass(self) isEqualToString:@"UIImage"]) return;
    
    SEL originalSel = @selector(imageNamed:);
    SEL swizzledSel = @selector(cm_imageNamed:);
    Method originalMethod = class_getInstanceMethod(object_getClass(self), originalSel);
    Method swizzledMethod = class_getInstanceMethod(object_getClass(self), swizzledSel);
    method_exchangeImplementations(originalMethod, swizzledMethod);   //交换两者的实现方式
}

+ (void)initialize {
    imageCaches = [[NSCache alloc] init];
}

+ (UIImage *)cm_imageNamed:(NSString *)name {
    if (!name) return nil;
    
    NSString *imageRealName = nil; ///< 真实的图片文件名
    BOOL findInBundle = NO;        ///< 是否能在bundle找到
    NSString *imageFilePath = nil; ///< 图片文件路径
    if ([name containsString:@"."]) {
        findInBundle = YES;
        imageRealName = name;
        imageFilePath = [[NSBundle mainBundle] pathForResource:imageRealName ofType:nil];
    } else {
        static NSArray *scales;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            int scale = (int)[UIScreen mainScreen].scale;
            if (scale == 3) {
                scales = @[@(3),@(2),@(1)];
            } else if (scale == 2){
                scales = @[@(2),@(3),@(1)];
            } else {
                scales = @[@(2),@(3),@(1)];
            }
        });
        for (int i = 0; i <= 3; i++) {
            NSString *tempImageName = nil;
            if (i == 3) {
                tempImageName = [name stringByAppendingFormat:@".png"];
            } else {
                tempImageName = [name stringByAppendingFormat:@"@%dx.png", [scales[i] intValue]];
            }
            NSString *path = [[NSBundle mainBundle] pathForResource:tempImageName ofType:nil];
            if (path) {
                findInBundle = YES;
                imageRealName = tempImageName;
                imageFilePath = path;
                continue;
            }
        }
        
    }
    
    // 没有在bundle中找到, 说明可能在image.xcassets里面
    if (!findInBundle) {
        return [self cm_imageNamed:name];
    }
    
//    UIImage *cachedImage = [imageCaches objectForKey:imageRealName];
//    if (cachedImage) {
//        return cachedImage;
//    }
    
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imageFilePath];
    if (imageData.length > CacheImageMaxImagePixelSize) {
        return [[self alloc] initWithData:imageData];           // 比再用 initWithContentsOfFile更快！毕竟省了搜索路径的时间，测试发现1000张省了0.19s
    }
    
    return [self cm_imageNamed:name];
}

#endif
@end
