//
//  ReusePoolViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/23.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "ReusePoolViewController.h"
#import "ReusePool.h"

@interface ReusePoolViewController ()<ReusePoolDelegate>
@property (nonatomic, strong) ReusePool<NSString *> *pool;
@end

@implementation ReusePoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pool = [[ReusePool alloc] initWithDelegate:self];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        DDLog(@"adding");
        [self.pool addNewObjectToPool:[NSString stringWithFormat:@"%d", arc4random() % 100]];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *s = [self.pool getAnObjectFromPool];
    DDLog(@"%@", s);
}

#pragma mark - ReusePoolDelegate

- (id)createNewInstanceToPool:(ReusePool *)pool {
    return [NSString stringWithFormat:@"我是新创建的%d", arc4random() % 5];
}

@end
