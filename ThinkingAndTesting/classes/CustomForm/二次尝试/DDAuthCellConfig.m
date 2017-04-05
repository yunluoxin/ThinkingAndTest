//
//  DDAuthCellConfig.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDAuthCellConfig.h"

@implementation DDAuthCellConfig

@end

@implementation AuthCellImageItemConfig

+ (instancetype)configWithIsTemplate:(BOOL)isTemplate selectedImage:(UIImage *)selectedImage templatedImage:(UIImage *)templatedImage
{
    AuthCellImageItemConfig * instance = [[self alloc] init] ;
    instance.isTemlate = isTemplate ;
    if (isTemplate) {
        instance.templatedImage = templatedImage ;
        instance.selectedImage = nil ;
        instance.placeholderImage = nil ;
    }else{
        instance.templatedImage = nil ;
        instance.selectedImage = selectedImage ;
        instance.placeholderImage = [UIImage imageNamed:@"4"] ;
    }
    return instance ;
}


- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}
@end
