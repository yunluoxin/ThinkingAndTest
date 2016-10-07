//
//  JDViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "JDViewController.h"
#import "UIButton+Block.h"
#import "JDTabarViewController.h"

@interface JDViewController ()

@end

@implementation JDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
        JDTabarViewController *vc = [[JDTabarViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [button setTitle:@"start" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(0, 100, 100, 50);
    [self.view addSubview:button];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
