//
//  OCAccessViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "OCAccessViewController.h"
#import "ProtectAcessObject.h"

@interface OCAccessViewController ()

@end

@implementation OCAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ProtectAcessSubObject *subObj = [ProtectAcessSubObject new];
    [subObj test];
    [subObj print];
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
