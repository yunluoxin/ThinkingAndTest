//
//  DDPhotoView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDPhotoView.h"

@interface DDPhotoView ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIImageView *imageView ;

@end

@implementation DDPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self ;
}

- (void)initView
{
    self.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    self.frame = CGRectMake(0, 0, DD_SCREEN_WIDTH, DD_SCREEN_HEIGHT) ;
    self.showsHorizontalScrollIndicator = NO ;
    self.showsVerticalScrollIndicator = NO ;
    self.bounces = NO ;
    self.delegate = self ;
    
    // 设置最大伸缩比例
    
    self.maximumZoomScale = 2.0;
    
    // 设置最小伸缩比例
    
    self.minimumZoomScale = 0.2;
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
    _imageView = imageView ;
    [self addSubview:imageView];
}

- (void)setImage:(UIImage *)image
{
    _image = image ;
    
    self.imageView.image = image ;
    self.contentSize = image.size ;
    CGFloat scaleW = DD_SCREEN_WIDTH / image.size.width ;
    CGFloat scaleH = DD_SCREEN_HEIGHT / image.size.height ;
    CGFloat scale = MIN(scaleW, scaleH) ;
    if (scale == scaleW) {
        CGFloat newH = scale * image.size.height ;
        CGFloat y = (DD_SCREEN_HEIGHT - newH) / 2 ;
        self.imageView.frame = CGRectMake(0, y, DD_SCREEN_WIDTH, newH) ;
    }else{
        CGFloat newW = scale * image.size.width ;
        CGFloat x = (DD_SCREEN_WIDTH - newW) / 2 ;
        self.imageView.frame = CGRectMake(x, 0, newW, DD_SCREEN_HEIGHT) ;
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView ;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

@end
