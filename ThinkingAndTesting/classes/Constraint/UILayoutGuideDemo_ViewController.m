//
//  UILayoutGuideDemo_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/25.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UILayoutGuideDemo_ViewController.h"

#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface UILayoutGuideDemo_ViewController ()
@end

@implementation UILayoutGuideDemo_ViewController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super init]) {
        // init some datas
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
    
    self.navigationItem.title = @"UILayoutGuide Demo" ;
    
    self.view.backgroundColor = [UIColor whiteColor] ;

    
    [self test1] ;
}


- (void)test1
{
    UIView * view1 = [UIView new] ;
    view1.backgroundColor = [UIColor yellowColor] ;
    [self.view addSubview:view1] ;
    
    UIView * view2 = [UIView new] ;
    view2.backgroundColor = [UIColor purpleColor] ;
    [self.view addSubview:view2] ;
    
    UILayoutGuide * guide = [UILayoutGuide new] ;
    [self.view addLayoutGuide:guide] ;
    
    ///
    /// fuck!!!!!!!!!!! 就因为忘记这个。。平时写Masonry习惯了。。。。。导致一直出错。怀疑是不是layoutGuide使用出问题了。
    ///
    view1.translatesAutoresizingMaskIntoConstraints = NO ;
    NSLayoutConstraint * constraint1 =  [view1.widthAnchor constraintEqualToConstant:100] ;
    NSLayoutConstraint * constraint2 =  [view1.heightAnchor constraintEqualToConstant:100] ;
    [NSLayoutConstraint activateConstraints:@[constraint1, constraint2]] ;
    
    view2.translatesAutoresizingMaskIntoConstraints = NO ;
    NSLayoutConstraint * constraint3 =  [view2.widthAnchor constraintEqualToAnchor:view1.widthAnchor] ;
    NSLayoutConstraint * constraint4 =  [view2.heightAnchor constraintEqualToAnchor:view1.heightAnchor] ;
    NSLayoutConstraint * constraint5 =  [view2.leadingAnchor constraintEqualToAnchor:view1.trailingAnchor] ;
    NSLayoutConstraint * constraint6 =  [view2.centerYAnchor constraintEqualToAnchor:view1.centerYAnchor] ;
    [NSLayoutConstraint activateConstraints:@[constraint3, constraint4,constraint5,constraint6]] ;
    
    [view1.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES ;
    [view2.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES ;
    [view1.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES ;
    [view1.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES ;
    
    [guide.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES ;
    [guide.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES ;
}

- (void)test2
{
    UIView * view1 = [UIView new] ;
    view1.backgroundColor = [UIColor yellowColor] ;
    [self.view addSubview:view1] ;
    
    UIView * view2 = [UIView new] ;
    view2.backgroundColor = [UIColor purpleColor] ;
    [self.view addSubview:view2] ;
    
    UILayoutGuide * guide = [UILayoutGuide new] ;
    [self.view addLayoutGuide:guide] ;
    
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100) ;
        make.height.equalTo(80) ;
        make.width.equalTo(100) ;
        make.height.width.equalTo(view2) ;
    }] ;
    
    [view2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.right) ;
        make.centerY.equalTo(view1) ;
    }] ;
    
    
    ///
    /// 用Masonry或者xib布局好。 需要加上横向约束以居中时候，用UILayoutGuide手动写代码, 最小化工作量
    ///
    
    
    NSLayoutConstraint * constraint1 = [view1.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor] ;
    NSLayoutConstraint * constraint2 = [view2.rightAnchor constraintEqualToAnchor:guide.rightAnchor] ;
    NSLayoutConstraint * constraint3 = [guide.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] ;
    //    NSLayoutConstraint * constraint4 = [guide.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:90] ;
    //    NSLayoutConstraint * constraint5 = [guide.topAnchor constraintEqualToAnchor:view1.topAnchor] ;
    
    // 激活方法。。。。。 或者每个contrain后面改 .active = YES ;
    [NSLayoutConstraint activateConstraints:@[
                                              constraint1,
                                              constraint2,
                                              constraint3,
                                              //                                              constraint4,
                                              //                                              constraint5
                                              ]] ;
}

@end
