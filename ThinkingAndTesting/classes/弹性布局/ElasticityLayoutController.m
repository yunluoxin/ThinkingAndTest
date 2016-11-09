//
//  ElasticityLayoutController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ElasticityLayoutController.h"
#import "ElasticityLayoutView.h"

#define weakSelf __weak typeof(*&self) wself = self

@interface ElasticityLayoutController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray * datas ;


@property (nonatomic, strong) UITableView * tableView ;

@end

@implementation ElasticityLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
//    
//    ElasticityLayoutView * layoutView = [[ElasticityLayoutView alloc] initWithFrame:CGRectMake(0, 0, self.view.dd_width, 85) ];
//    layoutView.datas = self.datas ;
//    [self.view addSubview:layoutView] ;
//    
//    weakSelf ;
//    layoutView.whenClick = ^(ElasticityEntity * entity){
//        SEL selector = NSSelectorFromString(entity.selector);
//        [wself performSelector:selector withObject:nil] ;
//    } ;
    
    
    [self.view addSubview:self.tableView] ;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)] ;
    view.backgroundColor = [UIColor whiteColor] ;
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 2, tableView.dd_width, 1 / IOS_SCALE)] ;
//    line.backgroundColor =  [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1] ;
    line.backgroundColor = HexColor(0xc8c6ca);
    DDLog(@"sRGB%@",line.backgroundColor) ;
    
    line.backgroundColor = HexColor(0xc1c0c5);
    DDLog(@"native%@",line.backgroundColor) ;
    
    line.backgroundColor = HexColor(0xbcbbc0);
    DDLog(@"RGB%@",line.backgroundColor) ;
    
    line.backgroundColor = HexColor(0xc7c6ca);
    DDLog(@"adobeRGB%@",line.backgroundColor) ;
    
    [view addSubview:line] ;
    return view ;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"ddd" ;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID] ;
        cell.textLabel.font = [UIFont systemFontOfSize:18] ;
        cell.backgroundColor = [UIColor yellowColor] ;
    }
    cell.textLabel.text =  [NSString stringWithFormat:@"%ld--%ld",indexPath.section, indexPath.row] ;
    
    return cell ;
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell printSubviews] ;
        for (UIView * view in cell.subviews) {
            if ([view.description hasPrefix:@"<_UITableViewCellSeparatorView"]) {
                DDLog(@"backgroudnColor%@",view.backgroundColor) ;
//                UIImage * iamge = [UIImage imageWithColor:view.backgroundColor size:CGSizeMake(100, 100)] ;
//                NSData *data = UIImagePNGRepresentation(iamge );
//                [data writeToFile:@"/Users/dadong/Desktop/seperatorViewBackground.png" atomically:YES] ;
                size_t size = CGColorGetNumberOfComponents(view.backgroundColor.CGColor) ;
                const CGFloat * color = CGColorGetComponents(view.backgroundColor.CGColor) ;
                DDLog(@"%f--%f--%f",color[0],color[1], color[2] ) ;
                
            }
        }
    }
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        CGFloat sectionHeaderHeight = 44 ; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
}




- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] ;
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        _tableView.rowHeight = 100 ;
        _tableView.backgroundColor = [UIColor greenColor] ;
        
    }
    return _tableView ;
}

- (void)home_exchange_goods
{
    DDLog(@"%s",__func__) ;
}

- (void)home_await_pay
{
    DDLog(@"%s",__func__) ;
}

- (void)home_await_install
{
    DDLog(@"%s",__func__) ;
}

- (void)home_await_pick
{
    DDLog(@"%s",__func__) ;
}

- (void)home_await_comment
{
    DDLog(@"%s",__func__) ;
}

- (NSArray *)datas
{
    if (!_datas) {
        NSArray * array = @[
                            @{@"title":@"代付款",@"imageName":@"home_await_pay",@"selector":NSStringFromSelector(@selector(home_await_pay))},
                            @{@"title":@"待收货维修",@"imageName":@"home_await_install",@"selector":NSStringFromSelector(@selector(home_await_install))},
                            @{@"title":@"待收货",@"imageName":@"home_await_pick",@"selector":NSStringFromSelector(@selector(home_await_pick))},
                            @{@"title":@"待评价",@"imageName":@"home_await_comment",@"selector":NSStringFromSelector(@selector(home_await_comment))},
                            @{@"title":@"退换货",@"imageName":@"home_exchange_goods",@"selector":NSStringFromSelector(@selector(home_exchange_goods))}
                            ] ;
        NSMutableArray * arrayM = @[].mutableCopy ;
        for (int i = 0 ; i < array.count ; i ++ ) {
            ElasticityEntity * entity = [[ElasticityEntity alloc] initWithDic:array[i] ];
            [arrayM addObject:entity] ;
        }
        _datas = [arrayM copy] ;
    }
    return _datas ;
}
@end
