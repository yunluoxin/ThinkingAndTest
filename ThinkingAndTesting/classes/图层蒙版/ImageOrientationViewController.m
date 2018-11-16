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
    self.view.backgroundColor = [UIColor greenColor];
    
    _image = [UIImage imageNamed:@"image3.jpeg"];
    self.imageView.image = _image;
    UIImageOrientation orientation = _image.imageOrientation;    ///< 默认朝向是 UIImageOrientationUp
    DDLog(@"%@", NSStringFromCGSize(_image.size));      // {1920, 1080}
    
    
    // 和本vc无关的demo，测试裁剪
    @weakify(self);
    [_image cropToSize:CGSizeMake(300, 700) inMode:DDImageCropFitMode completion:^(UIImage * _Nonnull image) {
        @strongify(self);
//        self->_image = image;
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGImageRef imageRef = _image.CGImage;
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:_image.scale orientation:UIImageOrientationLeft];
    self.imageView.image = newImage;
    DDLog(@"%@", NSStringFromCGSize(newImage.size));    //  {1080, 1920}, 转向了
    
    
    
    /* 另外，发现旋转屏幕后！ 是整个imageView跟着改变了。但是图片的朝向还是不变的，朝着左边的还是左边的！*/
    
    /* 屏幕转向的秘密：假设一个view.frame = {a,b,c,d}, 则转向后他的坐标还是一样的！只不过是在新的坐标系里（坐标原点在原来的其他角了） */
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.contentMode = UIViewContentModeScaleToFill;
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
