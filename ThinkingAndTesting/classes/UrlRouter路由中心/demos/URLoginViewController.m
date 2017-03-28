//
//  URLoginViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/28.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "URLoginViewController.h"

@interface URLoginViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView ;

@end

@implementation URLoginViewController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super init]) {
        // init some datas
    }
    return self ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}


#pragma mark - view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"URLoginViewController" ;
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    // open network
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES] ;
    
//    [self.tableView reloadData] ;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"" ;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"" ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellIdentifier" ;
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID ] ;
        cell.textLabel.font = [UIFont systemFontOfSize:17] ;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11] ;
        cell.detailTextLabel.textColor = [UIColor orangeColor] ;
    }
    return cell ;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
    
}



#pragma mark - actions
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.whenPopVC) {
        self.whenPopVC(YES) ;
    }
}

#pragma mark - private methods



#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped] ;
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        _tableView.tableFooterView = [UIView new] ;
        [self.view addSubview:_tableView] ;
    }
    return _tableView ;
}

@end
