//
//  NavigationDemo2Controller.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NavigationDemo2Controller.h"
#import "DDNavigationController.h"
#import "NavigationDemoController.h"
#import "FontSizeViewController.h"
@interface NavigationDemo2Controller ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak)UITableView *tableView  ;

@property (nonatomic, weak)UIView *purpleView ;

@property (nonatomic, strong)UIColor *originColor ;
@end

@implementation NavigationDemo2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    self.navigationItem.title = @"首页";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    
    UIView *purpleView = [UIView new];
    _purpleView = purpleView ;
    purpleView.backgroundColor = [UIColor purpleColor] ;
    purpleView.frame = CGRectMake(0, 0, self.view.dd_width , 150);
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView ;
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor ];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.tableHeaderView = purpleView ;
    
    tableView.showsVerticalScrollIndicator = NO ;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 100 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.row];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FontSizeViewController *vc = [[FontSizeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DDNetworkComeNotification object:nil userInfo:@{
                                                                                                              @"indexPath":indexPath
                                                                                                              }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //每次进来都要进行初始化重置
    [self scrollViewDidScroll:self.tableView] ;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y ;
//    DDLog(@"%f",y) ;
    CGFloat h = self.purpleView.dd_height - 64  ;
    if (y < 0) {
        self.navigationController.navigationBarHidden = YES ;
    }else if(y <= h){
        self.navigationController.navigationBarHidden = NO ;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor redColor] colorWithAlphaComponent:y/h]] forBarMetrics:UIBarMetricsDefault] ;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //恢复
    self.navigationController.navigationBarHidden = NO ;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor redColor] colorWithAlphaComponent:0.99]] forBarMetrics:UIBarMetricsDefault] ;
    
    [super viewWillDisappear:animated];
}
@end
