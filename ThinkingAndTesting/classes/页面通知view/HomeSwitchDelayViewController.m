//
//  HomeSwitchDelayViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/21.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "HomeSwitchDelayViewController.h"

@interface HomeSwitchDelayViewController ()

@end

@implementation HomeSwitchDelayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) applicationWillEnterForeground {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [NSThread sleepForTimeInterval:2];
//        DDLog(@"i in vc will be executing at");
//    });
//    asyn_global(^{
//        asyn_main(^{
//            [NSThread sleepForTimeInterval:2];
//            DDLog(@"i will be executing at");
//        });
//    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DDLog(@"%s", __func__);
}
@end
