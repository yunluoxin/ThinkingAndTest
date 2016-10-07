//
//  AppCacheViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AppCacheViewController.h"
#import "PersonInfo.h"
#import "DDAppCache.h"
#import "DDNotifications.h"

#import "PersonInfoModel.h"

@interface AppCacheViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_filePath ;
}

@property (nonatomic, strong)NSArray *data ;


@property (nonatomic, weak)UITableView *tableView ;

@property (nonatomic, strong)PersonInfoModel *model ;
@end

@implementation AppCacheViewController
- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
    }
    return self  ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initData];
    }
    return self  ;
}

#pragma mark - 初始化数据

- (void)initData
{
    _model = [[PersonInfoModel alloc]init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];

    [self registerAllNotifications];
    
    [self loadData];
}

#pragma mark - 初始化View
- (void)initView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    _tableView = tableView ;
    tableView.delegate = self ;
    tableView.dataSource = self;
}

#pragma mark - 注册所有的通知

- (void)registerAllNotifications
{
    //网络恢复
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(network_come:) name:[DDNotifications NETWORK_COME] object:nil];
    
    //网络断开
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(network_broken:) name:[DDNotifications NETWORK_BROKEN] object:nil];
    
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(abc:) name:[DDNotifications ERROR_NOT_NETWORK] object:nil];
}


#pragma mark - 加载需要的数据

- (void)loadData
{
    _filePath = [DDAppCache filePathWithUserName:@"xiaodong" andFileName:@"personInfo1s"];
    NSArray *tempData = [DDAppCache objectWithFilePath:_filePath];
    if (tempData) {
        self.data = tempData ;
        [self.tableView reloadData];
    }
    
    //文件过期了才去加载的模式
//    if ([DDAppCache isFileExpired:_filePath]) {
        [self loadDataFromNetwork];
//    }
}



#pragma mark - 网络获取数据

- (void)loadDataFromNetwork
{
    
    [self.model loadData];
    
    [self performSelector:@selector(abe) withObject:nil afterDelay:10];
}
- (void)abe
{
    [[NSNotificationCenter defaultCenter]postNotificationName:[DDNotifications NETWORK_COME] object:nil];
}


#pragma mark - 网络恢复 后的操作
- (void)network_come:(NSNotification *)note
{
    [self.model loadData];
}

#pragma mark - 接收到网络断了的通知
- (void)network_broken:(NSNotification *)note
{

}

#pragma mark - 网络返回的结果

- (void)abc:(NSNotification *)note
{
    NSArray *data = note.userInfo[@"data"];
    self.data = data ;
    [self.tableView reloadData];
    
    //保存数据
    [DDAppCache saveObject:self.data toFilePath:_filePath];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"UITableViewCell"];
    }
    PersonInfo *info = self.data[indexPath.row];
    
    cell.textLabel.text = info.name ;
    cell.detailTextLabel.text = info.mobile ;
    return cell ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
