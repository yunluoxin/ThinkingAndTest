//
//  RACLearningViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/3.
//  Copyright © 2017年 dadong. All rights reserved.
//


/// 一个问题，按下登录时候，把登录按钮给禁止了，但是随便点一个文本框，又重新变激活了（因为重新填写验证了），怎么让textField只在有变化时候验证。如果只是禁止登录可以用hud盖在上面 ???


#import "RACLearningViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import <JDStatusBarNotification/JDStatusBarNotification.h>

@interface RACLearningViewController ()

@property (nonatomic, strong) UIButton * loginButton ;

@property (nonatomic, strong) UITextField * nameTextField ;
@property (nonatomic, strong) UITextField * pwdTextField ;
@property (nonatomic, strong) UITextField * pwdConfirmedTextField ;

@end

@implementation RACLearningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDLog(@"%f",self.view.window.windowLevel) ;
    
    self.navigationItem.title = @"RAC学习" ;
    
    self.nameTextField = [self textFieldWithFrame:CGRectMake(50, 100, 200, 50)] ;
    
    self.pwdTextField = [self textFieldWithFrame:CGRectMake( self.nameTextField.dd_left, self.nameTextField.dd_bottom + 10, self.nameTextField.dd_width, self.nameTextField.dd_height)] ;
    
    self.pwdConfirmedTextField = [self textFieldWithFrame:CGRectMake( self.nameTextField.dd_left, self.pwdTextField.dd_bottom + 10, self.nameTextField.dd_width, self.nameTextField.dd_height)] ;
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [self.view addSubview:self.loginButton] ;
    self.loginButton.frame = CGRectMake( self.nameTextField.dd_left, self.pwdConfirmedTextField.dd_bottom + 20, self.nameTextField.dd_width, self.nameTextField.dd_height) ;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal] ;
    [self.loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal] ;
    [self.loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled] ;
    self.loginButton.enabled = NO ;
    
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.nameTextField.rac_textSignal, self.pwdTextField.rac_textSignal, self.pwdConfirmedTextField.rac_textSignal] reduce:^id _Nullable(NSString *name, NSString * pwd, NSString * pwdConfirm){
        return @(name.length > 5 && pwd.length > 6 && [pwdConfirm isEqualToString:pwd]) ;
    }] ;
    
    
    
//    [self.nameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        DDLog(@"%@",x)
//    }] ;
    
    
    //过滤器
    [[self.nameTextField.rac_textSignal
       filter:^BOOL(NSString * _Nullable value) {
///           NSLog(@"origin=>%@, newer:=>%@",self.nameTextField.text, value) ;//不行，不是原来的
        return value.length > 3 ;
    }] subscribeNext:^(NSString * _Nullable x) {
        DDLog(@"%@",x );
    }] ;
    
//    return ;
    //改变数据
//    [[[self.nameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        //模拟去除空格
//        NSString * newStr = [value stringByReplacingOccurrencesOfString:@" " withString:@""] ;
//        if (value && ![value isEqualToString:newStr]) {
//            self.nameTextField.text = newStr ;
//        }
//        DDLog(@"new:%@",newStr) ;
//        return newStr;
//    }] filter:^BOOL(NSString * _Nullable value) {
//        return value.length > 3 ;
//    }] subscribeNext:^(NSString * _Nullable x) {
//        DDLog(@"%@",x );
//    }] ;
    
//    [[self.nameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return @(value.length) ;
//    }] subscribeNext:^(id  _Nullable x) {
//        DDLog(@"文字长度变化%@",x) ;
//    }] ;
    
    @weakify(self);
    [[self.nameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 5);
    }] subscribeNext:^(NSNumber * vaildName) {
        @strongify(self) ;
        if (vaildName.boolValue) {
            self.nameTextField.layer.borderColor = [UIColor redColor].CGColor ;
        }else{
            self.nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor ;
        }
    }] ;
    
    [[[[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
        doNext:^(__kindof UIControl * _Nullable x) {
        x.enabled = NO ;
    }] map:^id _Nullable(id  _Nullable value) {
        @strongify(self) ;
        return [self signInSignal] ;
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value ;
    }] subscribeNext:^(id x) {
                         @strongify(self) ;
                         NSLog(@"button clicked=>%@",x);
                     }];
    
    
    
    /// put code here, to see if vc can be pushed.
    /// Assumed it can't be pushed, because the self.navigation is nil .
    RACLearningViewController * vc = [RACLearningViewController new] ;
    [self dd_navigateTo:vc] ;
    
    
    
    DDLog(@"%@",self.block) ; // <__NSGlobalBlock__: 0x10882a660>
}

- (RACSignal *)signInSignal
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self) ;
        [self loginWithName:self.nameTextField.text password:self.pwdTextField.text complete:^(id response, NSError *error) {
            [subscriber sendNext:response] ;
            [subscriber sendCompleted] ;
        }] ;
        
        //使用后的处理，清理资源，没有要清理的，返回nil
        return nil ;
    }] ;
}

- (void)loginWithName:(NSString *)name password:(NSString *)pwd complete:(void (^)(id response, NSError * error))block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([name isEqualToString:@"1234567"] && [pwd isEqualToString:@"1234567"]) {
            if (block) {
                block(@(YES),nil) ;
            }
        }
    });
}

- (UITextField *)textFieldWithFrame:(CGRect)frame
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame] ;
    textField.backgroundColor = [UIColor clearColor] ;
    textField.font = [UIFont boldSystemFontOfSize:17] ;
    textField.textColor = [UIColor greenColor] ;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor ;
    textField.layer.borderWidth = 1 / IOS_SCALE ;
    textField.layer.cornerRadius = 3 ;
    textField.text = @"1234567" ;
    [self.view addSubview:textField] ;
    return textField ;
}


#pragma mark - Actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [JDStatusBarNotification showWithStatus:@"成功添加！！！" dismissAfter:2.0f] ;
//    [JDStatusBarNotification showWithStatus:@"哈哈" styleName:JDStatusBarStyleSuccess] ;
//    [JDStatusBarNotification showWithStatus:@"成功拉！！！" dismissAfter:2 styleName:JDStatusBarStyleMatrix] ;
    
    [JDStatusBarNotification showWithStatus:@"哈哈" styleName:JDStatusBarStyleSuccess] ;
    
    
    // 后面两个必须在前面的JDStatusBarView创建之后，才可以使用。也就是必须在后面调用
    
    [JDStatusBarNotification showProgress:0.8] ;
    
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray] ;
    
    
    // set backgroud image for current vc , occupies too high memory abount 2.+MB, not suggest to use.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ali"]] ;
    
    
    
    /// Block Test
    
    __block int a = 3 ;
    void (^block)(void) = ^(void){
        a = 6 ;
        DDLog(@"%s",__func__) ;
    } ;
    
    block();
    
    DDLog(@"%@",block) ;        //<__NSMallocBlock__: 0x7feb20e5e270>
    
    void (^block2)(void) = [block copy] ;
    DDLog(@"%@",block2) ;       //<__NSMallocBlock__: 0x7feb20e5e270>
    
    self.block = block ;
    DDLog(@"%@",self.block) ;   //<__NSMallocBlock__: 0x7feb20e5e270>
    
    
    /// ============================================================================///
    
    void (^block3)(void) = ^(void){
        DDLog(@"%s",__func__) ;
    } ;
    
    block3() ;
    DDLog(@"%@",block3) ;       // <__NSGlobalBlock__: 0x10a0e2cc0>
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DDLog(@"%@",self.block) ;
}

- (void)dealloc
{
    
}

@end
