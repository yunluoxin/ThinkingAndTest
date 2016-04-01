
//
//  NavigationDemoController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NavigationDemoController.h"
#import "NavigationDemo2Controller.h"
#import "DDNavigationController.h"
#import "FontSizeViewController.h"

@interface NavigationDemoController ()

@end

@implementation NavigationDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    purpleView.frame = CGRectMake(0, 0, DD_SCREEN_WIDTH, 100);
    
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenView];
    greenView.frame = CGRectMake(0, purpleView.dd_bottom, DD_SCREEN_WIDTH, 200);
    
    
    UIView *yellowView = [UIView new];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellowView];
    yellowView.frame = CGRectMake(0, greenView.dd_bottom, DD_SCREEN_WIDTH, DDScreenHeightWithoutStatusBar - greenView.dd_bottom);
//    DDLog(@"%@",NSStringFromCGRect(yellowView.frame));
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame =  CGRectMake(0, 100, 100, 50);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
//    DDLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:DDNetworkComeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    DDLog(@"%@",NSStringFromCGRect(self.view.frame));
}
- (void)push
{
    NavigationDemo2Controller *vc = [[NavigationDemo2Controller alloc]init];
    DDNavigationController *nav = [[ DDNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)test:(NSNotification *)note
{
    DDLog(@"%@",note.userInfo);
}
@end
