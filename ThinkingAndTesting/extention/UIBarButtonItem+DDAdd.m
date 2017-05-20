//
//  UIBarButtonItem+DDAdd.m
//  kachemama
//
//  Created by dadong on 2017/5/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UIBarButtonItem+DDAdd.h"

@implementation UIBarButtonItem (DDAdd)

// title
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self itemWithTitle:title textColor:nil target:target action:action] ;
}

+ (instancetype)itemWithTitle:(NSString *)title textColor:(UIColor *)textColor target:(id)target action:(SEL)action ;
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action] ;
    if (textColor) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor} forState:UIControlStateNormal] ;
    }
    return item ;
}


// image
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    return [self itemWithImageName:imageName highlightImageName:nil target:target action:action] ;
}

+ (instancetype)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action
{
    return [self itemWithImageName:imageName highlightImageName:highlightImageName selectedImageName:nil target:target action:action] ;
}

+ (instancetype)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (imageName) {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (highlightImageName) {
        [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }else {
        button.adjustsImageWhenHighlighted = NO;
    }
    
    if (selectedImageName) {
        [button setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


// image with offset
+ (NSArray<UIBarButtonItem *> *)itemWithImageName:(NSString *)imageName offsetX:(CGFloat)offsetX target:(id)target action:(SEL)action
{
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    fixedItem.width = -offsetX;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] ;
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:imageView] ;
    return @[fixedItem,item];
}

@end
