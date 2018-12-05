//
//  ImageCropViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/5.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "ImageCropViewController.h"

@interface ImageCropViewController ()
@property (nonatomic, weak) UIImageView *testView;
@property (nonatomic, strong) UIView *containerView;
@end

@implementation ImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image1.jpeg"]];
    self.testView = view;
    [self.containerView addSubview:view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static int mode = 0;
    mode ++;
    CGRect newRect = [self cropRect:CGRectMake(0, 0, self.testView.image.size.width, self.testView.image.size.height) inRect:self.containerView.bounds atMode:mode % 3];
    DDLog(@"mode: %d, %@", mode%3, NSStringFromCGRect(newRect));
    self.testView.frame = newRect;
}

- (CGRect)cropRect:(CGRect)srcRect inRect:(CGRect)inRect atMode:(int)mode {
    float targetFactor = inRect.size.width / inRect.size.height;
    float srcFactor = srcRect.size.width / srcRect.size.height;
    
    float targetWidth = inRect.size.width;
    float targetHeight = inRect.size.height;
    float srcWidth = srcRect.size.width;
    float srcHeight = srcRect.size.height;
    
    if (mode == 0) { // 适应
        if (srcFactor > targetFactor) {
            float newWidth = targetWidth;
            float newHeight = newWidth / srcWidth * srcHeight;
            float y = (targetHeight - newHeight) / 2;
            return CGRectMake(0, y, newWidth, newHeight);
        } else {
            float newHeight = targetHeight;
            float newWidth = newHeight / srcHeight * srcWidth;
            float x = (targetWidth - newWidth) / 2;
            return CGRectMake(x, 0, newWidth, newHeight);
        }
    } else if (mode == 1) {  // 缩放
        if (srcFactor > targetFactor) {
            float newHeight = targetHeight;
            float newWidth = newHeight / srcHeight * srcWidth;
            float x = (targetWidth - newWidth) / 2;
            return CGRectMake(x, 0, newWidth, newHeight);
        } else {
            float newWidth = targetWidth;
            float newHeight = newWidth / srcWidth * srcHeight;
            float y = (targetHeight - newHeight) / 2;
            return CGRectMake(0, y, newWidth, newHeight);
        }
    
    } else { // 填充
        return CGRectMake(0, 0, inRect.size.width, inRect.size.height);
    }
}


- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.dd_width, 300)];
        _containerView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}
@end
