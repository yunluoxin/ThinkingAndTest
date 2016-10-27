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
    tap.numberOfTapsRequired = 1 ;
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
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit ;
    _imageView = imageView ;
    [self addSubview:imageView];
    
    
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGesture];
    
    
    //a single tap may require a double tap to fail
    [tap requireGestureRecognizerToFail:doubleTapGesture] ;
}
- (void)setImage:(UIImage *)image
{
    _image = image ;
    self.imageView.image = image ;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView ;
}



- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            
                            
                            scrollView.contentSize.height * 0.5 + offsetY);

}

- (CGRect)zoomRectWithScale:(CGFloat)scale atCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTapGesture
{
    CGFloat newScale = self.zoomScale * 1.2 ;
    CGRect zoomRect = [self zoomRectWithScale:newScale atCenter:[doubleTapGesture locationInView:self]] ;
    [self zoomToRect:zoomRect animated:YES] ;
}

@end
