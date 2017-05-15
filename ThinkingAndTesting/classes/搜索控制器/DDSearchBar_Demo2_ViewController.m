//
//  DDSearchBar_Demo2_ViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/5/15.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDSearchBar_Demo2_ViewController.h"
#import "DDSearchBar.h"

@interface DDSearchBar_Demo2_ViewController ()

@end

@implementation DDSearchBar_Demo2_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    /// 返回箭头宽度18，距离左边8，则SearchBar应该至少从18+8=26开始！
    DDSearchBar * searchBar = [[DDSearchBar alloc] initWithFrame:CGRectMake(26, 0, self.view.dd_width - 26, 44)] ;
    searchBar.barTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6] ;
    searchBar.backgroundColor = [UIColor clearColor] ;
    searchBar.cursorHorizontalOffset = 3 ;
    searchBar.searchBarLeftImage = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(20, 20)] ;
    searchBar.placeholderTextColor = [UIColor grayColor] ;
    searchBar.cursorColor = [UIColor cyanColor] ;
    searchBar.showCancelButton = YES ;
    [searchBar.cancelButton setTitle:@"取消" forState:UIControlStateNormal] ;
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:searchBar] ;
    
    UIBarButtonItem * fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] ;
    fixedItem.width = - 16 ;    /// 不知道为什么左右始终有一个16的宽度空格，通过这个消掉, 则上面的计算就正常了
    self.navigationItem.leftItemsSupplementBackButton = YES ;
    self.navigationItem.rightBarButtonItems = @[fixedItem, item] ;  /// fixedItem必须写在前面， 因为rightBarButtonItems是从右开始往左排列
}

@end
