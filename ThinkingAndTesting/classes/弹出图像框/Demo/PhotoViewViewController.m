//
//  PhotoViewViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "PhotoViewViewController.h"
#import "DDPhotoView.h"
@interface PhotoViewViewController ()

@end

@implementation PhotoViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 50, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)adb:(UIButton *)sender
{
    DDPhotoView *photoView = [[DDPhotoView alloc]initWithFrame:self.view.bounds];
    photoView.image = [UIImage imageNamed:@"4"];
    [self.view addSubview:photoView];
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
