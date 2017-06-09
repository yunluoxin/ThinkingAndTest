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
    [self way1] ;
    
    [CertificationUtils savedCertificatesOfUrl:@"https://dev.api.m.kachemama.com/"] ;
}

//
//  和方式2相反似乎！！！ 透明的地方显示，不透明的地方，反而不显示底下的。 反转alpha !!! 读取 mask图片的alpha, alpha=0的地方，底下就是1-alpha=1,显示。  alpha=1的地方，底下就是1-alpha=0,透明！
//
- (void)way1
{
    UIImage * i = [self maskImage:[UIImage imageNamed:@"image3"] withMask:[UIImage imageNamed:@"discount_star"] ] ;
    
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
    

    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

@end
