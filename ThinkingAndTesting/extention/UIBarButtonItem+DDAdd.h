//
//  UIBarButtonItem+DDAdd.h
//  kachemama
//
//  Created by dadong on 2017/5/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DDAdd)

// title
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action ;  /// use default color. not set in this method.
+ (instancetype)itemWithTitle:(NSString *)title textColor:(UIColor *)textColor target:(id)target action:(SEL)action ;

// image
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action ;
+ (instancetype)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action;
+ (instancetype)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;

// image with offset
+ (NSArray<UIBarButtonItem *> *)itemWithImageName:(NSString *)imageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action ;
@end
