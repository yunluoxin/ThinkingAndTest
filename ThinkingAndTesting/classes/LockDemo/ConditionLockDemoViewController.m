//
//  ConditionLockDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "ConditionLockDemoViewController.h"

@interface ConditionLockDemoViewController ()

@end

@implementation ConditionLockDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self demoCondition];
    
//    [self demoConditionLock];
    
    [self demoConditionLock2];
}

- (void)demoCondition {
    NSCondition *lock = [[NSCondition alloc] init];
    NSMutableArray *goods = @[].mutableCopy;
    asyn_global(^{
        [lock lock];
        sleep(2);
        if (goods.count == 0) {
            DDLog(@"before wait");
            [lock wait];        // 这个会释放锁，使线程处于等待
            DDLog(@"after wait");
        }
        
        DDLog(@"before unlock");
        [lock unlock];
        sleep(1);
        DDLog(@"after unlock");
    });
    
    asyn_global(^{
        [lock lock];
        sleep(1);
        [goods addObject:@(0)];
        DDLog(@"before signal 1");
        [lock signal];              // 这个不会释放锁。。 代码会继续往下走，直到unlock, 上面的wait之后代码才得到执行！
        sleep(1);
        DDLog(@"after signal 1 ");
        sleep(1);
        DDLog(@"before unlock 1");
        [lock unlock];
        sleep(1.2);
        DDLog(@"after unlock 1");
    });
}



///
/// 一旦 lockWhenCondition:X 或者 unlockWithCondition:0, 必须是相应条件，才能进入锁~
/// 比如，初始化的condition是1， 则想要获得锁，必须lockWhenCondition:1.
//       如果上一块unlockWithCondition:2, 则下一块，必须是lockWhenCondition:2才能进入它的锁
//  最坑的是，如果直接unlock没条件，则下一块必须是正常的lock，如果是lockWhenCondition:X,不会得到执行！
///
- (void)demoConditionLock {
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
    asyn_global(^{
        sleep(2);
        DDLog(@"before lock condition");
        [lock lockWhenCondition:1];
        DDLog(@"after lock condition");
        
        DDLog(@"before unlock condition");
        
        [lock unlockWithCondition:0];
        sleep(1);
        DDLog(@"after unlock condition");
    });
    
    asyn_global(^{
        sleep(1);
        DDLog(@"before lock condition 0");
        [lock lockWhenCondition:0];
        DDLog(@"after lock condition 0");
        
        DDLog(@"before unlock condition 0");
        
        [lock unlockWithCondition:0];
        DDLog(@"after unlock condition 0");
    });
}

- (void)demoConditionLock2 {
//    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
//    asyn_global(^{
//        sleep(2);
//        if ([lock tryLockWhenCondition:1]) {
//            DDLog(@"before lock condition");
//            [lock lockWhenCondition:1];
//            DDLog(@"after lock condition");
//        }
//
//        DDLog(@"before unlock condition");
//        [lock unlockWithCondition:0];
//        sleep(1);
//        DDLog(@"after unlock condition");
//    });
//
//    asyn_global(^{
//        sleep(1);
//        if ([lock tryLockWhenCondition:0]) {
//            DDLog(@"before lock condition 0");
//            [lock lockWhenCondition:0];
//            DDLog(@"after lock condition 0");
//        }
//
//        DDLog(@"before unlock condition 0");
//
//        [lock unlockWithCondition:0];
//        DDLog(@"after unlock condition 0");
//    });
}


@end
