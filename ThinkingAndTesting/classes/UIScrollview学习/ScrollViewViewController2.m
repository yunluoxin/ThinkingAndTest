//
//  ScrollViewViewController2.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ScrollViewViewController2.h"

#define RefreshViewHeight 64.0f

@interface ScrollViewViewController2 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * scrollView ;

@property (nonatomic, strong) UITableView * tableView ;
@property (nonatomic, strong)NSArray *data ;

@end

@implementation ScrollViewViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cyanColor] ;

    [self.navigationController setNavigationBarHidden:YES] ;
    
    
//    [self testScrollView] ;
    
    [self testTableView] ;

}


- (void)testScrollView
{
    [self.view addSubview:self.scrollView] ;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.dd_width, RefreshViewHeight)] ;
    label.text = @"下拉刷新->UIScrollView";
    label.textColor = [UIColor whiteColor] ;
    label.backgroundColor = [UIColor purpleColor] ;
    [self.scrollView addSubview:label] ;
}

- (void)testTableView
{
    CGFloat height = RefreshViewHeight ;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, - height , self.view.dd_width, height)] ;
    label.text = @"下拉刷新->UITableView";
    label.textColor = [UIColor whiteColor] ;
    label.backgroundColor = [UIColor purpleColor] ;
    [self.tableView addSubview:label] ;
    
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , self.view.dd_width, height)] ;
    label2.text = @"上拉加载更多->UITableView";
    label2.textColor = [UIColor whiteColor] ;
    label2.backgroundColor = [UIColor purpleColor] ;
    label2.tag = 2 ;
    [self.tableView addSubview:label2] ;
    
    [self.view addSubview:self.tableView];
    
    // 2.监听contentSize
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue] ;
        UIView * view = [self.tableView viewWithTag:2] ;
        view.frame = CGRectMake(0, contentSize.height , self.view.dd_width, RefreshViewHeight) ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    DDLog(@"%@",NSStringFromUIEdgeInsets(self.scrollView.contentInset) ) ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    DDLog(@"viewDidAppear:%@",NSStringFromUIEdgeInsets(self.tableView.contentInset) ) ;
}


- (NSArray *)data
{
    if (!_data) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0 ; i < 100;  i ++) {
            [arrayM addObject:@(i)];
        }
        _data = [arrayM copy];
    }
    return _data ;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
}



- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.dd_width, self.view.dd_height)] ;
        _scrollView.delegate = self ;
        _scrollView.backgroundColor = [UIColor whiteColor] ;
//        _scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) ;
        _scrollView.contentSize = CGSizeMake(self.view.dd_width, self.view.dd_height * 2 ) ;
        
    }
    return _scrollView ;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 100, 0) ;
    }
    return _tableView ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y ;
    
    if (!scrollView.isDragging) {
        if (offsetY < - scrollView.contentInset.top - RefreshViewHeight) {
            DDLog(@"开始刷新") ;
        }
    }else{
        if (offsetY < - scrollView.contentInset.top - RefreshViewHeight) {
            DDLog(@"放开就可以刷新" ) ;
        }else if(offsetY < -scrollView.contentInset.top){
            DDLog(@"下拉就可以刷新哦") ;
        }
    }
    
    CGFloat contentY = scrollView.contentSize.height - ( scrollView.frame.size.height - scrollView.contentInset.bottom) ;
    
    if (!scrollView.isDragging) {
        if (offsetY > contentY + RefreshViewHeight) {
            DDLog(@"加载更多中。。。") ;
        }
    }else{
        if (offsetY > contentY + RefreshViewHeight) {
            DDLog(@"放开就可以加载更多拉" ) ;
        }else if(offsetY > contentY ){
            DDLog(@"上拉就可以更多哦") ;
        }
    }
}
@end
