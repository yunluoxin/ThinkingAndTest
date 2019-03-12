//
//  TransformDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/25.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "TransformDemoViewController.h"

@interface TransformDemoViewController ()
@property (nonatomic, strong) UIView *purpleView;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation TransformDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.purpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+24, 250, 80)];
    self.purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.purpleView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_fr_bubble_view"]];
    [self.purpleView addSubview:imageV];
    imageV.frame = self.purpleView.bounds;
    imageV.contentMode = UIViewContentModeCenter;
    self.imageView = imageV;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.textColor = [UIColor greenColor];
    label.text = @"What the fuck!!!";
    [self.imageView addSubview:label];
    
    [self demo];
    
    
    DDLog(@"%@", NSStringFromCGSize(imageV.image.size));    ///< 图片大小
    DDLog(@"%ld", CGImageGetWidth(imageV.image.CGImage));   ///< 获取到的是实际的像素大小！
    
    
    /* 浮点数问题的，和上面无关*/
    float i = 1.0 / 3;
    int j = (int)(1.0 / i);
    float m = 1.0 / i;
    double n = 1.0 / i;
    DDLog(@"dd");
}

// 先旋转 后 变换
- (void)test {
    CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
//    transform = CATransform3DTranslate(transform, 100, 200, 0);
    self.purpleView.layer.transform = transform;
    
    DDLog(@"%@", self.purpleView);

}

// 先变换 后 旋转
- (void)test2 {
    CAAnimation *animation = [CAAnimation animation];
    
//    self.purpleView.layer.anchorPoint = CGPointMake(0, 1);
    DDLog(@"%@", self.purpleView);

    
    CATransform3D transform = CATransform3DMakeTranslation(100, 200, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 1);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1);
    self.purpleView.layer.transform = transform;
    
    DDLog(@"%@", self.purpleView);
    
    [self te];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test];
    
    [self test2];
}

- (void)te {
    [self test3];
}

- (void)test3 {
    [self test];
    @throw [NSException exceptionWithName:@"com.adong" reason:@"ddd" userInfo:nil];
}

///
/// God!!! 突然看到网站上的文章，里面没提到要倒序放变换。觉的奇怪。然后再来试了下，发现： 只要先用CATransform3DIdentity做基石的变换，特么
/// 就不用倒序！！！
///
- (void)demo {
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, DD_SCREEN_WIDTH - 250, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 1);
    transform = CATransform3DScale(transform, 0.5, 0.5, 1);
    self.purpleView.layer.transform = transform;
    
    DDLog(@"1: %@", NSStringFromCGPoint(self.purpleView.center)); ///< 1: {125, 128}
    
    DDLog(@"2: %@", NSStringFromCGPoint(self.purpleView.center)); ///< 2: {125, 128}
    
    DDLog(@"3: %@", NSStringFromCGPoint(self.purpleView.center)); ///< 3: {125, 128}

    delay_main(3, ^{
        /*
            由于怀疑CATransform3DIdentity这个东西，
            尝试再次设置一次，会基于刚才的变换，还是从头的变换呢？
            结论是 从头变换！
         */
        CATransform3D transform1 = CATransform3DIdentity;
        transform1 = CATransform3DTranslate(transform1, -20, 0, 0);
        transform1 = CATransform3DRotate(transform1, -M_PI_2, 0, 0, 1);
        transform1 = CATransform3DScale(transform1, 0.5, 0.5, 1);
        self.purpleView.layer.transform = transform1;
    });
}

@end
