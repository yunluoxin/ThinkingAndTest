//
//  TestXibViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TestXibViewController.h"

@interface TestXibViewController ()

@end

@implementation TestXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        
        DDLog(@"%@",window) ;
        
        if ([window.description hasPrefix:@"<UITextEffectsWindow"]) {   //<UITextEffectsWindow: 0x7fbaabd25b70; frame = (0 0; 320 568); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x7fbaabd26140>>
            
            DDLog(@"%@",window.rootViewController) ;                    //<UIInputWindowController: 0x7fbaad008a00>
            
            DDLog(@"%@",window.rootViewController.view);                //<UIInputSetContainerView: 0x7ffc70e12680; frame = (0 0; 320 568); layer = <CALayer: 0x7ffc70e25af0>>
            
            UIView *containerView = window.rootViewController.view ;
            for (UIView *view in containerView.subviews) {
                DDLog(@"%@",view) ;             // <UIInputSetHostView: 0x7fdcc1caecf0; frame = (0 568; 320 0); layer = <CALayer: 0x7fdcc1caf090>>
                                                //<UIRemoteKeyboardWindow: 0x7f9341e3bcd0; frame = (0 0; 320 568); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x7f9341e3c060>>
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
