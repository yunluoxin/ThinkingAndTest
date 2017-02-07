//
//  UIColor+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIColor (DDAdd)

@property (nonatomic, assign, readonly) CGFloat red   ;
@property (nonatomic, assign, readonly) CGFloat green ;
@property (nonatomic, assign, readonly) CGFloat blue  ;
@property (nonatomic, assign, readonly) CGFloat alpha ;

@property (nonatomic, assign, readonly) uint32_t rgbValue ;
@property (nonatomic, assign, readonly) uint32_t rgbaValue ;

@property (nonatomic, assign, readonly) CGColorSpaceRef colorSpace ;
@property (nonatomic, assign, readonly) CGColorSpaceModel colorSpaceModel ;


+ (UIColor *) colorWithRGB:(uint32_t)rgbValue ;
+ (UIColor *) colorWithRGBA:(uint32_t)rgbaValue ;
+ (UIColor *) colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha ;
@end
NS_ASSUME_NONNULL_END
