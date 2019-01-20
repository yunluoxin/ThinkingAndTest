//
//  ImageMaskViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ImageMaskViewController.h"
#import "CertificationUtils.h"
@interface ImageMaskViewController ()

@end

@implementation ImageMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor] ;

//    [self testTintImage];
//    [CertificationUtils savedCertificatesOfUrl:@"https://dev.api.m.kachemama.com/"] ;
    
    [self way1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, DD_SCREEN_WIDTH, 60)];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    label.text = @"的我";
    label.adjustsFontSizeToFitWidth  = YES;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(a_test)];
    [label addGestureRecognizer:tap];
    label.userInteractionEnabled = YES;
    
    
    ///
    /// 实验说明: 在卡住主线程之后，点击某个可以响应的控件A，之后主线程从卡住中恢复，但是设置控件A为userInteractionEnabled=NO,这时候事件还
    ///     可以传递麽？
    ///         发现不行！如果没设置userInteractionEnabled=NO，是可以传递的！可以得出，事件传递真正是在主线中进行的！分发之后，还是要走原
    ///      来的流程.
    ///
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLog(@"before sleeping");
        [NSThread sleepForTimeInterval:5];
        DDLog(@"after sleeping");

        label.userInteractionEnabled = NO;
        DDLog(@"complete setting");
    });
}

- (void)a_test {
    DDLog(@"a_test");
}

//
//  和方式2相反似乎！！！ 透明的地方显示，不透明的地方，反而不显示底下的。 反转alpha !!! 读取 mask图片的alpha, alpha=0的地方，底下就是1-alpha=1,显示。  alpha=1的地方，底下就是1-alpha=0,透明！
//
- (void)way1
{
    UIImage *grayColorImage = [[UIImage imageNamed:@"mask2"] grayColorImage];
    
    UIImage *image = [[UIImage imageNamed:@"image3.jpeg"] maskWithImage:grayColorImage];
    
    UIImage * i = [self maskImage:[UIImage imageNamed:@"image3.jpeg"] withMask:[UIImage imageNamed:@"mask2"] ] ;
    
    UIImageView * imageV = [[UIImageView alloc] initWithImage:i] ;
    [self.view addSubview:imageV] ;
    //    imageV.center = self.view.center ;
    imageV.frame = self.view.bounds ;
    [UIImagePNGRepresentation(i) writeToFile:@"/Users/dadong/Desktop/b.png" atomically:YES] ;
}

//
//  此种方式mask图片必须是透明和不透明的，不透明部分显示出来，透明部分不显示。 实质就是读取mask图片的alpha，设置到自身身上。 透明部分alpha=0,故无法显示
//
- (void)way2
{
    UIImage * i = [UIImage imageNamed:@"image1.jpeg"] ;
    UIImageView * imageV = [[UIImageView alloc] initWithImage:i] ;
    [self.view addSubview:imageV] ;
    imageV.center = self.view.center ;
    
    CALayer * layer = [CALayer layer] ;
    layer.contents = (id)[UIImage imageNamed:@"discount_star"].CGImage ;
    layer.frame = imageV.bounds ;
    imageV.layer.mask = layer ;
    imageV.layer.masksToBounds = YES ;
}

- (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    

    /* 第二个参数必须是用CGImageMaskCreate创建的遮罩图像，否则无效！*/
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

- (void)testTintImage {
    UIImage *image = [UIImage imageNamed:@"discount_star"];
    UIImage *tintImage = [image imageWithTintColor:[UIColor greenColor]];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.image = tintImage;
    [self.view addSubview:imageView];
    imageView.dd_top = 200;
    imageView.dd_left = 100;
    
    UIImage *gradientImage = [image imageWithGradientTintColor:[UIColor greenColor]];
    imageView.image = gradientImage;
}

@end
