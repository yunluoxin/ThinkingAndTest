//
//  NibCanAwakeViewController2ViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NibCanAwakeViewController2ViewController.h"

@interface NibCanAwakeViewController2ViewController ()

@end

@implementation NibCanAwakeViewController2ViewController

- (void)awakeFromNib
{
    NSLog(@"awakeFromNib");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
    2016-01-29 08:29:43.383 ThinkingAndTesting[29331:1119880] awakeFromNib
 */
@end
