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
    self.navigationItem.title = @"首页";
    self.extendedLayoutIncludesOpaqueBars = YES ;
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    
    UIView *purpleView = [UIView new];
    _purpleView = purpleView ;
    purpleView.backgroundColor = [UIColor purpleColor] ;
//    [self.view addSubview:purpleView];
    purpleView.frame = CGRectMake(0, 0, DD_SCREEN_WIDTH, 150);
//
//    
//    UIView *greenView = [UIView new];
//    greenView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:greenView];
//    greenView.frame = CGRectMake(0, purpleView.dd_bottom, DD_SCREEN_WIDTH, 200);
    

    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.dd_width, self.view.dd_height) style:UITableViewStylePlain];
    _tableView = tableView ;
    [self.view addSubview:tableView];
//    tableView.backgroundColor = [UIColor whiteColor ];
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
    UIViewController *vc = [[UIViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DDNetworkComeNotification object:nil userInfo:@{
                                                                                                              @"indexPath":indexPath
                                                                                                              }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    CGPoint point =  _tableView.contentOffset  ;
    _tableView.contentOffset = CGPointMake(point.x, point.y+1);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y ;
    CGFloat h = (_purpleView.dd_height - 64) ;
    DDNavigationController *nav = (DDNavigationController*) self.navigationController ;
    if (y < 0) {
        self.navigationController.navigationBar.alpha = 0 ;
    }else{
        self.navigationController.navigationBar.alpha = 1 ;
        if (y < h) {
            [nav setBackgroundColorAlpha:y/h ];
            
        }else{
            [nav setBackgroundColorAlpha:1 ];
        }
        
//        UIColor *color = self.navigationController.navigationBar.barTintColor  ;
//        self.navigationController.navigationBar.backgroundColor  = [color colorWithAlphaComponent:y/h];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    DDNavigationController *nav = (DDNavigationController*) self.navigationController ;
    nav.navigationBar.translucent = NO ;
    [nav setBackgroundColorAlpha:0];
    [super viewWillDisappear:animated];
}
@end
