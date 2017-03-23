//
//  DemoSearchViewController_IOS7.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSearchViewController_IOS7.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

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
    searchBar.tintColor = [UIColor greenColor] ;
    searchBar.barTintColor = [UIColor groupTableViewBackgroundColor] ;
    
    ///
    /// 此处的contentsController 只是用来:
    ///     1. 提供数据源，行使DataSource和Delegate的义务
    ///     2. 为UISearchDisplayController内部的SearchResultTableView提供一个容身之地（此tableView为建立在contentController.view上面）
    ///
    self.display = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController: self] ;
    self.display.delegate = self ;
    self.display.searchResultsDataSource = self ;
    self.display.searchResultsDelegate = self ;
    
    //设置"取消"按钮的颜色
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} forState:UIControlStateNormal] ;
    
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] ;
    [self.view addSubview:tableView] ;
    tableView.tableHeaderView = searchBar ;
//    self.navigationItem.titleView = searchBar ;   // 改成这个后，所有的失效！！！都不能用了。。。。。。。。。
    [searchBar sizeToFit] ;
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
    // 添加自己的view
    UIView * wrapperView = [self p_wrapperViewOfSearchDisplayController:controller] ;
    [wrapperView addSubview:self.historyView] ;
    
    //移除dimmingView所在的视图
    UIView * dimmingView = [self p_dimmingViewOfSearchDisplayController:controller] ;
    [dimmingView removeFromSuperview] ;

}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{

}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    DDLog(@"结束搜索") ;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length > 0) {
        // 有文字出现，就把自己放在最底部
        UIView * wrapperView = [self p_wrapperViewOfSearchDisplayController:self.display] ;
        if ([wrapperView.subviews firstObject] != self.historyView) {
            [wrapperView insertSubview:self.historyView atIndex:0] ;
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_historyView removeFromSuperview] ;
    _historyView = nil ;
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


#pragma mark - private methods

- (UIView *)p_wrapperViewOfSearchDisplayController:(UISearchDisplayController *)controller
{
    UIView * containerView  = [self p_containerViewOfSearchDisplayController:controller] ;
    
    UIView * wrapperView  = [containerView.subviews firstObject] ;
    
    // 只是设置下，为了防止第一个不是WrapperView，变成UISearchBar了
    if ([wrapperView isKindOfClass:[UISearchBar class]]) {
        return nil ;
    }
    
    return wrapperView ;
}

- (UIView *)p_containerViewOfSearchDisplayController:(UISearchDisplayController *)controller
{
    static NSString *const SearchDisplayControllerContainerViewKey = @"_containerView" ;
    
    ///
    /// containerView相当于平时的UINavigationViewController的layoutContainerView，会提供一层包装，里面有 先是一个transitionView, 还有一个盖在上面的导航bar.
    /// 延伸到这里，就是， UISearchDisplayController里面包含了一个ContainerView(加到contentController.view上的），里面包含有一个能wrap tableView的view， 还有一个同级的searchBar盖在上面。
    ///
    UIView * containerView = [controller valueForKey:SearchDisplayControllerContainerViewKey] ;
    
    return containerView ;
}

- (UIView *)p_dimmingViewOfSearchDisplayController:(UISearchDisplayController *)controller
{
    UIView * containerView = [self p_containerViewOfSearchDisplayController:controller] ;
    
    static NSString * const SearchDisplayControllerDimmingViewKey = @"_bottomView" ;
    
    UIView * dimmingView = [containerView valueForKey:SearchDisplayControllerDimmingViewKey] ;
    
    return dimmingView ;
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
#pragma clang diagnostic pop
