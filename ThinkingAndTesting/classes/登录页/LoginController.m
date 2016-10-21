//
//  LoginController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "LoginController.h"

#import "UIViewController+DDKeyboardManager.h"

#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface LoginController ()
{
    NSTimer *_timer  ;
}
@property (nonatomic, weak) UIButton *sendCodeBtn ;

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    self.extendedLayoutIncludesOpaqueBars = YES ;
    self.view.backgroundColor = [UIColor yellowColor] ;
    self.shouldAutoHandleKeyboard = YES ;
    
    UIView *whiteView = [UIView new] ;
    whiteView.backgroundColor = [UIColor whiteColor] ;
    whiteView.layer.cornerRadius = 5 ;
    [self.view addSubview:whiteView] ;
    
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64) ;
        make.centerX.equalTo(self.view) ;
        make.left.equalTo(self.view).offset(15) ;
    }];
    
    
    NSArray *images = @[
                        @"arrow",
                        @"back",
                        @"arrow",
                        @"back"
                        ] ;
    NSArray *placeholders = @[
                              @"请输入用户名" ,
                              @"请输入密码",
                              @"请输入手机号" ,
                              @"请输入验证码"
                              ] ;
    __weak UIView *lastView = whiteView ;
    for (int i = 0 ; i < images.count ; i ++) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[i]]] ;
        [whiteView addSubview:iv] ;
        
        UITextField *textField = [UITextField new] ;
        textField.placeholder = placeholders[i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing ;
        textField.returnKeyType = UIReturnKeyDone ;
        textField.tag = i + 1 ; //标识哪个view
        [whiteView addSubview:textField] ;
        
        UIView * line = nil ;
        if (i != images.count - 1) {
            line = [UIView new] ;
            line.backgroundColor = [UIColor lightGrayColor] ;
            line.alpha = 0.4 ;
            [whiteView addSubview:line] ;
            
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(whiteView).offset(15) ;
                make.top.equalTo(lastView).offset(50) ;
                make.right.equalTo(whiteView) ;
                make.height.equalTo(0.5) ;
            }] ;

        }
        
        UIButton *btn = nil ;
        if (i == 2) {
            btn = [UIButton new] ;
            [btn setTitle:@"发送验证码" forState:UIControlStateNormal] ;
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal] ;
            [btn addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside] ;
            btn.layer.borderWidth = 1/IOS_SCALE ;
            btn.layer.borderColor = [UIColor orangeColor].CGColor ;
            btn.tag = images.count + 1 ;
            [whiteView addSubview:btn] ;
            self.sendCodeBtn = btn ;
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(whiteView).offset(-8) ;
                make.centerY.equalTo(textField) ;
                make.width.equalTo(120).priorityLow() ;     //!!!!!!!!!!!!!
            }];
        }
        
        //布局
        [iv makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView).offset(15) ;
            make.top.equalTo(lastView).offset(8) ;
            make.width.height.equalTo(30) ;
        }] ;
        
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iv) ;
            make.left.equalTo(iv.right).offset(10);
            if (i == 2) {
                make.right.equalTo(btn.left).offset(-8) ;
            }else{
                make.right.equalTo(whiteView) ;
            }
            if (i == images.count - 1) {
                make.bottom.equalTo(whiteView).offset(-8) ;
            }
            
            
        }];
        
        lastView = line ;
    }
}

- (void)sendCode:(UIButton *)sender
{
    sender.enabled = NO ;
    
    //下面的定时器会1秒后执行，为了不造成卡顿的效果，最好自己先执行一次
    [self.sendCodeBtn setTitle:@"60秒后可再次发送" forState:UIControlStateNormal] ;
    
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeout) userInfo:nil repeats:YES] ;
    }

    left = 59 ;
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes] ;
}

static int left = 0 ;
- (void)timeout
{
    if (left == 0) {
        [_timer invalidate] ;
        _timer = nil ;
        self.sendCodeBtn.enabled = YES ;
        [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal] ;
    }else{
         [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后可再次发送",left] forState:UIControlStateNormal] ;
        left -- ;
    }


}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}
@end
