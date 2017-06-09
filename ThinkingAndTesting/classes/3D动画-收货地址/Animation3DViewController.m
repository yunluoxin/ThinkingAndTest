//
//  Animation3DViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/5.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "Animation3DViewController.h"

@interface Animation3DViewController ()

@property (weak, nonatomic)UIView * myView ;

@property (weak, nonatomic)UIView * allView ;
@end

@implementation Animation3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.myView = self.navigationController.view;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    
    [self.myView addGestureRecognizer:tap];
}

// 添加3D效果的动画

-(CATransform3D)firstTransform{
    
    CATransform3D t1 = CATransform3DIdentity;
    
    t1.m34 = 1.0/-900;
    
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    
    //绕x旋转
    
    t1 = CATransform3DRotate(t1, 15.0*M_PI/180.0, 1, 0, 0);
    
    return t1;
    
}

-(void)tapped:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.myView.layer setTransform:[self firstTransform]];
        
        UIView * all = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, [UIScreen mainScreen].bounds.size.width, 400)];
        
        self.allView = all;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [all addGestureRecognizer:tap];
        
        all.backgroundColor = [UIColor yellowColor];
        
        UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
        
        [window addSubview:all];
        
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            //缩小红色View的面积并且改变黄色View的Y值
            
            self.myView.transform = CGAffineTransformMakeScale(0.9, 0.95);
            
            self.allView.frame = CGRectMake(0, self.view.bounds.size.height - 400, [UIScreen mainScreen].bounds.size.width, 400);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

// 还原的动画
- (CATransform3D)firstTransfrom3{
    
    CATransform3D t1 = CATransform3DIdentity;
//    
//    t1.m34 = 1.0/-00;
//    
//    t1 = CATransform3DScale(t1, 1, 1, 1);
//    
//    t1 = CATransform3DRotate(t1, 15*M_PI/180.0, 1, 0, 0);
    
    return t1;
    
}

- (void)tap:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.allView.frame = CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 400);
        
        [self.myView.layer setTransform:[self firstTransfrom3]];
        
    } completion:^(BOOL finished) {
        
//        [self.allView removeFromSuperview];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            self.myView.transform = CGAffineTransformMakeScale(1, 1);
//            
//        }];
        
    }];
    
}

@end
