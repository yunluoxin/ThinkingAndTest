//
//  UINavigationBar+CustomStyle.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (CustomStyle)

- (void)setBackgroundColor:(UIColor *)bgColor backIndicatorImage:(UIImage *)backIndicatorImage titleColor:(UIColor *)titleColor rightItemColor:(UIColor *)rightItemColor ;

- (void)restoreNavigationBar ;


//@property (nonatomic, strong) UIColor * dd_originTitleColor ;
//
//@property (nonatomic, strong) UIColor * dd_originRightItemColor ;

@end
