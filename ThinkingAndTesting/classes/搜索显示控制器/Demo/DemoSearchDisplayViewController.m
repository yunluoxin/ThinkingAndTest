//
//  DemoSearchDisplayViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSearchDisplayViewController.h"
#import "SearchResultViewController.h"
#import "UIButton+Block.h"
@interface DemoSearchDisplayViewController ()<UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
@property (nonatomic, strong)NSMutableArray *data ;

@property (nonatomic, weak)UITableView *tableView ;

@property (nonatomic, strong)UISearchController *searVC ;
@end

@implementation DemoSearchDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView ;
    [self.view addSubview:tableView];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    SearchResultViewController *resultVC = [[SearchResultViewController alloc]init];
    _searVC = [[UISearchController alloc]initWithSearchResultsController:resultVC];
    _searVC.searchResultsUpdater = self ;
    
//    self.tableView.tableHeaderView = _searVC.searchBar ;
//    self.definesPresentationContext = YES;
//    _searVC.dimsBackgroundDuringPresentation = NO ;
//    _searVC.obscuresBackgroundDuringPresentation = NO ;
//    _searVC.hidesNavigationBarDuringPresentation = NO ;
    _searVC.delegate = self ;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    /**
     *  !!!!---防止最后点取消后，已经没有输入串了但是还会重新加载这个方法，导致结果的vc出现无结果一闪而过
     */
    if (!searchController.isActive) {
        return ;
    }
    
    NSString *str =  searchController.searchBar.text ;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < self.data.count; i ++) {
        NSString *s =[NSString stringWithFormat:@"%d",i];
        NSRange range = [s rangeOfString:str];
        if (range.location!= NSNotFound) {
            [tempArray addObject:@(i)];
        }
    }

    
    
    SearchResultViewController *resultVC = (SearchResultViewController *)searchController.searchResultsController ;
    resultVC.datas = tempArray ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
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

- (NSMutableArray *)data
{
    if (!_data) {
        _data = [NSMutableArray array];
        for (int i = 0 ; i < 100; i++) {
            [_data addObject:@(i)];
        }
    }
    return _data ;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    UIView *sV = _searVC.view.subviews[0];
    sV.backgroundColor = DDColor(255, 255, 255, 0.5) ;
    
    UIView *maskV = [[UIView alloc]initWithFrame:sV.bounds];
    maskV.tag = 1 ;
    [sV insertSubview:maskV atIndex:0 ];
    
    __weak typeof(self) weakSelf = self ;
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor purpleColor];
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
    [button setTitle:@"下一页" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(0, 100, 100, 50);
    [maskV addSubview:button];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    for (UIView *view in _searVC.view.subviews[0].subviews) {
        if (view.tag == 1) {
            [view removeFromSuperview];
            return ;
        }
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.tableHeaderView = _searVC.searchBar ;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_searVC.searchBar removeFromSuperview];
    [_searVC setActive:NO]; //必须设置，否则接下去的vc的view都会在一个模糊的view下不可点击
    [super viewWillDisappear:animated];
}
@end
