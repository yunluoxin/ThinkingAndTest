//
//  ElasticityButton.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ElasticityButton.h"

#define imageHeight 40.0f

@implementation ElasticityButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
        self.titleLabel.font = [UIFont systemFontOfSize:DDRealValue(11)] ;
        self.imageView.contentMode = UIViewContentModeCenter ;
    }
    return self ;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0 ;
    CGFloat y = 8 ;
    return CGRectMake(x, y, contentRect.size.width, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0 ;
    CGFloat y = imageHeight + 8 * 2 ;
    
    CGFloat h = DDRealValue(13) ;
    return CGRectMake(x, y, contentRect.size.width, h) ;
}

@end
