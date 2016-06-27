//
//  DemoSliderViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSliderViewController.h"
#import "DDSliderView.h"

@interface DemoSliderViewController ()

@end

@implementation DemoSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [UILabel new];
    label.text = @"第一个" ;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter ;
    
    UILabel *label2 = [UILabel new];
    label2.text = @"第2个" ;
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentCenter ;
    
    UILabel *label3 = [UILabel new];
    label3.text = @"第3个" ;
    label3.textColor = [UIColor blackColor];
    label3.textAlignment = NSTextAlignmentCenter ;
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor purpleColor];
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor greenColor];
    
    DDSliderView *sliderView = [[DDSliderView alloc]initWithFrame:self.view.bounds withTitleViewHeight:44.0f titleViews:@[label,label2,label3] andContentViews:@[view1,view2]];
    [self.view addSubview:sliderView];
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
