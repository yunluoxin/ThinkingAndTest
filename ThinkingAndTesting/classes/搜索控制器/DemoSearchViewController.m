//
//  DemoSearchViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/30.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSearchViewController.h"
#import "SearchResultDisplayController.h"
@interface DemoSearchViewController ()< UISearchControllerDelegate, UISearchBarDelegate >

@property (nonatomic, strong) UISearchController * searchVC ;

/**
    搜索为空时候的历史数据view
 */
@property (nonatomic, strong) UIView * historyView ;
@end

@implementation DemoSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SearchResultDisplayController * display = [SearchResultDisplayController new] ;
    UISearchController * searchVC = [[UISearchController alloc] initWithSearchResultsController:display] ;
    searchVC.searchResultsUpdater = display ;
    searchVC.delegate = self ;
    self.searchVC = searchVC ;
    searchVC.hidesNavigationBarDuringPresentation = YES ;
    searchVC.obscuresBackgroundDuringPresentation =  NO ;
    searchVC.dimsBackgroundDuringPresentation = NO ;
    searchVC.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor] ;
    searchVC.searchBar.tintColor = [UIColor greenColor] ;
    searchVC.searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 0) ;
    searchVC.searchBar.delegate = self ;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] ;
    tableView.backgroundColor = [UIColor yellowColor] ;
    [self.view addSubview:tableView] ;
    tableView.tableHeaderView = searchVC.searchBar ;
    

    //设置"取消"按钮的颜色
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} forState:UIControlStateNormal] ;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_historyView removeFromSuperview] ;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES ;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        //searchController的view的第一个子view
        UIView * view = [self.searchVC.view.subviews firstObject] ;
        [view insertSubview:self.historyView atIndex:0] ;
    }
}


#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController
{
    //searchController的view的第一个子view
    UIView * view = [searchController.view.subviews firstObject] ;
    [view addSubview:self.historyView] ;
}

- (void)didPresentSearchController:(UISearchController *)searchController
{

}

#pragma mark - Actions

- (void)closeKeyboard
{
    [self.searchVC.searchBar endEditing:YES] ;
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
