//
//  LabelDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/22.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "LabelDemoViewController.h"
#import "InvocationDemoViewController.h"

#import "DDCopiableLabel.h"

@interface LabelDemoViewController ()

@end

@implementation LabelDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"UILabel Demo"  ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:nil action:nil] ;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil] ;
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 30) ] ;
    label.textColor = [UIColor blueColor] ;
    label.text = @"拍摄" ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label] ;
    
    DDCopiableLabel * copiableLabel = [[DDCopiableLabel alloc] initWithFrame:CGRectMake(0, 100, self.view.dd_width, 30)] ;
    [self.view addSubview:copiableLabel] ;
    copiableLabel.text = @"测试一下能不能复制呢！！！" ;
    copiableLabel.backgroundColor = [UIColor purpleColor] ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DDLog(@"%@",[UIPasteboard generalPasteboard].string) ;

    UIViewController * vc = [InvocationDemoViewController new];
    [self.navigationController pushViewController:vc animated:YES] ;
}

@end
