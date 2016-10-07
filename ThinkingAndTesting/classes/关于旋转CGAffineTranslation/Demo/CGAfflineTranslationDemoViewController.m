//
//  CGAfflineTranslationDemoViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CGAfflineTranslationDemoViewController.h"

@interface CGAfflineTranslationDemoViewController ()
@property (nonatomic, assign)BOOL isRotated ;

@property (nonatomic, weak) UIImageView *imageV ;
@end

@implementation CGAfflineTranslationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [self.view addSubview:button] ;
    button.frame = CGRectMake(100, 300, 50, 50  );
    [button addTarget:self action:@selector(rotation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    imageV.frame = CGRectMake(50, 400, 50, 50  );
    [self.view addSubview:imageV];
    _imageV = imageV ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotation:(UIButton *)button
{
    if (!_isRotated) {
        [UIView animateWithDuration:1 animations:^{
            button.transform = CGAffineTransformMakeRotation(M_PI);//选择180度
            DDLog(@"没");
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            button.transform = CGAffineTransformMakeRotation(M_PI_2);//选择180度
        } completion:^(BOOL finished) {
            
        }];
    }


//    if (_isRotated) {
//
//        [UIView animateWithDuration:1.2f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            _imageV.dd_top += 300 ;
//        } completion:^(BOOL finished) {
//            //            _imageV.dd_top += 400 ;
//        }];
//    }else{
//        [UIView animateWithDuration:1.2f delay:0 usingSpringWithDamping:0.4f initialSpringVelocity:1 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
//            _imageV.dd_top -= 300 ;
//        } completion:^(BOOL finished) {
//            //            _imageV.dd_top += 400 ;
//        }];
//    }
    
        _isRotated = !_isRotated ;
    
    
}

@end
