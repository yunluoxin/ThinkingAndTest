//
//  LeftSlideViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "LeftSlideViewController.h"
#import "LeftViewController.h"


@interface LeftSlideViewController ()<DrawerLeftViewControllerDelegate>
@property (nonatomic, strong)UIViewController *leftVC ;

@property (nonatomic, strong)UIViewController *mainVC ;

@property (nonatomic, weak) UIButton *coverButton ;
@end

@implementation LeftSlideViewController
- (instancetype)initWithLeftVC:(UIViewController *)leftVC andMainVC:(UIViewController *)mainVC
{
    if (self = [super init]) {
        
        [self setupLeftVC:leftVC];
        
        [self setupMainVC:mainVC];
    }
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:pan];
    
}

#pragma mark - 初始化左边的VC

- (void)setupLeftVC:(UIViewController *)leftVC
{
    _leftVC = leftVC ;
    [self addChildViewController:leftVC];
    [self.view addSubview:leftVC.view];
    
    leftVC.view.dd_left = - DrawerLeftViewWidth ;
    leftVC.view.dd_top = 20 ;//状态栏高度
    leftVC.view.dd_width = DrawerLeftViewWidth ;
    
    LeftViewController *vc = (LeftViewController *)leftVC ;
    vc.delegate = self ;
}

#pragma mark - 初始化主VC

- (void)setupMainVC:(UIViewController *)mainVC
{
    _mainVC = mainVC ;
    
    [self addChildViewController:mainVC];
    [self.view addSubview:mainVC.view];
    
}


#pragma mark - 手势动作的处理

- (void)panHandle:(UIPanGestureRecognizer *)pan
{
    UIView *mainView = _mainVC.view ;
    UIView *leftView = _leftVC.view ;
    if (pan.state == UIGestureRecognizerStateEnded) {   //拖拽结束,返回位置
        
        if (mainView.dd_left > DrawerLeftViewWidth/2) {
            
            //移动超过一半，出现左边的view
            [UIView animateWithDuration:DrawerDuration animations:^{
                leftView.dd_left = 0 ;
                mainView.dd_left = DrawerLeftViewWidth ;
            } completion:^(BOOL finished) {
                if (!_coverButton) {
                    UIButton *button = [[UIButton alloc]initWithFrame:mainView.frame];
                    //                button.backgroundColor = [UIColor purpleColor];
                    [self.view addSubview:button];
                    [button addTarget:self action:@selector(clickCover:) forControlEvents:UIControlEventTouchUpInside];
                    _coverButton = button ;
                }
            }];
            return ;
        }else{
            
            //没拉到一半，还原出现mainView
            [UIView animateWithDuration:DrawerDuration animations:^{
                leftView.dd_left = - DrawerLeftViewWidth ;
                mainView.dd_left = 0 ;
            } completion:^(BOOL finished) {
            }];
            return ;
        }
    }
    
    
    
    //拖拽开始

    CGFloat translationX = [pan translationInView:self.view].x ;    //求出拖拽的距离
    [pan setTranslation:CGPointZero inView:self.view];
    
    mainView.dd_left += translationX ;
    leftView.dd_left += translationX ;
    
    //限制范围，不让各自View超过自己的界限
    
    if (mainView.dd_left < 0) {
        mainView.dd_left = 0 ;
    }else if (mainView.dd_left > DrawerLeftViewWidth){
        mainView.dd_left = DrawerLeftViewWidth ;
    }
    
    if (leftView.dd_left > 0) {
        leftView.dd_left = 0 ;
    }else if (leftView.dd_left < - DrawerLeftViewWidth){
        leftView.dd_left = - DrawerLeftViewWidth ;
    }
    
    
}

- (void)clickCover:(UIButton *)sender
{
    //还原出现mainView
    [UIView animateWithDuration:DrawerDuration animations:^{
        _leftVC.view.dd_left = - DrawerLeftViewWidth ;
        _mainVC.view.dd_left = 0 ;
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
    }];
}

#pragma mark - 左边VC的代理，点击每一行分别执行的操作

- (void)drawerLeftViewController:(UIViewController *)vc didSelectRowAtIndex:(NSInteger)index
{
    
    UINavigationController *nav = (UINavigationController *)_mainVC ;
    if (nav.childViewControllers.count > 1) {
        [nav popToRootViewControllerAnimated:NO];
    }
    
    [self clickCover:_coverButton];
    
    //这里增加绑定点击每一行时候需要执行的操作！！！
}

@end
