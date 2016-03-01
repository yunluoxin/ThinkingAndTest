//
//  BottomView_ViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/2.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BottomView_ViewController.h"
#import "DDTableViewCell.h"
@interface BottomView_ViewController()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isLoaded ;
}
@property (nonatomic, weak)UITableView *tableView ;
@end
@implementation BottomView_ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //增加一个背景View
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    //增加一个提示
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0 ;
    label.text = @"好像没有数据哦亲，检测下网络再重新加载试试吧！";
    CGSize size = [label.text sizeOfFont:label.font maxWidth:DD_SCREEN_WIDTH/2 maxHeight:100];
    CGFloat lx = (DD_SCREEN_WIDTH - size.width)/2 ;
    CGFloat ly = 200 ;
    label.frame = CGRectMake(lx, ly, size.width, size.height);
    [backgroundView addSubview:label];
    
    
    //增加一个按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat bw = 80 ;
    CGFloat bx = (DD_SCREEN_WIDTH - bw)/2 ;
    CGFloat by = CGRectGetMaxY(label.frame) + 20 ;
    button.frame = CGRectMake(bx, by , bw, 30);
    button.layer.masksToBounds = YES ;
    button.layer.cornerRadius = 3 ;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(RefreshAgain:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:button];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
    [self.view addSubview:tableView];
    self.tableView.backgroundView = backgroundView ;
    
//    [self.tableView registerClass:[DDTableViewCell class] forCellReuseIdentifier:@"SYSTEM_ID"];
        [self.tableView registerNib:[UINib nibWithNibName:@"DDTableViewCell" bundle:nil] forCellReuseIdentifier:@"SYSTEM_ID"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, DD_SCREEN_HEIGHT - 30, 30, 30);
    [self.view addSubview:btn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isLoaded) {
        return 1 ;
    }
    return 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30 ;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYSTEM_ID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.row];
    return cell ;
}


#pragma mark - 再刷新一次时候的操作

- (void)RefreshAgain:(UIButton *)button
{
    DDLog(@"-----");
}

- (void)test
{
    _isLoaded = !_isLoaded ;
    [self.tableView reloadData];
}
@end
