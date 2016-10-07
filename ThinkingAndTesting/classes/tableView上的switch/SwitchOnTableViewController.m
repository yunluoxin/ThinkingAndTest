//
//  SwitchOnTableViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/9/6.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "SwitchOnTableViewController.h"

@interface SwitchOnTableViewController ()<UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, assign) BOOL on ;

@end

@implementation SwitchOnTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"tableView上的switcher" ;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
}

#pragma mark - UITableView的DataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f ;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ] ;

    }
    
    if (indexPath.row ==  0) {
        UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 2 , 2)] ;          //UISwitch固定大小，并且继承自UIControll,所有有addTarget方法
        [switch1 addTarget:self action:@selector(turnOnSwitch:) forControlEvents:UIControlEventValueChanged ] ;
        switch1.tag = 111 ;
        switch1.on = self.on ;
        cell.accessoryView = switch1 ;
    }else{
        cell.accessoryView = nil ;
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    return cell ;
}




#pragma mark - event observe

- (void)turnOnSwitch:(UISwitch *)sw
{
    DDLog(@"%ld",sw.tag) ;
    self.on = sw.isOn ;
}





@end
