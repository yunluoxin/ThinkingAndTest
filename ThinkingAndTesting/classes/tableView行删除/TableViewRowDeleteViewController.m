//
//  TableViewRowDeleteViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TableViewRowDeleteViewController.h"
#import "UINavigationBar+CustomStyle.h"
#import "TableViewDeleteCell.h"

@interface TableViewRowDeleteViewController ()<UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *data ;
@property (nonatomic, strong) NSMutableArray *groups ;
@end

@implementation TableViewRowDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.extendedLayoutIncludesOpaqueBars = YES ;
    self.navigationItem.title = @"测试" ;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
//    self.tableView.showsVerticalScrollIndicator = NO ;
//    self.tableView.rowHeight = 60.0f ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    
    
//    self.navigationController.navigationBar.translucent = YES ;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor] backIndicatorImage:nil titleColor:[UIColor blackColor] rightItemColor:[UIColor purpleColor]];
}


#pragma mark - UITableView的DataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.groups.count ;
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DeleteModel * model = self.groups[section] ;
    return  model.name ;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLog(@"heightForRowAtIndexPath---%@",indexPath);
    DeleteModel * model = self.data[indexPath.row] ;
    return model.cellHeight ;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 8.0f ;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8.0f ;
//}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLog(@"cellForRowAtIndexPath---%@",indexPath);
    __weak typeof(self) wself = self ;
    TableViewDeleteCell *cell = [TableViewDeleteCell cellWithTableView:tableView];
    DeleteModel * model = self.data[indexPath.row] ;
    cell.model = model ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.whenDeleteBtnClicked = ^(DeleteModel * m){
        NSUInteger i = [wself.data indexOfObject:m];
//        DDLog(@"%d",i) ;
//        NSInteger index = indexPath.row ;   //其他的cell被删除后，tableView的indexPath会重新排,但是不会重新通过cellForRowAtIndexPath获取cell,也就是这个block不会重新赋值，block保存的是之前的，这样删除的就不是刚刚要删除的cell了
        [wself tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
//        [wself tableView:tableView didSelectRowAtIndexPath:indexPath] ;
        return ;
    };
    return cell ;
}


#pragma mark - UITableView的delegate方法

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        /**
         *  必须先删除数据！！！！再删除图像！！！！！！！！！ 估计删除数据后而不重排图像，数据和图像就不对应了 。
         */
        DDLog(@"删除确认%@",indexPath);
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates] ;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates] ;
//        [self.tableView reloadData] ;
        
        
        /**
         *  下面这样作也不行！！！！
         */
        /*
        NSObject *obj = self.data[indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.data removeObject:obj];
         */
        
        
        
        /**----组删除测试--------*/
        
//        DDLog(@"删除第%ld组",indexPath.section + 1) ;
//        [self.groups removeObjectAtIndex:indexPath.section];
//        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic] ;
        
        /** ===组删除测试成功=== */
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"我要删除" ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeleteModel * model = self.data[indexPath.row] ;
    int t = arc4random() % 200 ;
    int t2 = arc4random() % 200 ;
    model.cellHeight = 44 + t - t2;
    DDLog(@"%d,%d,%f",t,t2,model.cellHeight) ;
    if (model.cellHeight < 0) {
        model.cellHeight = - model.cellHeight ;
    }
    [tableView beginUpdates] ;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
    [tableView endUpdates] ;
}


- (void)refresh
{
    [self.tableView reloadData];
}

#pragma mark - lazy load
- (NSMutableArray *)data
{
    if (!_data) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0 ; i < 500; i ++) {
            DeleteModel * model = [DeleteModel new] ;
            model.name = [NSString stringWithFormat:@"第%d行",i + 1] ;
            model.cellHeight = 200 ;
            if (i == 3) {
                /// 第4个
                model.cellHeight = 0 ; 
            }
            [arrayM addObject:model] ;
            
        }
        _data = arrayM ;
    }
    return _data ;
}

- (NSMutableArray *)groups
{
    if (!_groups) {
        NSMutableArray *arrayMSection = [NSMutableArray array ] ;
        for (int i = 0 ; i < 10 ; i ++) {
            DeleteModel * model = [DeleteModel new] ;
            model.name = [NSString stringWithFormat:@"第%d组",i + 1] ;
            [arrayMSection addObject:model] ;
        }
        _groups = arrayMSection ;
    }
    return _groups ;
}


- (void)savedDisclosures:(UITableViewCell *)cell
{
    for (UIView * view in cell.subviews) {
        if (CGRectEqualToRect(view.bounds, CGRectMake(0, 0, 8, 13))) {
            DDLog(@"%@",view) ;
            UIButton * btn = (UIButton *)view ;
            UIImage * image = [btn backgroundImageForState:UIControlStateNormal] ;
            NSData * data =  UIImagePNGRepresentation(image );
            [data writeToFile:@"/Users/dadong/Desktop/discloure_indicator@3x.png" atomically:YES] ;
        }
    }
}
@end
