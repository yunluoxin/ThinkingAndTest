//
//  SearchResultViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "SearchResultViewController.h"
#import "DD_NoResult_TableViewCell.h"
@interface SearchResultViewController ()< UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isloaded ;
}
@property (nonatomic, weak)UITableView *tableView ;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isloaded = YES ;
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView ;
    [self.view addSubview:tableView];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    self.tableView.backgroundColor = [UIColor greenColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isloaded) {
        if (self.datas.count == 0) {
            //无结果
            return 1 ;
        }
        return 1 ;
    }
    return 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datas.count==0) {
        return 1 ;
    }
    return self.datas.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count==0) {
        return DD_SCREEN_HEIGHT;
    }
    return 44 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count == 0) {
        DD_NoResult_TableViewCell *cell = [DD_NoResult_TableViewCell cellWithTableView:tableView];
//        cell.tip = @"没网络" ;
        return cell ;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.datas[indexPath.row]];
    return cell ;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count == 0) {
        return NO ;
    }
    return YES ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor purpleColor];
    
}
- (void)setDatas:(NSMutableArray *)datas
{
    _datas = datas ;
    [self.tableView reloadData];
}

//- (void)abc:(NSNotification *)note
//{
//    NetworkDataStatus status = ((NSNumber *)note.userInfo[@"status"]).intValue;
//    switch (status) {
//
//        case NetworkDataStatusNoNetworkNoData:
//        {
//            DDLog(@"当前无网络连接");
//            break;
//        }
//        case NetworkDataStatusHasNetworkNoData:
//        {
//            DDLog(@"出错了");
//            break;
//        }
//        case NetworkDataStatusHasNetworkHasData:
//        {
//            //            DDLog(@"%@",note.userInfo[@"data"]);
//            
//            break;
//        }
//        case NetworkDataStatusNoNetworkHasData:
//        {
//            DDLog(@"%@",note.userInfo[@"data"]);
//            
//            break;
//        }
//
//    }
//    
//}


- (void)dealloc
{
    DDLog(@"dddd");
}
@end
