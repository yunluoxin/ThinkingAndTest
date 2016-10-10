//
//  CViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CViewController.h"

@interface CViewController ()<UITextFieldDelegate>

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 44)] ;
    [self.view addSubview:textField] ;
    textField.backgroundColor = [UIColor yellowColor] ;
    textField.delegate = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"testViewDisplay" object:nil userInfo:@{
                                                                                                        @"vc":@"C"
                                                                                                        }] ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        
        DDLog(@"%@",window) ;
        
        if ([window.description hasPrefix:@"<UITextEffectsWindow"]) {   //<UITextEffectsWindow: 0x7fbaabd25b70; frame = (0 0; 320 568); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x7fbaabd26140>>
            
            DDLog(@"%@",window.rootViewController) ;                    //<UIInputWindowController: 0x7fbaad008a00>
            
            DDLog(@"%@",window.rootViewController.view);                //<UIInputSetContainerView: 0x7ffc70e12680; frame = (0 0; 320 568); layer = <CALayer: 0x7ffc70e25af0>>
            
            UIView *containerView = window.rootViewController.view ;
            for (UIView *view in containerView.subviews) {
                DDLog(@"%@",view) ;     //<UIInputSetHostView: 0x7f9341fd5610; frame = (0 315; 320 253); layer = <CALayer: 0x7f9341fd5780>>
                                        //<UIRemoteKeyboardWindow: 0x7f9341e3bcd0; frame = (0 0; 320 568); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x7f9341e3c060>>
            }
        }
    }
    
    return YES ;
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
