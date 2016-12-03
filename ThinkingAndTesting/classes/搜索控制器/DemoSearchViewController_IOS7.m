//
//  DemoSearchViewController_IOS7.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSearchViewController_IOS7.h"
#import "SearchResultDisplayController.h"
@interface DemoSearchViewController_IOS7 ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchDisplayController * display ;
/**
 搜索为空时候的历史数据view
 */
@property (nonatomic, strong) UIView * historyView ;
@end

@implementation DemoSearchViewController_IOS7

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor] ;
    
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, DD_SCREEN_WIDTH, 44)] ;
    searchBar.delegate = self ;
    [searchBar sizeToFit] ;
    searchBar.tintColor = [UIColor greenColor] ;
    searchBar.barTintColor = [UIColor groupTableViewBackgroundColor] ;
    
    self.display = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController: self] ;
    self.display.delegate = self ;
    self.display.searchResultsDataSource = self ;
    self.display.searchResultsDelegate = self ;
    
    //设置"取消"按钮的颜色
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} forState:UIControlStateNormal] ;
    
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] ;
    [self.view addSubview:tableView] ;
    tableView.tableHeaderView = searchBar ;
}

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
    return 44.0f ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"dfasdf" ;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID] ;
        cell.textLabel.text = [NSString stringWithFormat:@"%ld%ld",indexPath.section, indexPath.row] ;
    }
    return cell ;
}


- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    UIView * containerView = [controller valueForKey:@"_containerView"] ;
    UIView * view = [containerView.subviews firstObject] ;
    [view addSubview:self.historyView] ;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    //移除dimmingView所在的视图
    UIView * containerView = [self.display valueForKey:@"_containerView"] ;
    UIView * bottomView = [containerView valueForKey:@"_bottomView"] ;
    [bottomView removeFromSuperview] ;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    DDLog(@"结束搜索") ;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length > 0) {
        //searchController的view的第一个子view
        UIView * containerView = [self.display valueForKey:@"_containerView"] ;
        UIView * view = [containerView.subviews firstObject] ;
        [view insertSubview:self.historyView atIndex:0] ;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_historyView removeFromSuperview] ;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    DDLog(@"%@",searchString) ;
    return YES ;
}


#pragma mark - Actions

- (void)closeKeyboard
{
    [self.display.searchBar endEditing:YES] ;
}

#pragma mark - getter and setter

- (UIView *)historyView
{
    if (!_historyView) {
        _historyView = [[UIView alloc] initWithFrame:self.view.frame] ;
        _historyView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8] ;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 50)] ;
        label.text = @"SD龙卷风连接了" ;
        label.textColor = [UIColor purpleColor] ;
        [_historyView addSubview:label] ;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)] ;
        [_historyView addGestureRecognizer:tap] ;
    }
    return _historyView ;
}

@end
