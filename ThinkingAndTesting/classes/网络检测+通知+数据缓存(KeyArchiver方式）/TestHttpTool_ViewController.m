//
//  TestHttpTool_ViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/2.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "TestHttpTool_ViewController.h"
#import "TestHttpToolModel.h"

@interface TestHttpTool_ViewController ()

@end

@implementation TestHttpTool_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TestHttpToolModel test:^(id responseObj, NSError *error) {
            if (responseObj) {
                DDLog(@"%@",responseObj) ;
            }
        }] ;
    });
}

@end
