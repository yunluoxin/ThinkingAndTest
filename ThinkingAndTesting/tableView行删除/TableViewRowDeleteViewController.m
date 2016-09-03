//
//  TableViewRowDeleteViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TableViewRowDeleteViewController.h"
#import "UINavigationBar+CustomStyle.h"
#import "TableViewDeleteCell.h"

@interface TableViewRowDeleteViewController ()<UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *data ;
@property (nonatomic, strong) NSMutableArray *groups ;
@end

@implementation TableViewRowDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.extendedLayoutIncludesOpaqueBars = YES ;
    self.navigationItem.title = @"测试" ;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    self.tableView.rowHeight = 60.0f ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    
    
//    self.navigationController.navigationBar.translucent = YES ;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor] backIndicatorImage:nil titleColor:[UIColor blackColor] rightItemColor:[UIColor purpleColor]];
}


#pragma mark - UITableView的DataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.groups.count ;
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groups[section] ;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 8.0f ;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8.0f ;
//}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewDeleteCell *cell = [TableViewDeleteCell cellWithTableView:tableView];
    id obj = self.data[indexPath.row] ;
    cell.label.text = obj;
//    DDLog(@"------%@",indexPath);
    cell.whenDeleteBtnClicked = ^(){
        NSInteger index = [self.data indexOfObject:obj];
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        return ;
    };
    return cell ;
}


#pragma mark - UITableView的delegate方法

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        /**
         *  必须先删除数据！！！！再删除图像！！！！！！！！！因为删除图像后，Cell的indexPath会重新排。这时候用removeObjectAtIndex删除的就不是刚刚那个了。
         */
        DDLog(@"删除确认%ld",indexPath.row + 1);
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        /**
         *  下面这样作也不行！！！！
         */
        /*
        NSObject *obj = self.data[indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.data removeObject:obj];
         */
        
        
        
        /**----组删除测试--------*/
        
//        DDLog(@"删除第%ld组",indexPath.section + 1) ;
//        [self.groups removeObjectAtIndex:indexPath.section];
//        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
        /** ===组删除测试成功=== */
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"我要删除" ;
}

- (void)refresh
{
    [self.tableView reloadData];
}

#pragma mark - lazy load
- (NSMutableArray *)data
{
    if (!_data) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0 ; i < 10; i ++) {
            [arrayM addObject:[NSString stringWithFormat:@"第%d行",i+1]] ;
            
        }
        _data = arrayM ;
    }
    return _data ;
}

- (NSMutableArray *)groups
{
    if (!_groups) {
        NSMutableArray *arrayMSection = [NSMutableArray array ] ;
        for (int i = 0 ; i < 10 ; i ++) {
            [arrayMSection addObject:[NSString stringWithFormat:@"第%d组",i + 1]] ;
        }
        _groups = arrayMSection ;
    }
    return _groups ;
}
@end
