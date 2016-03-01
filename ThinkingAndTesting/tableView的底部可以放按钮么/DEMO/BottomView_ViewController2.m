//
//  BottomView_ViewController2.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BottomView_ViewController2.h"
#import "DDTableView.h"
@interface BottomView_ViewController2 ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isLoaded ;
}

@property (nonatomic, weak)DDTableView *tableView ;
@end

@implementation BottomView_ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self ;
    DDTableView *tableView = [[DDTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
    [self.view addSubview:tableView];
    
    tableView.tips = @"没有网络耶！shuaxin试试吧！";
    tableView.whenRefreshBtnClicked = ^(){
        [weakSelf.tableView reloadData];
    };
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SYSTEM_ID"];

    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYSTEM_ID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.row];
    return cell ;
}

- (void)test
{
    _isLoaded = !_isLoaded ;
    [self.tableView reloadData];
}

@end
