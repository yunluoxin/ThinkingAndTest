//
//  GCDTimerViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/2.
//  Copyright © 2018 dadong. All rights reserved.
//
/*
 
 GCD_Timer
 
 一旦延迟后，超过一个周期补一个，超过>= 2 个周期，就会补上2个周期，连续执行的！
 也是和NSTimer一样，都是按设置好的时间执行！！！
 
 ------------------------- ------------------------- ------------------------- -------------------------
 
 2018-11-02 19:24:17.302: GCDTimerViewController.m 第34行: -[GCDTimerViewController doSomethings]
 
 2018-11-02 19:24:17.375: GCDTimerViewController.m 第29行: 1541157857.375077
 
 2018-11-02 19:24:18.302: GCDTimerViewController.m 第34行: -[GCDTimerViewController doSomethings]
 
 2018-11-02 19:24:19.302: GCDTimerViewController.m 第34行: -[GCDTimerViewController doSomethings]
 
 dispatch_suspend(), dispatch_resume()后，继续按原来设置好的时间点执行，不补上，也不先立即执行一次！
 
 
 @warning 如果添加 dispatch_suspend的调用后timer 是无法被释放的(内部释放的时候会查看timer的状态，如果是suspend，就崩溃)！！！一般情况下会发生崩溃并报“EXC_BAD_INSTRUCTION”错误，必须成对调用dispatch_resume(),才能cancel.
 
 发现dispatch_suspend，dispatch_suspend 都会导致当前vc无法释放，内存泄露！ 和NSTimer一样。 （注意下suspend也不行就是了！）
 
 一旦 dispatch_source_cancel(timer)， timer是无法重新利用的，只能重新创建！
 
 dispatch_resume()重复调用会崩溃
*/

#import "GCDTimerViewController.h"

@interface GCDTimerViewController ()
@property (strong, nonatomic) dispatch_source_t longPressTimer;
@end

@implementation GCDTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self openLongPressTimer];
}

- (void)dealloc {
    DDLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    dispatch_resume(self.longPressTimer);
//    dispatch_suspend(self.longPressTimer);
    dispatch_cancel(self.longPressTimer);
    self.longPressTimer = nil;
    [self dd_navigateTo:[self.class new]];
}

- (void)doSomethings {
    DDLog(@"%s", __func__);
}

- (void)closeLongPressTimer {
    if (_longPressTimer) {
        dispatch_cancel(_longPressTimer);
        _longPressTimer = nil;
    }
}

- (void)openLongPressTimer {
    if (!_longPressTimer) {
        _longPressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    int64_t timeInterval = 1.0 * NSEC_PER_SEC;
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, timeInterval);
    dispatch_source_set_timer(_longPressTimer, start, timeInterval, 0);
    dispatch_source_set_event_handler(_longPressTimer, ^{
        [self doSomethings];
    });
    dispatch_resume(_longPressTimer);
}

@end
