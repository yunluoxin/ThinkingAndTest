//
//  B_ViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/9/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "B_ViewController.h"

@interface B_ViewController ()

@end

@implementation B_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)] ;
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"B控制器" ] ;
    item.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(close)] ;
    bar.items = @[item] ;
    [self.view addSubview:bar] ;

}

- (void)close
{
    if (self.navigationController.viewControllers.count > 1 ) {
        [self.navigationController popViewControllerAnimated:YES] ;
        [NSThread sleepForTimeInterval:3];
        DDLog(@"%@",self);
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            DDLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController);
            DDLog(@"%@---tag:%ld",[UIApplication sharedApplication].keyWindow,[UIApplication sharedApplication].keyWindow.tag);
        }];
        
        [NSThread sleepForTimeInterval:3];
        DDLog(@"%@",self);
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    DDLog(@"%s",__func__);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    DDLog(@"self.view.window-->%@",self.view.window);
    DDLog(@"%@",self.view.window.rootViewController);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**         push情况下
 *  2016-09-01 13:42:21.641 ThinkingAndTesting[12153:422621] 检测到网络改变
    2016-09-01 13:42:30.439 ThinkingAndTesting[12153:422621] <B_ViewController: 0x7fa0e0c3ebe0>
    2016-09-01 13:42:30.439 ThinkingAndTesting[12153:422621] -[B_ViewController viewWillDisappear:]
 */

/**
 *  2016-09-01 13:45:42.865 ThinkingAndTesting[12185:423656] <B_ViewController: 0x7ffe2beb24b0>
    2016-09-01 13:45:42.866 ThinkingAndTesting[12185:423656] -[B_ViewController viewWillDisappear:]
    2016-09-01 13:45:43.371 ThinkingAndTesting[12185:423656] <DDNavigationController: 0x7ffe2d012400>
    2016-09-01 13:45:43.371 ThinkingAndTesting[12185:423656] <UIWindow: 0x7ffe2be949c0; frame = (0 0; 320 568); tag = 111; gestureRecognizers = <NSArray: 0x7ffe2be7eca0>; layer = <UIWindowLayer: 0x7ffe2be7b4a0>>---tag:111
 */

/**
 *  结论是 不管什么情况下， 都是会先依次执行，然后再进行-viewWillDisappear   再进行completetion的block
 */
@end
