//
//  AttributeTextViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AttributeTextViewController.h"
#import "NSMutableAttributedString+DD.h"
@interface AttributeTextViewController ()

@end

@implementation AttributeTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *str = @"我们是共产主义接班人";

    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:20],
                          NSForegroundColorAttributeName:[UIColor greenColor]
                          };
    NSDictionary *dic2 = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:5],
                          NSForegroundColorAttributeName:[UIColor redColor]
                          };
    NSMutableAttributedString *attrStr =   [NSMutableAttributedString attributedStringWithString:str rangeStringAttributes:@{@"主义":dic,@"接班":dic2}];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 50)];
    label.font = [UIFont systemFontOfSize:12];

    label.attributedText = attrStr ;
    
//    [attrStr removeAttribute:NSFontAttributeName range:[str rangeOfString:@"接班"]];
    [attrStr removeAttribute:NSFontAttributeName rangeString:@"主义"];
    label.attributedText = attrStr ;//必须赋值，否则上面的移除无效（view的attributedText属性是copy）
    
    [self.view addSubview:label];

}

@end
