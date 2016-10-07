//
//  DemoConfigViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/31.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoConfigViewController.h"
#import "DDCartGoodsNumberView.h"
#import "DDNavigationBar.h"

@interface DemoConfigViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *scrollView ;

@property (nonatomic, weak)DDNavigationBar *bar ;
@end

@implementation DemoConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    DDLog(@"%@",dic) ;
    
    NSString *str = DDReadProperties(@"abc");
    DDLog(@"%@",str);
    
//    DDCartGoodsNumberView *numberView = [[DDCartGoodsNumberView alloc]initWithFrame:CGRectMake(0, 100, DD_SCREEN_WIDTH, 50)];
//    [self.view addSubview:numberView];
//    numberView.currentNumber = 10 ;
//    numberView.minNumber = 2 ;
//    numberView.maxNumber = 13 ;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//    [self.view addGestureRecognizer:tap];

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView = scrollView ;
    scrollView.delegate = self ;
    scrollView.contentSize = CGSizeMake(0, self.view.dd_height *2 );
    [self.view addSubview:scrollView];
    
    
    DDNavigationBar *bar = [[DDNavigationBar alloc]initWithFrame:CGRectMake(0, 0, DD_SCREEN_WIDTH, 64)];
    _bar = bar ;
    [self.view addSubview:bar];
    bar.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];
    UILabel *label = [UILabel new];
    label.text = @"测试的";
    label.frame = CGRectMake(0, 0, 51, 30);
    label.textColor = [UIColor greenColor];
    bar.navigationItem.titleView = label ;
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y ;
//    DDLog(@"contentOffset.y--->%f",y) ;
    if (y < 0) {
        self.bar.hidden = YES ;
        return ;
    }
    self.bar.hidden = NO ;
    if (y <= 200 && y >= 0) {
        
        self.bar.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:ABS(y / 200)] ;
        return ;
    }else {
        self.bar.backgroundColor = [UIColor orangeColor];
    }
}

- (void)back:(UIBarButtonItem *) item
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO ;
    [super viewWillDisappear:animated];
}

- (void)tap
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"test"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault ;
}
@end
