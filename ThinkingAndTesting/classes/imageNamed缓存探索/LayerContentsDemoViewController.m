//
//  LayerContentsDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/1/5.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "LayerContentsDemoViewController.h"

@interface LayerContentsDemoViewController ()

@end

@implementation LayerContentsDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicDemo];
    
//    [self stretchDemo];

//    [self stretchDemo2];
    
    [self visualRectDemo];
}

- (void)basicDemo {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(60, 200, 100, 200);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    
    UIImage *image = [UIImage imageNamed:@"IMG_1003.JPG"];
    layer.contents = (id)image.CGImage;
    layer.contentsGravity = kCAGravityTopLeft;          ///< 这个Top是在底下！！！看来坐标系和UIKit是倒的，但是左右是正常的！
    layer.contentsScale = [UIScreen mainScreen].scale;
}

///
/// layer.contentsCenter拉伸Demo
/// 主要为了研究layer.contentsCenter的拉伸，以及 UIImage的拉伸和layer.contentsCenter拉伸碰到一起的时候，会表现出谁的特性
/// @result 展示出了layer拉伸的特性！ 怀疑是次序问题！改变设置次序后，还是一样的结果！
///         可能是layer只取CGImage,丢失了UIImage的特性！拉伸是在UIImage中
///
- (void)stretchDemo {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(60, 200, 300, 80);
    layer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    UIImage *image = [UIImage imageNamed:@"bg_fr_bubble_view"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width - 1 topCapHeight:3];
    layer.contentsCenter = CGRectMake(0.2, 0.2, 0.2, 0.2);
    layer.contents = (id)image.CGImage;
    layer.contentsScale = [UIScreen mainScreen].scale;
    //    layer.contentsGravity = kCAGravityCenter;  // 设置成Center不会拉伸
}

/// 在这个直接用UIImageView的demo中，也证实了上面的结论！ 在对UIImageView的layer设置contentsCenter后，拉伸的image也无效了！
- (void)stretchDemo2 {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 200, 300, 80)];
    imageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:imageView];
    
    UIImage *image = [UIImage imageNamed:@"bg_fr_bubble_view"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width - 1 topCapHeight:3];
    imageView.layer.contentsCenter = CGRectMake(0.2, 0.2, 0.1, 0.1);
    imageView.image = image;
}

// 设置可视范围
- (void)visualRectDemo {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(60, 420, 100, 200);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    
    UIImage *image = [UIImage imageNamed:@"IMG_1003.JPG"];
    layer.contents = (id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
}

@end
