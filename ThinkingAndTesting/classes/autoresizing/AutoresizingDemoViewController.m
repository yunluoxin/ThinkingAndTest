//
//  AutoresizingDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/14.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "AutoresizingDemoViewController.h"

@interface AutoresizingDemoViewController ()
@property (nonatomic, strong) UIView *greenView;
@end

@implementation AutoresizingDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 300, 300)];
    greenView.backgroundColor = [UIColor greenColor];
//    greenView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:greenView];
    self.greenView = greenView;
    
    
    NSSet *set1 = [NSSet setWithObjects:@(1), @(3), @5, nil];
    NSSet *set2 = [NSSet setWithObjects:@(3), @5, @1, nil];
    if ([set1 isEqual:set2]) {
        DDLog(@"set1 和 set2 相等");        // 是相等的. 不管次序（内部已经重排）,NSNumber已经重写isEqual方法
    } else {
        DDLog(@"set1 和 set2 不相等");
    }
    /*
     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin:
        同时设置代表着 宽不变，左边距和右边距同比变换！如果左边距为0，右边距有值，则只变换左边！ 如下所示，leftMargin=50,rightMargin=150，则父视图放大后，宽不变，leftMargin/rightMargin的比例不变，同比放大！
     */
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    redView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [greenView addSubview:redView];
    
    
    /*
     UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth:
        代表着左右边距不可以变动，宽和高可伸缩！所以如果marginLeft=20,marginRigtht=20,则父视图放大后，只会宽高部分变大来填充！
     */
    UIView *purpleView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, greenView.dd_width - 40, greenView.dd_height-40)];
    purpleView.backgroundColor = [UIColor purpleColor];
    purpleView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [greenView addSubview:purpleView];

    UILabel *button = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
    button.text = @"我是一个Label";
    button.userInteractionEnabled = YES;
    [greenView addSubview:button];

    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        ///
        /// 一直卡死主线程，画面都没法进入下一个runloop刷新，能够刷新的时候（for执行完成后），已经只能显示最后一个了（最新赋值的）。
        ///
        for (int i = 0; i < 100; i++) {
            [NSThread sleepForTimeInterval:0.02];
            button.text = [NSString stringWithFormat:@"%d", i];
        }
    }];
    [button addGestureRecognizer:tap];
    
    
//    runOnMainQueueWithoutDeadlocking(^{
//        NSLog(@"11%@", button);
//        NSLog(@"test11");
//
//    });
//    NSLog(@"%@", button);
//    NSLog(@"test");
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.greenView.frame = CGRectMake(0, self.greenView.dd_top + 10, self.greenView.dd_width + 20, self.greenView.dd_height + 20);
}

@end
