
//
//  ExtendedTableViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ExtendedTableViewController.h"
#import "ExtendedTableView.h"
#import "ExtendedTableViewCell.h"

@interface ExtendedTableViewController ()<UITableViewDelegate,UITableViewDataSource,ExtendedTableViewDelegate>
@property (nonatomic, weak)ExtendedTableView *tableView ;

@end

@implementation ExtendedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES ;
    
    ExtendedTableView *tableView = [[ExtendedTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
}

#pragma mark - UITableView的DataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEqualToSelectedIndexPath:indexPath]) {
        return [self tableView:tableView extendedHeightForRowAtIndexPath:indexPath];
    }
    return 51 ;
}

- (CGFloat)tableView:(UITableView *)tableView extendedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEqualToSelectedIndexPath:indexPath]) {
        return [self tableView:tableView extendedCellForRowAtIndexPath:indexPath];
    }
    ExtendedTableViewCell *cell = [ExtendedTableViewCell cellWithTableView:tableView ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.nameLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView extendedCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExtendedTableViewCell *cell = [ExtendedTableViewCell cellWithTableView:tableView ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.nameLabel.text = [NSString stringWithFormat:@"第---%ld行",indexPath.row];
    return cell ;
}

#pragma mark - UITableView的delegate方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView extendCellAtIndexPath:indexPath animated:YES goToTop:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView shrinkCellWithAnimated:YES];
}
@end
