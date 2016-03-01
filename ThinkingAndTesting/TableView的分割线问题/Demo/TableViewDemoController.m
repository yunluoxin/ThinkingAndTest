//
//  TableViewDemoController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TableViewDemoController.h"

@interface TableViewDemoController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak)UITableView *tableView ;

@property (nonatomic, strong)NSArray *data ;
@end

@implementation TableViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView ;
    [self.view addSubview:tableView];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    
}

//---------------------------------------------------------------------------------------
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

//---------------------------------------------------------------------------------------
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)data
{
    if (!_data) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0 ; i < 100;  i ++) {
            [arrayM addObject:@(i)];
        }
        _data = [arrayM copy];
    }
    return _data ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];

    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.data[indexPath.row]];
    return cell ;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
}
@end
