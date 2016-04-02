//
//  NoResultViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NoResultViewController.h"
#import "CacheDemoModel.h"
#import "DDNotifications.h"
#import "DDNoResultView.h"
#import "DemoSearchDisplayViewController.h"
@interface NoResultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isLoaded ;
}
@property (nonatomic, strong)NSMutableArray *data ;

@property (nonatomic, weak)UITableView *tableView ;

@property (nonatomic, strong)DDNoResultView *noResultView ;

@property (nonatomic, strong)CacheDemoModel *model  ;

@property (nonatomic, strong)UIView *bottomView ;
@end

@implementation NoResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"dd" style:UIBarButtonItemStyleDone target:self action:@selector(click)];
    
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DD_SCREEN_WIDTH, 300)];
    [self.view addSubview:_bottomView];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bottomView.dd_width, 44)];
    headView.backgroundColor = [UIColor greenColor];
    [_bottomView addSubview:headView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.dd_bottom, _bottomView.dd_width, _bottomView.dd_height - headView.dd_height) style:UITableViewStyleGrouped];
    _tableView = tableView ;
    [_bottomView addSubview:tableView];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    ADD_NOTIFICATION(DDGoodsDetailNotification);
    
    _model = [[CacheDemoModel alloc]init];
    
    [_model getSomethingById:nil];
    

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [headView addGestureRecognizer:pan];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isLoaded) {
        return 1 ;
    }
    return 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.data[indexPath.row]];
    return cell ;
}

- (NSMutableArray *)data
{
    if (!_data) {
        _data = [NSMutableArray array];
        for (int i = 0 ; i < 100; i++) {
            [_data addObject:@(i)];
        }
    }
    return _data ;
}

- (void)DDGoodsDetailNotification:(NSNotification *)note
{
    [self.noResultView removeFromSuperview] ;

    NetworkDataStatus status = ((NSNumber *)note.userInfo[@"NetworkDataStatus"]).intValue;
    switch (status) {
        case NetworkDataStatusHasNetworkHasData:
        {
            //正常状态，该干什么干什么。 记得判断status
        }
            
        case NetworkDataStatusNoNetworkHasData:
        {
            //没网络，但是读取到了本地的数据。该干嘛还是干嘛。不用提示 当前无网络，全局发出
            DDLog(@"%@",note.userInfo[@"data"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                _isLoaded = YES ;
                [self.tableView reloadData];
            });
            break;
        }
            
        case NetworkDataStatusHasNetworkNoData:
        {
            //出错了哦。不是说获取的列表数据数组为空。
            DDLog(@"出错了");
            [_bottomView insertSubview:_noResultView aboveSubview:self.tableView] ;
            self.noResultView.tips = [[NSString alloc]initWithFormat:@"出错啦！！！%@",note.userInfo[@"error"] ];
            break;
        }
            
        case NetworkDataStatusNoNetworkNoData:
        {
            //无网络也无数据。全局会发出 当前无网络。你可以做一些其他的处理。
            DDLog(@"无网络");
            [self.view insertSubview:_noResultView aboveSubview:self.tableView] ;
            self.noResultView.tips = @"无网络！！！";
            break;
        }
    }
    
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    UIView *view = pan.view ;
    CGPoint point = [pan translationInView:view];
    [pan setTranslation:CGPointZero inView:view];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        _bottomView.center = CGPointMake(self.bottomView.center.x, self.bottomView.center.y + point.y);
    }else if(pan.state == UIGestureRecognizerStateEnded){
        if (_bottomView.dd_top < 0 ||_bottomView.dd_top > self.view.dd_height) {
            [UIView animateWithDuration:0.5 animations:^{
                _bottomView.dd_top = self.view.dd_height/2 ;
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}
- (void)click
{
//    [self.model getSomethingById:nil];
    __weak typeof(self) weakSelf = self ;
    NoResultViewController *vc = [[NoResultViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}
- (DDNoResultView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[DDNoResultView alloc]initWithFrame:self.tableView.frame];
        
    }
    return _noResultView ;
}

- (void)dealloc
{
    REMOVE_NOTIFICATION() ;
    DDLog(@"%@",NSLocalizedString(@"您好", nil));
}
@end
