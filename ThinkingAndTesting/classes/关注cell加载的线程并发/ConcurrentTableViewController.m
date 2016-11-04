//
//  ConcurrentTableViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ConcurrentTableViewController.h"

@interface ConcurrentTableViewController ()< UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *data ;
@property (nonatomic, strong) NSMutableArray *groups ;

@end

@implementation ConcurrentTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"测试" ;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    self.tableView.rowHeight = 60.0f ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coming:) name:@"coming" object:nil] ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"coming" object:nil] ;
    });
}


#pragma mark - UITableView的DataSource方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.groups.count ;
//    return 1 ;
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
    DDLog(@"%@",indexPath) ;
    
    static NSString * CellID = @"UITableViewCell" ;
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID] ;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID] ;
    }
    
    cell.textLabel.text = self.data[indexPath.row] ;
    return cell ;
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


#pragma mark - Actions

- (void)coming2:(NSNotification *)note
{
    
    //-----------  safe -------------
    
    DDLog(@"come the notification---%@",note) ;
    self.tableView.contentOffset = CGPointMake(0, -50) ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLog(@"要变更了" );
        [self.data removeAllObjects] ;
        [self.tableView reloadData] ;
    }) ;
}


- (void)coming:(NSNotification *)note
{
    //--------   no safe , may be crash ----------
    
    DDLog(@"come the notification---%@",note) ;
    self.tableView.contentOffset = CGPointMake(0, -50) ;
    [self.data removeAllObjects] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLog(@"要变更了" );
        
        [self.tableView reloadData] ;
    }) ;
}

@end
