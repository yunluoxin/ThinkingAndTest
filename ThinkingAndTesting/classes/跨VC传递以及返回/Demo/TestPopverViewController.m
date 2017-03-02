
//
//  TestPopverViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/22.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "TestPopverViewController.h"

@interface TestPopverViewController ()<UIAdaptivePresentationControllerDelegate>

@end

@implementation TestPopverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor] ;
    [UIApplication sharedApplication].statusBarHidden = YES ;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(300, 300) ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone ;
}
@end
