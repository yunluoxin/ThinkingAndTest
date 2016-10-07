//
//  URLCacheViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "URLCacheViewController.h"
#import "AFNetworking.h"
#import "DDAppCache.h"

//#define SCREEN_WIDTH  ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait? ([UIScreen mainScreen].bounds.size.width):([UIScreen mainScreen].bounds.size.height))

@interface URLCacheViewController ()

@end

@implementation URLCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:185.0/255.0 green:220.0/255.0 blue:47.0/255.0 alpha:1.0] ;
    button.frame = CGRectMake(100, 100, 100, 30);
    [button addTarget:self action:@selector(loadNetWork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] ;
    button2.frame = CGRectMake(100, 200, 100, 30);
    [self.view addSubview:button2];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNetWork
{
    NSString *str = @"http://localhost:8182/mobile/home/category;jsessionId=?token=null&dafd=323" ;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedInstance ];
//    [manager POST:str parameters:@{@"key":@"value"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            DDLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
//    [manager GET:str parameters:@{@"key":@"value"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

    DDLog(@"%f",DD_SCREEN_WIDTH);
}
@end
