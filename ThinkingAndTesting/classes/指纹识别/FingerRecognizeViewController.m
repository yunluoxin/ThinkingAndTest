
//
//  FingerRecognizeViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FingerRecognizeViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

/**
 两种策略的区别:
 
    1.   kLAPolicyDeviceOwnerAuthenticationWithBiometrics
    这种策略只能用系统的TounchID，输入一次错误之后，会出现让你输入密码的选项（默认，可以改掉），点输入密码的话，也算是当前touchID解锁失败，错误码-3,这时候，用户可以设置弹出自己做的输入自定义的APP密码来解锁APP。 解锁5次失败被锁。
 
    2.   kLAPolicyDeviceOwnerAuthentication
    这种策略可以使用系统的TouchID和系统密码。输入一次错误之后，也会出息输入密码的选项（不可自定义），点输入密码，弹出全屏的类似解锁屏幕时候那个界面，输入的时候整个手机的密码，不是app自定义的，对了之后，就返回成功，否则失败。 解锁6次失败被锁。
 
 错误码：
    -2   用户主动取消
    -8   验证码错误超过一定次数，重试太多次还是错误了
    -3   用户选择了输入密码的选项（仅对于1政策有这个，2政策没有）
 
 **/

@interface FingerRecognizeViewController ()

@end

@implementation FingerRecognizeViewController

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
}


- (void)store:(id)sender
{
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *msg;
    
    //先检测是否可以用touchID
    NSError *error ;
    BOOL result = [context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (result == NO) {
        DDLog(@"无法用指纹解锁，原因%@,错误码%ld",error.localizedDescription,error.code);
        return ;
    }
    
    
    //展示指纹输入的页面
    context.localizedFallbackTitle = @"手动输入密码" ;
    [context evaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请输入您的指纹验证验证" reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             msg =[NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_SUCCESS", nil)];
         } else {
             msg = [NSString stringWithFormat:@"失败--->%@", authenticationError.localizedDescription];
             DDLog(@"错误码%ld",authenticationError.code);
             
         }
         DDLog(@"%@",msg);
     }];
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
