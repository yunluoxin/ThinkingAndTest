//
//  DDSearchBar_Demo_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/23.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDSearchBar_Demo_ViewController.h"

#import "DDSearchBar.h"

@interface DDSearchBar_Demo_ViewController ()

@end

@implementation DDSearchBar_Demo_ViewController

#pragma mark - life cycle

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"DDSearchBar Demo" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    DDSearchBar * searchBar = [[DDSearchBar alloc] initWithFrame:CGRectMake(0, 100, self.view.dd_width, 44)] ;
    [self.view addSubview:searchBar] ;
//    searchBar.barTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6] ;
//    searchBar.backgroundColor = [UIColor clearColor] ;
    searchBar.cursorHorizontalOffset = 8 ;
    searchBar.searchBarLeftImage = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(20, 20)] ;
    searchBar.placeholderTextColor = [UIColor grayColor] ;
    searchBar.cursorColor = [UIColor cyanColor] ;
    
    UISearchBar * textField = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 200, self.view.dd_width, 44)] ;
    [self.view addSubview:textField] ;
}




#pragma mark - actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.view.backgroundColor = RandomColor ;
}

#pragma mark - private methods

@end
