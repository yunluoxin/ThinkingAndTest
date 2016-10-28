//
//  UIImage+DD.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/10/16.
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

@end
