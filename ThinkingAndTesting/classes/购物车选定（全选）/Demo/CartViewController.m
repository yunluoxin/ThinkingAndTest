//
//  CartViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/5.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CartViewController.h"
#import "DDNotifications.h"
#import "CartCell.h"
#import "DDCartGoodsNumberView.h"
@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isLoaded ;
}

/**
 *  根据购物车商品种类数量动态创建出的，同样个数的选中框标志的 数组
 */
@property (nonatomic, strong)NSMutableArray *flags ;

@property (nonatomic, weak)UITableView *tableView ;

/**
 *  "全选"按钮
 */
@property (nonatomic, weak)UIButton *selectedAllBtn ;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView ;
    [self.view addSubview:tableView];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    tableView.scrollIndicatorInsets =  tableView.contentInset ;
    tableView.allowsSelectionDuringEditing = NO ;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
    
    UIButton *wholeMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedAllBtn = wholeMarkBtn ;
    wholeMarkBtn.frame = CGRectMake(0, 0, tableView.dd_width, 50);
    [wholeMarkBtn setImage:[UIImage imageNamed:@"register_checkmark_selected"] forState:UIControlStateSelected];
    [wholeMarkBtn setImage:[UIImage imageNamed:@"register_checkmark"] forState:UIControlStateNormal];
    [wholeMarkBtn addTarget:self action:@selector(didWholeMarkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    tableView.tableHeaderView = wholeMarkBtn ;
    

    
    DDCartGoodsNumberView * numberBar = [[DDCartGoodsNumberView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)] ;
    tableView.tableHeaderView = numberBar ;
}


#pragma mark - UITableView DataSource方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.flags.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    typeof(self) __weak weakSelf = self ;
    NSNumber *flag = self.flags[indexPath.row] ;
    CartCell *cell = [CartCell cellWithTableView:tableView];
    cell.mark = flag.boolValue;
    cell.whenMarked = ^(BOOL mark){
        weakSelf.flags[indexPath.row] = @(mark);
        [weakSelf change];
    };
    return cell ;
}


#pragma mark - UITableView的Delegate方法

//确定编辑的样式！！！默认是删除！
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * indexPaths = tableView.indexPathsForSelectedRows ;
    DDLog(@"%@",indexPaths) ;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * indexPaths = tableView.indexPathsForSelectedRows ;
    DDLog(@"%@",indexPaths) ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



/**
 *  "全选"按钮被点击
 *
 */
- (void)didWholeMarkBtnClicked:(UIButton *)button
{
    self.tableView.editing = YES ;
    button.selected = !button.selected ;
    for (NSInteger i = 0 ; i < self.flags.count; i ++ ) {
        self.flags[i] = @(button.selected) ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/**
 *  更改了某行的选择后，判断是否全选了，从而改变"全选"按钮
 */
- (void)change
{
    if ([self checkIsAllMarked]) {
        self.selectedAllBtn.selected = YES ;
    }else{
        self.selectedAllBtn.selected = NO ;
    }
}
//检测是否当前是全选
- (BOOL)checkIsAllMarked
{
    for (NSInteger i = 0 ; i < self.flags.count; i ++) {
        NSNumber *f = self.flags[i] ;
        if (!f.boolValue) {
            return NO ;
        }
    }
    return YES ;
}

- (NSMutableArray *)flags
{
    if (!_flags) {
        _flags = [NSMutableArray array];
        for (int i = 0 ; i < 30; i++) {
            [_flags addObject:@(0)];
        }
    }
    return _flags ;
}



- (void)dealloc
{
    REMOVE_NOTIFICATION() ;
}


@end
