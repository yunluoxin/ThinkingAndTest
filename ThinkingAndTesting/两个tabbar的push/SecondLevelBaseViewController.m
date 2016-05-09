//
//  SecondLevelBaseViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/14.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "SecondLevelBaseViewController.h"

@interface SecondLevelBaseViewController ()

@end

@implementation SecondLevelBaseViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES ;
    if (self.navigationItem) {
        [self.navigationItem addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([@"title" isEqualToString:keyPath]) {
        NSString *title = change[NSKeyValueChangeNewKey];
        if (self.navigationController.viewControllers.count == 1) {
            self.tabBarController.navigationItem.title = title ;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        //当前不处于第一层的栈了
        self.navigationController.navigationBar.hidden = NO ;
        self.tabBarController.navigationController.navigationBar.hidden = YES ;
    }else{
        self.navigationController.navigationBar.hidden = YES ;
        self.tabBarController.navigationController.navigationBar.hidden = NO ;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    if (self.navigationItem) {
        [self.navigationItem removeObserver:self forKeyPath:@"title" context:NULL];
    }
}
@end
