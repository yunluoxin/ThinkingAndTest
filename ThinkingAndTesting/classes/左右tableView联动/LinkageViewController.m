//
//  LinkageViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "LinkageViewController.h"

@interface LinkageViewController ()<UITableViewDelegate, UITableViewDataSource >
{
    BOOL _scrollDown ; //是否向下滚动
}


@property (nonatomic, strong) UITableView * leftTableView ;
@property (nonatomic, strong) UITableView * rightTableView ;


@end

@implementation LinkageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.leftTableView] ;
    
    [self.view addSubview:self.rightTableView] ;
}

#pragma mark - UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.leftTableView == tableView) {
        return 1 ;
    }else{
        return 100 ;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.leftTableView == tableView) {
        return 100 ;
    }else{
        return 20 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.leftTableView == tableView) {
        return 0.1 ;
    }
    return 44.0f ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"sadfasd" ;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID] ;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] ;
        cell.textLabel.textColor = [UIColor blackColor] ;
        cell.textLabel.font = [UIFont systemFontOfSize:15] ;
    }
    
    if (self.leftTableView == tableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"左边--%ld",indexPath.row ];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"右边-%ld--%ld",indexPath.section, indexPath.row] ;
    }
    
    return cell ;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.rightTableView == tableView) {
        return [NSString stringWithFormat:@"Group-%ld",section] ;
    }
    return nil ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leftTableView == tableView) {
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]  atScrollPosition:UITableViewScrollPositionTop animated:YES] ;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (self.rightTableView == tableView && !_scrollDown && tableView.dragging) {
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]  animated:YES scrollPosition:UITableViewScrollPositionMiddle] ;
    }
}


- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (self.rightTableView == tableView && _scrollDown && tableView.dragging) {
        
        if (section >= 1 ) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section-1 inSection:0]  animated:YES scrollPosition:UITableViewScrollPositionMiddle] ;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0 ;
    
    CGFloat currentOffsetY = scrollView.contentOffset.y ;
    
    if (lastOffsetY < currentOffsetY) {
        _scrollDown = NO ;
    }else{
        _scrollDown = YES ;
    }
    
    lastOffsetY = currentOffsetY ;
}


#pragma mark - getter and setter

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        CGRect rect = CGRectMake(0, 0, 100, self.view.bounds.size.height) ;
        _leftTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain] ;
        _leftTableView.backgroundColor = [UIColor magentaColor] ;
        _leftTableView.delegate = self ;
        _leftTableView.dataSource = self ;
        _leftTableView.tableFooterView = [UIView new] ;
    }
    return _leftTableView ;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        CGFloat x = self.leftTableView.bounds.origin.x + self.leftTableView.bounds.size.width ;
        CGFloat y = 0 ;
        CGFloat w = self.view.bounds.size.width - x ;
        CGFloat h = self.view.bounds.size.height ;
        CGRect rect = CGRectMake(x, y , w , h ) ;
        _rightTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] ;
        //        _rightTableView.backgroundColor = [UIColor cyanColor] ;
        _rightTableView.delegate = self ;
        _rightTableView.dataSource = self ;
        _rightTableView.tableFooterView = [UIView new] ;
    }
    return _rightTableView ;
}

@end

