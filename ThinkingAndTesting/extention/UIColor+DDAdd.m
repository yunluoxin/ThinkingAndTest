//
//  UIColor+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UIColor+DDAdd.h"

@implementation UIColor (DDAdd)

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue
{
    return [UIColor colorWithRed:((rgbValue>>16)&0x00f)/255.0f green:((rgbValue>>8)&0x00f)/255.0f blue:((rgbValue>>0)&0x00f)/255.0f alpha:1] ;
}

+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue
{
    return [UIColor colorWithRed:((rgbaValue>>24)&0xff)/255.0f green:((rgbaValue>>16)&0xff)/255.0f blue:((rgbaValue>>8)&0xff)/255.0f alpha:(rgbaValue&0xff)/255.0f] ;
}

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((rgbValue>>16)&0x00f)/255.0f green:((rgbValue>>8)&0x00f)/255.0f blue:((rgbValue>>0)&0x00f)/255.0f alpha:alpha] ;
}

- (CGFloat)red
{
    CGFloat r,g,b,a = 0 ;
    [self getRed:&r green:&g blue:&b alpha:&a] ;
    return r ;
}

- (CGFloat)green
{
    CGFloat r,g,b,a = 0 ;
    [self getRed:&r green:&g blue:&b alpha:&a] ;
    return g ;
}

- (CGFloat)blue
{
    CGFloat r,g,b,a = 0 ;
    [self getRed:&r green:&g blue:&b alpha:&a] ;
    return b ;
}

- (CGFloat)alpha
{
    CGFloat r,g,b,a = 0 ;
    [self getRed:&r green:&g blue:&b alpha:&a] ;
    return a ;
}

- (uint32_t)rgbValue
{
    CGFloat r,g,b,a = 0 ;
    [self getRed:&r green:&g blue:&b alpha:&a] ;
    uint8_t red, green, blue = 0 ;
    red = r * 255 ;
    green = g * 255 ;
    blue = b * 255 ;
    uint32_t rgb = 0 ;
    rgb = (red<<16) + (green<<8) + blue ;
    return rgb ;
}

- (uint32_t)rgbaValue
{
    CGFloat r,g,b,a = 0 ;
    [self getRed:&r green:&g blue:&b alpha:&a] ;
    uint8_t red, green, blue, alpha = 0 ;
    red = r * 255 ;
    green = g * 255 ;
    blue = b * 255 ;
    alpha = a * 255 ;
    uint32_t rgba = 0 ;
    rgba = (red<<24) + (green<<16) + (blue<<8) + alpha ;
    return rgba ;
}

- (CGColorSpaceRef)colorSpace
{
    return CGColorGetColorSpace(self.CGColor) ;
}

- (CGColorSpaceModel)colorSpaceModel
{
    return CGColorSpaceGetModel(self.colorSpace) ;
}
@end
