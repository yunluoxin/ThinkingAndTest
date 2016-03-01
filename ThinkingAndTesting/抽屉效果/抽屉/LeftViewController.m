//
//  LeftViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView ;

@property (nonatomic, strong)NSArray *data ;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initData
{
    _data = @[@"开通会员",@"QQ钱包",@"个性装扮",@"我的收藏",@"我的相册",@"我的文件"];
    
}

- (void)initView
{
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DD_SCREEN_WIDTH, DD_SCREEN_HEIGHT /3)];
    [self.view addSubview:topV];
    topV.backgroundColor = [UIColor greenColor];
    
    CGFloat x = 0;
    CGFloat y = topV.dd_bottom ;
    CGFloat w = DD_SCREEN_WIDTH ;
    CGFloat h = DD_SCREEN_HEIGHT*2/3 ;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    _tableView = tableView ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.textLabel.textColor = [UIColor redColor];
    }
    cell.textLabel.text = self.data[indexPath.row];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(drawerLeftViewController:didSelectRowAtIndex:)]) {
        [_delegate drawerLeftViewController:self didSelectRowAtIndex:indexPath.row];
    }
}
@end
