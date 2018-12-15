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

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.greenView.frame = CGRectMake(0, self.greenView.dd_top + 10, self.greenView.dd_width + 20, self.greenView.dd_height + 20);
}

@end
