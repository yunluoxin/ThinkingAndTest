//
//  NibCanAwakeViewController2ViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//
//  @attention 在调用vc的init时候，如果有VC同名的xib会自动调用，这是我们已经知道的！但是实质上
//             调用的-initWithNibName:bundle:方法里面，不会调用-initWithCoder:，故也就不会调用awakeFromNib！！！
//

#import "NibCanAwakeViewController2ViewController.h"

@interface NibCanAwakeViewController2ViewController ()

@end

@implementation NibCanAwakeViewController2ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    DDLog(@"%s", __func__);
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        DDLog(@"%s", __func__);
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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
