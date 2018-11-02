//
//  TimerDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/2.
//  Copyright © 2018 dadong. All rights reserved.
//

/*
 1.
 
 2018-11-02 17:09:59.254: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings]
 
 2018-11-02 17:10:00.254: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings]
 
 2018-11-02 17:10:01.254: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings]
 
 2018-11-02 17:10:02.254: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings]
 
 2018-11-02 17:10:03.254: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings] ```
 
 2018-11-02 17:10:05.390: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings] ``` 04.259, 05.259被漏过去了。 得到执行机会后只能执行一次！
 
 2018-11-02 17:10:06.254: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings] ```
 
 2018-11-02 17:10:07.254: TimerDemoViewController.m 第31行: -[TimerDemoViewController doSomethings]

 模拟的时候，在04.00(下一次触发前进行了耗时操作）阻塞了主线程1.5s， 则4.259和5.259都被超过了，那就只能等得到运行机会，合并执行一次！同理错过了更多个周期，也是只能合并执行一次！
 
 
 2.

 2018-11-02 17:18:43.866: TimerDemoViewController.m 第50行: -[TimerDemoViewController doSomethings]
 
 2018-11-02 17:18:44.866: TimerDemoViewController.m 第50行: -[TimerDemoViewController doSomethings]
 
 2018-11-02 17:18:45.940: TimerDemoViewController.m 第50行: -[TimerDemoViewController doSomethings]
 
 2018-11-02 17:18:46.956: TimerDemoViewController.m 第50行: -[TimerDemoViewController doSomethings]
 
 如果没有错误一个周期，则补上一次，可能几ms后立马执行下一次！
 --------------------------------------------------------------------------------------------------------
 
 *******不管该timer的触发时间延迟的有多离谱，他后面的timer的触发时间总是倍数于第一次添加timer的间隙**********
 
 
 推测，苹果底层应该是进行了插值了，设置定时器后，就在几个时间点都设置好了回调，类似js的。如果延误了，就设置一个标志位 needToTriggle = YES, 下一次得到线程机会后，
 如果有标志位就执行一次，并清空标志位！
 
 
 NSTimer添加到RunLoop中后，会被RunLoop强引用，所以拿怕你不保存引用，也能继续执行而不被释放！
 NSTimer内部，又会强引用它的Target! 所以必须外部调用 Timer invaild 才可以打破循环！
 */
#import "TimerDemoViewController.h"

@interface TimerDemoViewController ()
@property (strong, nonatomic) NSTimer *longPressTimer;

@end

@implementation TimerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    [self longPressTimer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [NSThread sleepForTimeInterval:0.9];
}

- (void)doSomethings {
    DDLog(@"%s", __func__);
}

- (NSTimer *)longPressTimer {
    if (!_longPressTimer) {
        _longPressTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(doSomethings) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_longPressTimer forMode:NSDefaultRunLoopMode];
    }
    return _longPressTimer;
}
@end
