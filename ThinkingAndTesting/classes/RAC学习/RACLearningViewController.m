//
//  RACLearningViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/3.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "RACLearningViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACLearningViewController ()

@property (nonatomic, strong) UIButton * loginButton ;

@property (nonatomic, strong) UITextField * nameTextField ;
@property (nonatomic, strong) UITextField * pwdTextField ;
@property (nonatomic, strong) UITextField * pwdConfirmedTextField ;
@end

@implementation RACLearningViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    RAC(self.loginButton, enabled) = [RACSignal combineLatest:(self.nameTextField, self.pwdTextField, self.pwdConfirmedTextField) reduce:^id _Nullable{
//        
//    }] ;
}

@end
