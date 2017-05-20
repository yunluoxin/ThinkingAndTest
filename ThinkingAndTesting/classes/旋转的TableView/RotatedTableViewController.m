//
//  RotatedTableViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/5/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "RotatedTableViewController.h"
#import "RotatedTableViewCell.h"
#import "PageIndicatorView.h"
#import "PageIndicatorEllipseView.h"

@interface RotatedTableViewController ()<UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSMutableArray *data ;


@end

@implementation RotatedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO ;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, self.view.dd_width) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    self.tableView.pagingEnabled = YES ;
    self.tableView.backgroundColor = [UIColor purpleColor ];
    [self.tableView registerClass:RotatedTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RotatedTableViewCell.class)] ;
    self.tableView.transform = CGAffineTransformMakeRotation(- M_PI_2) ;
    self.tableView.frame = CGRectMake(0, 64, self.view.dd_width, 200) ;
    
    
    PageIndicatorView * view = [PageIndicatorView pageIndicatorView] ;
    view.dd_top = 100 ;
    [self.view addSubview:view] ;
    view.currentNum = 10 ;
    view.totalNum = 2 ;
    
    PageIndicatorEllipseView * ellipseView = [PageIndicatorEllipseView pageIndicatorEllipseView] ;
    ellipseView.dd_top = 200 ;
    [self.view addSubview:ellipseView] ;
    ellipseView.currentNum = 5 ;
    ellipseView.totalNum = 10 ;
}

#pragma mark - UITableView的DataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count ;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.dd_width ;
}


- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RotatedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RotatedTableViewCell.class) forIndexPath:indexPath] ;
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.data[indexPath.row]] ;
    UIImage * image = [UIImage imageNamed:@"ali"] ;
    cell.imageView.image = [[UIImage alloc] initWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationRight];
    return cell ;
}


#pragma mark - UITableView的delegate方法


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - lazy load
- (NSMutableArray *)data
{
    if (!_data) {
        NSMutableArray *arrayM = [NSMutableArray array];
        @autoreleasepool {
            for (NSUInteger i = 0 ; i < 500; i ++) {
                NSString * str = [NSString stringWithFormat:@"%ld - %d",i,arc4random_uniform(500)] ;
                [arrayM addObject:str] ;
            }
        }
        _data = arrayM ;
    }
    return _data ;
}
@end
