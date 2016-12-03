//
//  SearchResultDisplayController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/30.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "SearchResultDisplayController.h"

@interface SearchResultDisplayController ()

@end

@implementation SearchResultDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Dfd" ;
    self.view.backgroundColor = [UIColor greenColor] ;
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] ;
    [self.view addSubview:tableView] ;
    tableView.backgroundColor = [UIColor yellowColor] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    DDLog(@"结果更改%@",searchController) ;
}
@end
