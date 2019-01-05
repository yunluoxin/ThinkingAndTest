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
@end

@implementation TransformDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.purpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 262, 385)];
    self.purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.purpleView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 100, 30)];
    label.textColor = [UIColor greenColor];
    label.text = @"What the fuck!!!";
    [self.purpleView addSubview:label];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask7"]];
    [self.purpleView addSubview:imageV];
    imageV.frame = self.purpleView.bounds;
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
@end
