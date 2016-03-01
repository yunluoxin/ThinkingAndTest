//
//  DemoSingletonViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSingletonViewController.h"
#import "SingletonObject.h"
#import "SingletonObject2.h"
@interface DemoSingletonViewController ()

@end

@implementation DemoSingletonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    SingletonObject *obj2 = [SingletonObject sharedObject];
    DDLog(@"shared创建%@",obj2);
    
    
    SingletonObject *obj3 = [SingletonObject sharedObject];
    DDLog(@"shared创建第二次%@",obj3);
    
    
    SingletonObject *obj = [[SingletonObject alloc]init];
    DDLog(@"init创建%@",obj);
    
    SingletonObject *obj4 = [[SingletonObject alloc]initWithAge:13];
    DDLog(@"initWithAge%@",obj4);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self  action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100,300, 30, 30);
    [self.view addSubview:button];
    
    
    SingletonObject2 *obj5 = [SingletonObject2 sharedInstance];
    DDLog(@"SingletonObject2创建%@",obj5);
    
    
    SingletonObject2 *obj6 = [SingletonObject2 sharedInstance];
    DDLog(@"SingletonObject2创建第二次%@\n\n",obj6);
    
    
    SingletonObject2 *obj7 = [[SingletonObject2 alloc]init];
    DDLog(@"SingletonObject2 init创建%@",obj7);
    
    SingletonObject2 *obj8 = [[SingletonObject2 alloc]init];
    DDLog(@"SingletonObject2 initWithAge%@",obj8);
}

- (void)tap:(UIButton *)sender
{
    SingletonObject *obj3 = [SingletonObject sharedObject];
    DDLog(@"shared创建第3次%@",obj3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
