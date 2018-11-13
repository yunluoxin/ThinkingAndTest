//
//  OperationQueueViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/12.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "OperationQueueViewController.h"

@interface OperationQueueViewController ()
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation OperationQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSOperation *operation = [CustomOperation new];
    operation.name = @"viewDidLoad";
    [self.queue addOperation:operation];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    /* cancelAllOperations会把当前队列中所有的任务状态标注成取消，不一定真能结束已经在执行的任务！而且可以继续添加正常的任务*/
    [self.queue cancelAllOperations];
    
    /* suspend 几乎不能暂时已经在执行的operation的继续执行（除非operation有特殊处理）！只能阻止队列继续添加任务！*/
//    self.queue.suspended = YES;

    NSOperation *operation = [CustomOperation new];
    operation.name = @"touch began";
    [self.queue addOperation:operation];
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 3;
        _queue.name = @"com.dadong.operation.test";
    }
    return _queue;
}

@end

@implementation CustomOperation {
    
}

- (void)main {
    @try {
        BOOL isDone = NO;
        while (!self.cancelled && !isDone) {
            //        while (true) {
            DDLog(@"%@ ready to sleep...", self.name);
            sleep(3);
            DDLog(@"%@ after sleeping...", self.name);
            //        }
        }
    } @catch (NSException *exception) {
        DDLog(@"%@", exception);
    } @finally {
        
    }
}

@end

@implementation ConcurrentOperation
{
    BOOL executing;
    BOOL finished;
}

- (instancetype)init {
    if (self = [super init]) {
        executing = NO;
        finished = NO;
    }
    return self;
}

- (void)start {
    // Always check for cancellation before launching the task.
    if (self.isCancelled) {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    @try {
        while (!self.isCancelled && !finished) {
            DDLog(@"ready to sleep...");
            sleep(3);
            DDLog(@"after sleeping...");
        }
    } @catch (NSException *exception) {
        DDLog(@"%@", exception);
    } @finally {
        
    }
}

- (void)p_completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

///
/// @Required 标识当前的Operation是异步的
///
- (BOOL)isConcurrent {
    return YES;
}

@end
