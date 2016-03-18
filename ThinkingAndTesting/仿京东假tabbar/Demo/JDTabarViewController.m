//
//  JDTabarViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "JDTabarViewController.h"
#import "TabBarView.h"


@interface JDTabarViewController ()
{
    BOOL _firstTimeBack ;//是否第一次返回
}

@property (nonatomic, weak)TabBarView *tabbarView ;
/**
 *  存储用户操作的栈数组（通过index记录）
 */
@property (nonatomic, strong)NSMutableArray *stacks ;
/**
 *  控制器名称数据（必须按顺序）
 */
@property (nonatomic, strong)NSArray *vcs ;
/**
 *  存储最后一次的VC
 */
@property (nonatomic, weak)UIViewController *lastVC ;
@end

@implementation JDTabarViewController
- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
    }
    return self ;
}


//初始化数据
- (void)initData
{
    //这里配置控制器VC
    self.vcs = @[@"JDFirstViewController",@"JDSecondViewController"];
    _firstTimeBack = YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回JD" style:UIBarButtonItemStyleDone target:self action:@selector(backBtnClicked)];
    
    [self initView];
    
    _tabbarView.currentIndex = 1 ;
}

//初始化view
- (void)initView
{
    //创建底部的tabbar
    TabBarView *tabbarView = [[TabBarView alloc]init];
    _tabbarView = tabbarView ;
    CGFloat w = tabbarView.dd_width ;
    CGFloat h = tabbarView.dd_height ;
    CGFloat x = 0  ;
    CGFloat y = DD_SCREEN_HEIGHT - h ;
    tabbarView.frame = CGRectMake(x, y, w, h ) ;
    tabbarView.whenBtnClicked = ^(NSInteger index){
        [self.stacks addObject:@(index)];
    };
    [self.view addSubview:tabbarView];
    
    //KVO
    [_tabbarView addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:nil];
}


//左键被点击
- (void)backBtnClicked
{
    [self.stacks removeLastObject];
    
    if (self.stacks.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSNumber *index = [self.stacks lastObject];
        _tabbarView.currentIndex = index.integerValue ;
        
        //只有第一次后退，并且有不止一个栈时候，才出现"close"按钮
        if (_firstTimeBack) {
            UIBarButtonItem *close = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeAll)];
            UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回JD" style:UIBarButtonItemStyleDone target:self action:@selector(backBtnClicked)];
            self.navigationItem.leftBarButtonItems = @[back,close];
            _firstTimeBack = NO ;
        }
    }

}

//直接关闭
- (void)closeAll
{
    [self.navigationController popViewControllerAnimated:YES];
}


//lazy load
- (NSMutableArray *)stacks
{
    if (!_stacks) {
        _stacks = [NSMutableArray array];
    }
    return _stacks ;
}

//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([@"currentIndex" isEqualToString:keyPath]) {
        NSNumber *index = change[@"new"];
        
        //移除旧的vc
        [_lastVC.view removeFromSuperview];
        [_lastVC removeFromParentViewController];
        
        //增加新的vc
        Class z = NSClassFromString(self.vcs[index.integerValue]);
        UIViewController *vc = [[z alloc]init];
        _lastVC = vc ;
        [self addChildViewController:vc];
        [self.view insertSubview:vc.view belowSubview:_tabbarView];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_lastVC.view removeFromSuperview];
    [_lastVC removeFromParentViewController];
    if (self.isViewLoaded && !self.view.window) {
        [_tabbarView removeObserver:self forKeyPath:@"currentIndex" context:nil];
        self.view = nil ;
    }
}

- (void)dealloc
{
    [_tabbarView removeObserver:self forKeyPath:@"currentIndex" context:nil];
    _stacks = nil ;
    _vcs = nil ;
}
@end
