//
//  NSProgressDemo_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/22.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSProgressDemo_ViewController.h"

static NSString * const FractionCompletedKey = @"fractionCompleted" ;

@interface NSProgressDemo_ViewController ()

/**
 *  <#note#>
 */
@property (nonatomic, strong)NSProgress * progress ;

@property (nonatomic, weak) UIProgressView * progressView ;
@end

@implementation NSProgressDemo_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSProgress Demo" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    UIProgressView * progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] ;
    [[UIApplication sharedApplication].keyWindow addSubview:progressView] ;
    progressView.frame = CGRectMake(0, 63, self.view.dd_width, 1) ;
    progressView.progressTintColor = [UIColor blackColor] ;
    progressView.trackTintColor = [UIColor yellowColor] ;
    self.progressView = progressView ;
    
//    [self test2] ;
    
    [self testSubTask] ;
    
}


#pragma mark - 测试任务进度条

- (void)test2
{
    NSInteger batchSize = 1000 ;
    
    self.progress = [NSProgress progressWithTotalUnitCount:batchSize] ;
    
    [self.progress addObserver:self forKeyPath:FractionCompletedKey options:NSKeyValueObservingOptionNew context:nil] ;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSUInteger index = 0; index < batchSize; index++) {
            // 第二步、每次都需要检查任务是否已经取消了
            // 任务取消  >>>  NSProgress也要取消掉
            if ([self.progress isCancelled]) {
                // Tidy up as necessary...
                break;
            }
            
            // Do something with this batch of data...
            [NSThread sleepForTimeInterval:0.01] ;
            
            // 第三步、修改NSProgress中已经完成的工作量
            [self.progress setCompletedUnitCount:(index + 1)];
            
            //        DDLog(@"%@",progress) ;
        }
        
        [self.progress removeObserver:self forKeyPath:FractionCompletedKey] ;
        
    }) ;
}


#pragma mark - 测试线程绑定进度

- (void)test
{
    // 创建一个新的Progress
    self.progress = [NSProgress progressWithTotalUnitCount:1000] ;
    
    DDLog(@"%@",self.progress) ;
    
    DDLog(@"1. %@",[NSProgress currentProgress]) ;
    
    ///
    /// 1. 给当前主线程绑定一个Progress
    /// 2. 为此线程设定一个工作量: pendingUnitCount
    ///
    [self.progress becomeCurrentWithPendingUnitCount:500] ;
    
    DDLog(@"2. %@",[NSProgress currentProgress]) ;  // 通过此方法获取与`当前线程`绑定的NSProgress对象
    
    ///
    /// 解除当前主线程对Progress的绑定
    /// 解除后，默认会把此线程要完成的工作量当做已经完成，累加到progress里面
    ///
    [self.progress resignCurrent] ;
    
    DDLog(@"3. %@",[NSProgress currentProgress]) ;
    
    DDLog(@"%@",self.progress) ; // 0.5
    
    
    // 验证
    
    [self.progress becomeCurrentWithPendingUnitCount:200] ;
    [self.progress resignCurrent] ;
    
    DDLog(@"%@",self.progress) ;  // 0.7
}



#pragma mark - 有子任务时候进度条测试

- (void)testSubTask
{
    self.progress = [NSProgress progressWithTotalUnitCount:100] ;
    [self.progress addObserver:self forKeyPath:FractionCompletedKey options:NSKeyValueObservingOptionNew context:nil] ;
    
    ///
    /// 必须非主线程执行。。否则，会造成KVO无法及时回调，只有全部都完成之后才会得到回调（主线程一直处于执行-堵塞状态）
    ///
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.progress becomeCurrentWithPendingUnitCount:60] ;
        DDLog(@"task 1 is abount to execute") ;
        [self subTask] ;
        [self.progress resignCurrent] ;
        
        [self.progress becomeCurrentWithPendingUnitCount:40] ;
        DDLog(@"task 2 is abount to execute") ;
        [self subTask] ;
        [self.progress resignCurrent] ;
        
        [self.progress removeObserver:self forKeyPath:FractionCompletedKey] ;
    }) ;
    
    
    // `becomeCurrentWithPendingUnitCount` 和 `resignCurrent` 必须配套，并且在同一个线程，否则会出错！！！毕竟是取消当前线程的绑定！
}

/// 模拟子任务
- (void)subTask
{
    NSProgress * progress = [NSProgress progressWithTotalUnitCount:100] ;
    
    while (progress.completedUnitCount < progress.totalUnitCount) {
        if (progress.isCancelled) {
            break ;
        }
        [NSThread sleepForTimeInterval:0.1] ;
        progress.completedUnitCount++ ;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DDLog(@"%s",__func__) ;
    
    [self.progress cancel] ;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:FractionCompletedKey]) {
        
        // You have to update your UI in main thread, since we don't know the kvo's sender running in which thread.
        dd_safe_syn_main(^{
            NSNumber * value = change[@"new"] ;
            self.progressView.progress = value? value.floatValue : .0f ;
        }) ;
    }
}

- (void)dealloc
{
    
}

@end
