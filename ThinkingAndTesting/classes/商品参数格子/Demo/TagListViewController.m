//
//  TagListViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TagListViewController.h"
#import "TagListView.h"

@interface TagListViewController ()

@end

@implementation TagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TagListView *listView = [[TagListView alloc]initWithFrame:CGRectMake(0, 0, 300, 800)];
    listView.tagContentArray = @[@"颜色A",@"尺寸B",@"大小C",@"颜色A",@"尺寸B",@"大小222C",@"颜色A",@"尺2222222222ssssssssssssss2222222寸B",@"大小C",@"颜色A",@"尺寸B" ];
    listView.keyArray = @[@"color",@"size",@"size2"];
    [self.view addSubview:listView];
    listView.backgroundColor = [UIColor purpleColor];
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
