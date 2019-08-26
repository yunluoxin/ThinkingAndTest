//
//  ImageEffectCompareVC.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/8/23.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "ImageEffectCompareVC.h"
#import "ImageEffectCompareView.h"

@interface ImageEffectCompareVC ()

@end

@implementation ImageEffectCompareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ImageEffectCompareView *view = [[ImageEffectCompareView alloc] initWithFrame:CGRectMake(0, 150.0, self.view.bounds.size.width, 500.0)];
    [self.view addSubview:view];
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
