//
//  CrossFirstViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CrossFirstViewController.h"
#import "CrossSecondViewController.h"
@interface CrossFirstViewController ()
@property (nonatomic, weak)UILabel *label  ;
@end

@implementation CrossFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第一个";
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"ddd";
    _label = label ;
    label.frame = CGRectMake(100, 100, 220, 50);
    label.textColor = [UIColor orangeColor];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 70, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    
    ///
    /// Test navigationBar items
    ///
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 44)] ;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15] ;
    [rightBtn setTitle:@"关闭" forState:UIControlStateNormal] ;
    [rightBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal] ;
    [rightBtn setImage:[UIImage imageNamed:@"disclosure_indicator"] forState:UIControlStateNormal] ;
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0) ;
    UIBarButtonItem * rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn] ;
    
//    [self.navigationItem setRightBarButtonItems:@[rightItem1] animated:YES] ;
    
    UIBarButtonItem * rightItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] ;
//    rightItem2.width = - 15 ;
    
    UIBarButtonItem * rightItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:NULL] ;
    
    [self.navigationItem setLeftBarButtonItems:@[rightItem2,rightItem1,rightItem3] animated:YES] ;
}

- (void)adb:(UIButton *)sender
{
    CrossSecondViewController *vc = [[CrossSecondViewController alloc]init];

    vc.whenPopVC = ^(NSString *name){
        self.label.text = name ;
    };
    vc.backVC = self ;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
