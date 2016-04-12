//
//  KeychainDemoViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "KeychainDemoViewController.h"
#import "SSKeychain.h"
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"


/**
 
 AllAccount 是得到所有的services下的所有帐户
 accountsForService 是得到一个services下的所有帐号（适用一个APP查看之前是否登录过其他的帐号）
 passwordForService: account: 是得到一个明确的，某个app中的某个账户的密码
 
 实验发现，不同service可以同样名字的account,不影响。
 
**/

@interface KeychainDemoViewController ()

@end

@implementation KeychainDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"存储" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(store:) forControlEvents:UIControlEventTouchUpInside];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(100);
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view);
    }];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"读取密码" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(read:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(100);
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(button.right).offset(8);
    }];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor purpleColor];
    [button3 setTitle:@"删除" forState:UIControlStateNormal];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    [button3 makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(100);
        make.top.equalTo(button.bottom).offset(8);
        make.left.equalTo(button.left);
    }];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.backgroundColor = [UIColor redColor];
    [button4 setTitle:@"读取所有账户" forState:UIControlStateNormal];
    [self.view addSubview:button4];
    [button4 addTarget:self action:@selector(readAllAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    [button4 makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(100);
        make.top.equalTo(button3);
        make.left.equalTo(button3.right).offset(8);
    }];
}

- (void)store:(id)sender
{
    NSError *error ;
    [SSKeychain setPassword:@"0520" forService:[NSBundle mainBundle].bundleIdentifier account:@"dadong" error:&error];
    if (error) {
        DDLog(@"出错了");
    }else{
        DDLog(@"成功");
    }
}

- (void)read:(id)sender
{
    NSError *error ;
    NSString *password = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:@"dadong" error:&error];
    if (error) {
        DDLog(@"出错了");
    }else{
        DDLog(@"成功%@",password);
    }
}
- (void)delete:(id)sender
{
    NSError *error ;
    BOOL result = [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:@"dadong" error:&error];
    if (result) {
        DDLog(@"删除成功");
    }else{
        DDLog(@"删除失败");
    }
}

- (void)readAllAccount:(id)sender
{
    NSError *error ;
    NSArray<NSDictionary *> *array = [SSKeychain allAccounts:&error];
    if (error) {
        DDLog(@"出错了");
    }else{
        
//        DDLog(@"成功%@",[array valueForKey:@"acct"]);
        DDLog(@"%@",array);
    }
}
@end
