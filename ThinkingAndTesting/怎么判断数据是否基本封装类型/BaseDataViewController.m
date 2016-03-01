//
//  BaseDataViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BaseDataViewController.h"
#import "NSString+ClassBelonged.h"
@interface BaseDataViewController ()

@end

@implementation BaseDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLog(@"NSNumber是否是Value的一种%d",[@(5) isKindOfClass:[NSValue class]]); //Answer:是
    [NSString test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
