//
//  DemoGestureUnlockViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/9/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoGestureUnlockViewController.h"
#import "GestureUnlockView.h"
#import "UIImage+Compress.h"
@interface DemoGestureUnlockViewController ()<GestureUnlockViewDelegate>

@end

@implementation DemoGestureUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GestureUnlockView *lockView = [[GestureUnlockView alloc]initWithFrame:self.view.bounds] ;
    [self.view addSubview:lockView] ;

    UIImage *image = [UIImage scaleImage:[UIImage imageNamed:@"ali.jpg"] toScale:0.1];
    UIImage *normalImage = [self imageWithBigCircleRadius:image.size.width/2 andSmallCircleRadius:image.size.width/2 - 10] ;
    lockView.colNumber = 4 ;
    lockView.rowNumber = 5 ;
    lockView.selectedImage = image ;
    lockView.normalImage = normalImage ;
    lockView.delegate = self ;
}

- (BOOL)gestureUnlockView:(GestureUnlockView *)view isRightWithReceivedInput:(NSString *)input
{
    NSLog(@"%@",input) ;
    return NO ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageWithBigCircleRadius:(CGFloat)bigRadius andSmallCircleRadius:(CGFloat)smallRadius
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bigRadius * 2 + 2 , bigRadius * 2 + 2), NO, 0) ;
    CGPoint center = CGPointMake(bigRadius + 1 , bigRadius + 1) ;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:bigRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES ];
    [[UIColor greenColor] setStroke] ;
    path.lineWidth = 2 ;
    [path stroke] ;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:smallRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES ];
    [[UIColor yellowColor] setStroke] ;
    path2.lineWidth = 2 ;
    [path2 stroke] ;
    
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:center radius:10 startAngle:0 endAngle:M_PI * 2 clockwise:YES ];
    [[UIColor redColor] setFill] ;
    [path3 fill] ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}

@end
