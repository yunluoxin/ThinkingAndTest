//
//  DataDriveUI_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DataDriveUI_ViewController.h"
#import "AuthDataBuilder.h"
#import "DDAuthCellConfig.h"
#import "DDAuthCell.h"
#import "ImagePickerDelegate.h"

@interface DataDriveUI_ViewController ()<UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView * tableView ;

/**
 *  <#note#>
 */
@property (nonatomic, strong)DriverAuthorizedForm * form ;
/**
 *  <#note#>
 */
@property (nonatomic, strong)NSArray * datas ;

@end

@implementation DataDriveUI_ViewController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super init]) {
        // init some datas
        self.form = [DriverAuthorizedForm new] ;
    }
    return self ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}


#pragma mark - view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"DataDriveUI_ViewController" ;
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    // 组建数据
    self.datas = [AuthDataBuilder buildDataFrom:self.form] ;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DDAuthCell" bundle:nil] forCellReuseIdentifier:@"DDAuthCell"] ;
    
    
    [self setupUI] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES] ;
    
    [self.tableView reloadData] ;
}

- (void)setupUI
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.dd_height - 44, self.view.dd_width, 44)] ;
    button.backgroundColor = [UIColor purpleColor] ;
    [button addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:button] ;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"" ;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"" ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBaseCellConfig * config = self.datas[indexPath.row] ;
    
    return config.cellHeight ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDBaseCellConfig * config = self.datas[indexPath.row] ;
    
    switch (config.cellType.intValue) {
        case 1:
        {
            DDAuthCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDAuthCell"] ;
            cell.config = config ;
            return cell ;
        }
    }
    
    return nil ;
}

#pragma mark - UITableViewDelegate Methods
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
    
}


#pragma mark - cell的delegate方法，内部传消息给vc的

- (void)cell:(DDAuthCell *)cell didTapAtIndex:(NSInteger)index extendEventFlag:(NSString *)flag
{
    __weak typeof(self) wself = self ;
    [ImagePickerDelegate showToastUsingDefaultStyleWithCompleteHandler:^(UIImage *originalImage, UIImage *editedImage, NSError *error) {
        NSArray * array = cell.config.stagingValue ;
        AuthCellImageItemConfig * config = array[index] ;
        config.selectedImage = originalImage ;
        config.imageUrl = @"http://wwfsadf" ;
        [wself.tableView reloadData] ;
    }] ;
}

#pragma mark - actions

- (void)complete:(id)sender
{
    NSString * tips = [AuthDataBuilder vaildDatas:self.datas] ;
    if (tips) {
        DDLog(@"%@",tips) ;
        return ;
    }
    
    [AuthDataBuilder composeForm:self.form withConfigs:self.datas] ;
    
    DDLog(@"%@",self.form) ;
}

#pragma mark - private methods



#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain] ;
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        _tableView.tableFooterView = [UIView new] ;
        [self.view addSubview:_tableView] ;
    }
    return _tableView ;
}

@end
