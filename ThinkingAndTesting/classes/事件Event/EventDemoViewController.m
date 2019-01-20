//
//  EventDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/1/9.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "EventDemoViewController.h"
#import "EventView.h"

@interface EventDemoViewController ()
@property (nonatomic, strong) EventView *eventView;
@end

@implementation EventDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    EventView *eventView = [[EventView alloc] initWithFrame:CGRectMake(0, 100, DD_SCREEN_WIDTH, 100)];
    eventView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:eventView];
    self.eventView = eventView;
//    self.eventView.userInteractionEnabled = NO;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DDLog(@"viewcontroller's view be touched!");
    self.eventView.userInteractionEnabled = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asyn_global(^{
            [NSThread sleepForTimeInterval:3];
            asyn_main(^{
                DDLog(@"back to normal");
                self.eventView.userInteractionEnabled = YES;
            });
        });
    });
}

@end
