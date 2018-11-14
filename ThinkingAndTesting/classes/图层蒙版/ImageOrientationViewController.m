//
//  ImageOrientationViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/14.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "ImageOrientationViewController.h"

@interface ImageOrientationViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@end

@implementation ImageOrientationViewController {
    UIImage *_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    _image = [UIImage imageNamed:@"image3.jpeg"];
    self.imageView.image = _image;
    UIImageOrientation orientation = _image.imageOrientation;    ///< 默认朝向是 UIImageOrientationUp
    DDLog(@"%@", NSStringFromCGSize(_image.size));      // {1920, 1080}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGImageRef imageRef = _image.CGImage;
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:_image.scale orientation:UIImageOrientationLeft];
    self.imageView.image = newImage;
    DDLog(@"%@", NSStringFromCGSize(newImage.size));    //  {1080, 1920}, 转向了
    
    
    
    /* 另外，发现旋转屏幕后！ 是整个imageView跟着改变了。但是图片的朝向还是不变的，朝着左边的还是左边的！*/
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.interfaceOrientation;
}

@end
