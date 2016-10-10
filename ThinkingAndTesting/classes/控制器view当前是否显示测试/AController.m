//
//  AController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AController.h"
#import "BController.h"
#import "CViewController.h"
@interface AController ()

@end

@implementation AController

- (void)viewDidLoad {
    [super viewDidLoad];

    DDLog(@"%s,%@",__func__, self.view.window) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abc:) name:@"testViewDisplay" object:nil] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
//    [self.navigationController pushViewController:[BController new] animated:YES] ;
    [self.navigationController presentViewController:[CViewController new] animated:YES completion:nil] ;
}

- (void)abc:(NSNotification *)note
{
    DDLog(@"%@",note) ;
    DDLog(@"-----%@",self.view.window) ;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
    DDLog(@"%s,%@",__func__, self.view.window) ;
}
@end
