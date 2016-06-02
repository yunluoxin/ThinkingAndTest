//
//  DemoConfigViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/31.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoConfigViewController.h"
#import "DDCartGoodsNumberView.h"

@interface DemoConfigViewController ()

@end

@implementation DemoConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    DDLog(@"%@",dic) ;
    
    NSString *str = DDReadProperties(@"abc");
    DDLog(@"%@",str);
    
    DDCartGoodsNumberView *numberView = [[DDCartGoodsNumberView alloc]initWithFrame:CGRectMake(0, 100, DD_SCREEN_WIDTH, 50)];
    [self.view addSubview:numberView];
    numberView.currentNumber = 10 ;
    numberView.minNumber = 2 ;
    numberView.maxNumber = 13 ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"test"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
