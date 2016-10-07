//
//  FakeQQViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FakeQQViewController.h"
#import "LeftViewController.h"
#import "SecondLevelTabBarController.h"

#define DrawerLeftViewWidth (DD_SCREEN_WIDTH * 0.7)

@interface FakeQQViewController ()
@property (nonatomic, strong)UIViewController *leftVC ;

@property (nonatomic, strong)UIViewController *mainVC ;

@property (nonatomic, weak) UIButton *coverButton ;
@end

@implementation FakeQQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    [self addChildViewController:leftVC];
    [self.view addSubview:leftVC.view];
    _leftVC = leftVC ;
    leftVC.view.dd_left = - DD_SCREEN_WIDTH * 0.7 ;
    leftVC.view.dd_top = 20 ;
    leftVC.view.dd_width = DD_SCREEN_WIDTH * 0.7 ;
    
    
    SecondLevelTabBarController *tabbarVC = [SecondLevelTabBarController new];
    _mainVC = tabbarVC ;
    [self addChildViewController:tabbarVC];
    [self.view addSubview:tabbarVC.view];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 手势动作的处理

- (void)panHandle:(UIPanGestureRecognizer *)pan
{
    UIView *mainView = _mainVC.view ;
    UIView *leftView = _leftVC.view ;
    if (pan.state == UIGestureRecognizerStateEnded) {   //拖拽结束,返回位置
        
        if (mainView.dd_left > DrawerLeftViewWidth/2) {
            
            //移动超过一半，出现左边的view
            [UIView animateWithDuration:1 animations:^{
                leftView.dd_left = 0 ;
                mainView.dd_left = DrawerLeftViewWidth ;
            } completion:^(BOOL finished) {
                if (!_coverButton) {
                    UIButton *button = [[UIButton alloc]initWithFrame:mainView.frame];
                                    button.backgroundColor = [UIColor purpleColor];
                    [self.view addSubview:button];
                    [button addTarget:self action:@selector(clickCover:) forControlEvents:UIControlEventTouchUpInside];
                    _coverButton = button ;
                }
            }];
            return ;
        }else{
            
            //没拉到一半，还原出现mainView
            [UIView animateWithDuration:1 animations:^{
                leftView.dd_left = - DrawerLeftViewWidth ;
                mainView.dd_left = 0 ;
            } completion:^(BOOL finished) {
                if (_coverButton) {
                    [_coverButton removeFromSuperview];
                }
            }];
            return ;
        }
    }
    
    
    
    //拖拽开始
    
    CGFloat translationX = [pan translationInView:self.view].x ;    //求出拖拽的距离
    [pan setTranslation:CGPointZero inView:self.view];  //必须重置
    
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
    [UIView animateWithDuration:1 animations:^{
        _leftVC.view.dd_left = - DrawerLeftViewWidth ;
        _mainVC.view.dd_left = 0 ;
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
    }];
}

@end
