//
//  UpDownHorizontallyAlignCenterButton.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/16.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "UpDownHorizontallyAlignCenterButton.h"

@implementation UpDownHorizontallyAlignCenterButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_config];
    }
    return self;
}

/// 默认配置
- (void)p_config {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - override

- (void)setImageWidth:(float)imageWidth {
    _imageWidth = imageWidth;
    _imageSize = CGSizeMake(imageWidth, imageWidth);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    float y = self.imageMarginTop;
    float x = (contentRect.size.width - self.imageSize.width) / 2;
    return CGRectMake(x, y, self.imageSize.width, self.imageSize.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    float space = MAX(self.imageMarginBottom, self.titleMarginTop);
    float y = self.imageMarginTop + self.imageSize.height + space;
    float h = contentRect.size.height - y - self.titleMarginBottom;
    return CGRectMake(0, y, contentRect.size.width, h);
}

@end
