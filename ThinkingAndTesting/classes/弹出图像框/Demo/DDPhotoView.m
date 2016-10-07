//
//  DDPhotoView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDPhotoView.h"

@interface DDPhotoView ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *scrollView ;

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
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self ;
    _scrollView = scrollView ;
    scrollView.showsHorizontalScrollIndicator = NO ;
    scrollView.showsVerticalScrollIndicator = NO ;
    scrollView.bounces = NO ;
    [self addSubview:scrollView];
    
    // 设置最大伸缩比例
    
    scrollView.maximumZoomScale = 2.0;
    
    // 设置最小伸缩比例
    
    scrollView.minimumZoomScale = 0.2;
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
    _imageView = imageView ;
    [_scrollView addSubview:imageView];
}

- (void)setImage:(UIImage *)image
{
    _image = image ;
    self.imageView.image = image ;
    
    
    CGFloat scale = image.size.height/ image.size.width ;
    if (scale > DD_SCREEN_HEIGHT/DD_SCREEN_WIDTH ) {
        //以宽为准
        CGFloat newWidth = scale * DD_SCREEN_HEIGHT ;
        self.imageView.frame = CGRectMake(0, 0, newWidth, DD_SCREEN_HEIGHT);

    }else{
        CGFloat newHeight = scale * DD_SCREEN_WIDTH ;
        self.imageView.frame = CGRectMake(0, 0, DD_SCREEN_WIDTH, newHeight);
    }
    
    self.scrollView.frame = self.imageView.frame ;
    self.scrollView.center = CGPointMake(DD_SCREEN_WIDTH/2, DD_SCREEN_HEIGHT/2);
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
