//
//  DDAuthenticationViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDAuthenticationViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "SSKeychain.h"

#import "CircleIndicatorsView.h"
#import "DDNotifications.h"

@interface DDAuthenticationViewController ()
@property (nonatomic, strong)CircleIndicatorsView *circleView ;
@property (nonatomic, weak)UIButton *fingerBtn ;
@property (nonatomic, copy)NSString *correctText ;
@end

@implementation DDAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    self.correctText = [self fetchPasswordFromKeychain];
    
    [self registerAllNotifications];
    
    [self selectFingerToUnlock];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat w = 100 ;   //指示器的宽度，可调
    CGFloat x = (DD_SCREEN_WIDTH - w ) / 2 ;
    _circleView = [[CircleIndicatorsView alloc]initWithFrame:CGRectMake(x, w, w, 20)];
    [self.view addSubview:_circleView];
    
    
    //创建一个看不见的textfield，用来弹出键盘
    UITextField *textField = [[UITextField alloc]init];
    textField.keyboardType = UIKeyboardTypeNumberPad ;
    [self.view addSubview:textField];
    
    [textField addTarget:self action:@selector(change:) forControlEvents:UIControlEventAllEditingEvents];
    [textField becomeFirstResponder];
    
    
    UIButton *fingerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fingerBtn setTitle:@"用指纹解锁" forState:UIControlStateNormal];
    [fingerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    fingerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fingerBtn addTarget:self action:@selector(selectFingerToUnlock) forControlEvents:UIControlEventTouchUpInside];
    _fingerBtn = fingerBtn ;
    [self.view addSubview:fingerBtn];
}

//注册所有的通知
- (void)registerAllNotifications
{
    ADD_NOTIFICATION(UIKeyboardWillShowNotification);
}

/**
 *  取出存储在钥匙串的密码
 */
- (NSString *)fetchPasswordFromKeychain
{
    NSString *account = @"dadong";  //根据用户名改变
    
    NSError *error ;
    NSString *password = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:account error:&error];
    if (error) {
        DDLog(@"出错了");
        return nil ;
    }else{
        return password ;
    }
}


#pragma mark - 输入改变的监听事件
- (void)change:(UITextField *)textField
{
    typeof(self) __weak weakSelf = self ;
    
    NSString *currentText = textField.text ;
    self.circleView.currentTintCount = currentText.length ;
    
    if (currentText.length == self.circleView.totalCount){
        if ([self.correctText isEqualToString:currentText]) {
            DDLog(@"解锁成功");
            [weakSelf unlockSuccess];
        }else{
            DDLog(@"解锁失败");
            textField.text = @"" ;//清空
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.circleView.currentTintCount = 0 ;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}




#pragma mark - 选择指纹解锁
- (void)selectFingerToUnlock
{
    typeof(self) __weak weakSelf = self ;
    
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
    
//    context.localizedFallbackTitle = @"手动输入密码" ;
    
    context.localizedFallbackTitle = @"" ;      //这样子就只有一个取消按键
    
    [context evaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请输入您的指纹验证验证" reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             [weakSelf unlockSuccess];
         } else {
             msg = [NSString stringWithFormat:@"失败--->%@", authenticationError.localizedDescription];
             DDLog(@"错误码%ld",authenticationError.code);
             DDLog(@"%@",msg);
         }
     }];
}

/**
 *  解锁成功
 */
- (void)unlockSuccess
{
    typeof(self) __weak weakSelf = self ;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.view endEditing:YES];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];//关闭页面
    });
}

#pragma mark - 键盘通知
- (void)UIKeyboardWillShowNotification:(NSNotification *)note
{
    //键盘弹出时候改变 "密码输入指示器"的高度
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat top = CGRectGetMinY(keyboardFrame);
    self.circleView.dd_top =  top - self.circleView.dd_height - 100 ;
    
    CGFloat x = self.circleView.dd_right + 20 ;
    CGFloat w = DD_SCREEN_WIDTH - x ;
    self.fingerBtn.frame = CGRectMake(x, self.circleView.dd_top, w, 20);
}
@end
