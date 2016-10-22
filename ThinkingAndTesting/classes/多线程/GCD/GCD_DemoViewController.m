//
//  GCD_DemoViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "GCD_DemoViewController.h"
#import "AFNetworking.h"
@interface GCD_DemoViewController ()

@end

@implementation GCD_DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDLog(@"主线程---%@",[NSThread currentThread]);
    
//    [self demoAsynSerial];
    
//    [self demoAsynConcurrent];
    
//    [self demoAsynGlobal];
    
//    [self demoSynSerial];
    
//    [self demoSynConcurrent];
    
//    [self demoAsynMain];
    
//    [self demoSynMain];
    
//    [self AsynInvokeSynMain];
    
//    [self AsynInvokeAsynMain];
    
//    [self AsynSerialInvokeSynSerial];
    
//    [self AsynSerialInvokeAsynSerial];
    
//    [self AsynSerialInvokeAsynConcurrent];
    
//    [self SynSerialInvokeSynSerial];
    
//    [self SynSerialInvokeAsynSerial];
    
//    [self SynConcurrentInvokeSynConcurrent];
    
//    [self synAndMain];
    
//    [self manySynSerial];
    
//    [self demoPerformSelector];
    
//    [self testNetwork];
    
//    [self testAsynRequest];
    
//    [self testRunLoop ] ;
    
//    [self testDispatchGroup] ;
    
//    [self testSemaphore] ;
    
//    [self testAsynConcurrentSync] ;
    
    //测试死锁
//    [self testDeadLock] ;
    
//    [self runLoopTest] ;
    
    [self runLoopTest2] ;

}

//测试异步串行
- (void)demoAsynSerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_SERIAL);

    for (int i = 0 ; i < 100; i ++) {
        dispatch_async(queue, ^{
            DDLog(@"串行中%d--%@",i,[NSThread currentThread]);
                        [NSThread sleepForTimeInterval:0.1];
        });
    }
    
    /**
     *  上面的多个串行都在同一个线程里运行
     */
}

//测试异步并行
- (void)demoAsynConcurrent
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0 ; i < 100; i ++) {
        dispatch_async(queue, ^{
            DDLog(@"并行中%d--%@",i,[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        });
    }
}

//测试全局队列
- (void)demoAsynGlobal
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0 ; i < 100; i ++) {
        dispatch_async(queue, ^{
            DDLog(@"全局中%d--%@",i,[NSThread currentThread]);
//            [NSThread sleepForTimeInterval:1];
        });
    }
}

//同步串行
- (void)demoSynSerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_SERIAL);
    
    for (int i = 0 ; i < 100; i ++) {
        dispatch_sync(queue, ^{
            DDLog(@"串行中%d--%@",i,[NSThread currentThread]);
//            [NSThread sleepForTimeInterval:0.1];
        });
    }
    
    /**
     *  全部都在主线程运行
     *
     */
}

//同步并行
- (void)demoSynConcurrent
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0 ; i < 100; i ++) {
        dispatch_sync(queue, ^{
            DDLog(@"并行中%d--%@",i,[NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.1];
        });
    }
    
    
    DDLog(@"什么时候运行");
    
    /**
     *  全部都在主线程运行
     
     2016-03-08 15:13:58.714 ThinkingAndTesting[1357:22272] 主线程---<NSThread: 0x7f9fc0e04de0>{number = 1, name = main}
     2016-03-08 15:13:58.715 ThinkingAndTesting[1357:22272] 并行中0--<NSThread: 0x7f9fc0e04de0>{number = 1, name = main}
     2016-03-08 15:13:58.816 ThinkingAndTesting[1357:22272] 并行中1--<NSThread: 0x7f9fc0e04de0>{number = 1, name = main}
     .....................
     2016-03-08 15:14:08.599 ThinkingAndTesting[1357:22272] 并行中96--<NSThread: 0x7f9fc0e04de0>{number = 1, name = main}
     2016-03-08 15:14:08.704 ThinkingAndTesting[1357:22272] 并行中97--<NSThread: 0x7f9fc0e04de0>{number = 1, name = main}
     2016-03-08 15:14:08.806 ThinkingAndTesting[1357:22272] 并行中98--<NSThread: 0x7f9fc0e04de0>{number = 1, name = main}
     2016-03-08 15:14:08.908 ThinkingAndTesting[1357:22272] 并行中99--<NSThread: 0x7f9fc0e04de0>{number = 1, name = main}
     2016-03-08 15:14:09.009 ThinkingAndTesting[1357:22272] 什么时候运行
     */
}


//异步主线程
- (void)demoAsynMain
{
    for (int i = 0 ; i < 100; i ++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLog(@"异步主线程中%d--%@",i,[NSThread currentThread]);
        });
    }
    
    [NSThread sleepForTimeInterval:2];
    
    DDLog(@"这句话会什么时候运行");
    
    
    /**
     *  全部都在主线程运行
     
     
     2016-03-08 15:10:34.120 ThinkingAndTesting[1275:20052] 主线程---<NSThread: 0x7f80e0604e30>{number = 1, name = main}
     2016-03-08 15:10:36.126 ThinkingAndTesting[1275:20052] 这句话会什么时候运行
     2016-03-08 15:10:36.133 ThinkingAndTesting[1275:20052] 异步主线程中0--<NSThread: 0x7f80e0604e30>{number = 1, name = main}
     2016-03-08 15:10:36.133 ThinkingAndTesting[1275:20052] 异步主线程中1--<NSThread: 0x7f80e0604e30>{number = 1, name = main}
     2016-03-08 15:10:36.133 ThinkingAndTesting[1275:20052] 异步主线程中2--<NSThread: 0x7f80e0604e30>{number = 1, name = main}
     2016-03-08 15:10:36.133 ThinkingAndTesting[1275:20052] 异步主线程中3--<NSThread: 0x7f80e0604e30>{number = 1, name = main}
     2016-03-08 15:10:36.134 ThinkingAndTesting[1275:20052] 异步主线程中4--<NSThread: 0x7f80e0604e30>{number = 1, name = main}
     2016-03-08 15:10:36.134 ThinkingAndTesting[1275:20052] 异步主线程中5--<NSThread: 0x7f80e0604e30>{number = 1, name = main}
     .....................
     
     */
}

//同步主线程------->死锁
- (void)demoSynMain
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        DDLog(@"同步主线程中--%@",[NSThread currentThread]);
    });
    
    DDLog(@"------");
    
    
    /**
     *  上面两个log都打印不出来，死锁了。
     */
}

//异步中调用同步主线程
- (void)AsynInvokeSynMain
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_CONCURRENT);

        dispatch_async(queue, ^{
            DDLog(@"并行中--%@",[NSThread currentThread]);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:3];
                DDLog(@"同步主线程中--%@",[NSThread currentThread]);
            });
            
            DDLog(@"-------");
            
        });
    
    /**
     *  
     
     2016-03-08 15:27:48.818 ThinkingAndTesting[1497:27095] 主线程---<NSThread: 0x7ffc68e04e10>{number = 1, name = main}
     2016-03-08 15:27:48.819 ThinkingAndTesting[1497:27152] 并行中--<NSThread: 0x7ffc68c0a9a0>{number = 2, name = (null)}
     2016-03-08 15:27:51.831 ThinkingAndTesting[1497:27095] 同步主线程中--<NSThread: 0x7ffc68e04e10>{number = 1, name = main}
     2016-03-08 15:27:51.831 ThinkingAndTesting[1497:27152] -------

     */
}

//异步中调用异步主线程
- (void)AsynInvokeAsynMain
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        DDLog(@"并行中--%@",[NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLog(@"异步主线程中--%@",[NSThread currentThread]);
        });
        
        [NSThread sleepForTimeInterval:3];
        DDLog(@"========");
    });
    
    /**
     *  
     
     2016-03-08 15:31:14.808 ThinkingAndTesting[1527:28193] 主线程---<NSThread: 0x7fbb18606180>{number = 1, name = main}
     2016-03-08 15:31:14.809 ThinkingAndTesting[1527:28229] 并行中--<NSThread: 0x7fbb1840ec10>{number = 2, name = (null)}
     2016-03-08 15:31:14.815 ThinkingAndTesting[1527:28193] 异步主线程中--<NSThread: 0x7fbb18606180>{number = 1, name = main}
     2016-03-08 15:31:17.814 ThinkingAndTesting[1527:28229] ========
     
     */
}

//异步线程调用同步串行
- (void)AsynSerialInvokeSynSerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_SERIAL);
    
        dispatch_async(queue, ^{
            DDLog(@"异步串行中--%@",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.1];
            
            dispatch_sync(queue, ^{
                DDLog(@"同步串行---%@ ",[NSThread currentThread]);
            });
            
            [NSThread sleepForTimeInterval:3];
            DDLog(@"----------");
        });
    
    
    /**
     *  死锁（在A线程中等待A线程的完成）
     */
}



- (void)AsynSerialInvokeAsynSerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_SERIAL);

    dispatch_async(queue, ^{
        DDLog(@"异步串行中--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
        dispatch_async(queue, ^{
            DDLog(@"异步串行---%@ ",[NSThread currentThread]);
        });
        
        [NSThread sleepForTimeInterval:3];
        DDLog(@"----------");
    });
    
    /**
     *  
     2016-03-08 16:14:06.794 ThinkingAndTesting[1875:42415] 主线程---<NSThread: 0x7fed49d081f0>{number = 1, name = main}
     2016-03-08 16:14:06.794 ThinkingAndTesting[1875:42445] 异步串行中--<NSThread: 0x7fed49d26d10>{number = 2, name = (null)}
     2016-03-08 16:14:09.899 ThinkingAndTesting[1875:42445] ----------
     2016-03-08 16:14:09.899 ThinkingAndTesting[1875:42445] 异步串行---<NSThread: 0x7fed49d26d10>{number = 2, name = (null)}
     */
}

- (void)AsynSerialInvokeAsynConcurrent
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_CONCURRENT);
 
    dispatch_async(queue, ^{
        DDLog(@"异步并行中--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
        dispatch_async(queue, ^{
            DDLog(@"异步并行---%@ ",[NSThread currentThread]);
        });
        
        [NSThread sleepForTimeInterval:3];
        DDLog(@"----------");
    });
    
    /**
     *
     2016-03-08 15:48:24.376 ThinkingAndTesting[1743:35082] 主线程---<NSThread: 0x7fc4d04088d0>{number = 1, name = main}
     2016-03-08 15:48:24.377 ThinkingAndTesting[1743:35111] 异步并行中--<NSThread: 0x7fc4d0516f50>{number = 2, name = (null)}
     2016-03-08 15:48:24.482 ThinkingAndTesting[1743:35112] 异步并行---<NSThread: 0x7fc4d072ed10>{number = 3, name = (null)}
     2016-03-08 15:48:27.484 ThinkingAndTesting[1743:35111] ----------

     */
}

- (void)SynSerialInvokeSynSerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_SERIAL);

    dispatch_sync(queue, ^{
        DDLog(@"同步串行中--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
        dispatch_sync(queue, ^{
            DDLog(@"同步串行---%@ ",[NSThread currentThread]);
        });
        
        [NSThread sleepForTimeInterval:3];
        DDLog(@"-----%@-----",[NSThread currentThread]);
    });
    
    /**
     *  死锁
     *
     */
}

- (void)SynSerialInvokeAsynSerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        DDLog(@"同步串行中--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
        dispatch_async(queue, ^{
            DDLog(@"异步串行---%@ ",[NSThread currentThread]);
        });
        
        [NSThread sleepForTimeInterval:3];
        DDLog(@"-----%@-----",[NSThread currentThread]);
    });
    
    /**
     *  
     
     2016-03-08 16:33:34.492 ThinkingAndTesting[1992:48069] 主线程---<NSThread: 0x7ff84bd02570>{number = 1, name = main}
     2016-03-08 16:33:34.493 ThinkingAndTesting[1992:48069] 同步串行中--<NSThread: 0x7ff84bd02570>{number = 1, name = main}
     2016-03-08 16:33:37.598 ThinkingAndTesting[1992:48069] -----<NSThread: 0x7ff84bd02570>{number = 1, name = main}-----
     2016-03-08 16:33:37.599 ThinkingAndTesting[1992:48101] 异步串行---<NSThread: 0x7ff84bc13ba0>{number = 2, name = (null)}
     
     */
}

- (void)SynConcurrentInvokeSynConcurrent
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        DDLog(@"同步并行中--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
        dispatch_sync(queue, ^{
            DDLog(@"同步并行---%@ ",[NSThread currentThread]);
        });
        
        [NSThread sleepForTimeInterval:3];
        DDLog(@"-----%@-----",[NSThread currentThread]);
    });
    
    /**

     2016-03-08 16:56:46.018 ThinkingAndTesting[2159:54898] 主线程---<NSThread: 0x7fd329d08160>{number = 1, name = main}
     2016-03-08 16:56:46.019 ThinkingAndTesting[2159:54898] 同步并行中--<NSThread: 0x7fd329d08160>{number = 1, name = main}
     2016-03-08 16:56:46.122 ThinkingAndTesting[2159:54898] 同步并行---<NSThread: 0x7fd329d08160>{number = 1, name = main}
     2016-03-08 16:56:49.127 ThinkingAndTesting[2159:54898] -----<NSThread: 0x7fd329d08160>{number = 1, name = main}-----
     *
     */
}


//看出syn不是阻塞所有的线程,只是阻塞当前线程
- (void)synAndMain
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                      DDLog(@"%@-----",[NSThread currentThread]);
                      [NSThread sleepForTimeInterval:6];
           DDLog(@"-----%@-----",[NSThread currentThread]);

       });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DDLog(@"%@---2--",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
            DDLog(@"-----%@---2--",[NSThread currentThread]);
            
        });
    });
}

//串行并发执行，同步情况下直接在当前线程（这个vc是主线程），异步是新开一线程，新线程里并发执行
- (void)manySynSerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong", DISPATCH_QUEUE_SERIAL);
    for (int i = 0 ; i < 100 ; i ++) {
        dispatch_sync(queue, ^{
            DDLog(@"同步串行中--%d---%@",i,[NSThread currentThread]);
        });
    }
}

//并发无序的运行
- (void)demoPerformSelector
{
    for (int i = 0 ; i < 10 ; i ++) {
        [self performSelectorInBackground:@selector(ddd:) withObject:@(i)];
    }
}

- (void)ddd:(NSNumber *)i
{
    DDLog(@"--%@---%@-----",i,[NSThread currentThread]);
}


//测试线程组。。线程组通知notify会等待同一组内的其他线程都运行完毕后才执行。
- (void)testNetwork
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(10, 100, 100, 50);
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(demoAsynSerial) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_group_t group = dispatch_group_create() ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
//        DDLog(@"百度%@",[NSThread currentThread]);
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            DDLog(@"百度成功了---%@",responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            DDLog(@"百度失败了");
//        }];
        
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response ;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        DDLog(@"%@",response);
    });
    
    dispatch_group_async(group, queue, ^{
        DDLog(@"qq%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:10];
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        [manager GET:@"http://www.qq.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            DDLog(@"qq成功了---%@",responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            DDLog(@"qq失败了");
//        }];
        
        NSURL *url = [NSURL URLWithString:@"http://www.qq.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response ;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        DDLog(@"%@",response);

    });
    
    
    dispatch_group_notify(group, queue, ^{
        DDLog(@"两个都成功了");
    });
}

- (void)testAsynRequest
{
    NSURL *url = [NSURL URLWithString:@"http://www.qq.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        DDLog(@"%@",[NSThread currentThread]);
        DDLog(@"%@",response);
    }];
    [NSThread sleepForTimeInterval:10];
    DDLog(@"10秒后");
    
    
    /**
     *  
     
     相当于异步主线程 dispatch_asyn(dispatch_get_main_queue, ^(){
     
     });
     
     2016-03-22 08:26:59.385 ThinkingAndTesting[18319:794660] 主线程---<NSThread: 0x7f8918c02170>{number = 1, name = main}
     2016-03-22 08:27:09.387 ThinkingAndTesting[18319:794660] 10秒后
     2016-03-22 08:27:09.394 ThinkingAndTesting[18319:794660] <NSThread: 0x7f8918c02170>{number = 1, name = main}
     2016-03-22 08:27:09.395 ThinkingAndTesting[18319:794660] <NSHTTPURLResponse: 0x7f8918f2ed60> { URL: http://www.qq.com/ } { status code: 200, headers {
     "Cache-Control" = "max-age=60";
     Connection = "keep-alive";
     
     */
}


/**
 *   iOS多线程中performSelector: 和dispatch_time的不同
 */
- (void)testRunLoop
{
    [self testDispatch_Barrier] ;
}

/*
 
 testDispatch_after
 延时添加到队列
 
 */

-(void)testDispatch_after{
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
    
    dispatch_after(time, dispatch_get_main_queue(), ^{

                       NSLog(@"3秒后添加到主队列");
                       
                   });
    
}

-(void)testDelay{

    NSLog(@"3秒后testDelay被执行");
    DDLog(@"%@",[NSThread currentThread]) ;
}

/*
 
 dispatch_barrier_async
 栅栏的作用
 
 */

-(void)testDispatch_Barrier{
    
    dispatch_queue_t gcd = dispatch_queue_create("这是序列队列", DISPATCH_QUEUE_SERIAL);
    
//    dispatch_queue_t gcd = dispatch_queue_create("这是并发队列", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(gcd,^{
        
//        [self performSelector:@selector(testDelay) withObject:nil] ;        //这个selector会执行!!!
        
        
        [self performSelector:@selector(testDelay) withObject:nil afterDelay:3 ];  //这个selector不会执行
        
        
        /*
         
        [self performSelector:@selector(testDelay) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO] ;  //不同步的，由于当前thread缺少runloop不会执行
        [self performSelector:@selector(testDelay) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES] ; //同步的，会执行
         
        */
        
        
        
        //[self  testDispatch_after];  //代码会执行
        
        
    });
    
    
    //只有主线程会在创建的时候默认自动运行一个runloop，调度timer，普通的子线程是没有这些的。
    //在子线程中被调用的时候，我们的代码中的延时调用的代码会在内部创建一个timer加到runloop中，但是子线程没有runLoop，这样我们的代码就永远不会被调到。
    
}



/**
 *  引入了 dispatch_semaphore_t 信号量控制！
 *  如果在两个异步方法，都执行完之后进行操作！ 特别是异步方法里面，还有异步，导致group无法控制的时候，怎么解决的！解决了前面-testNetwork方法，每个异步方法里面，只能是同步的问题！
 */
- (void)testDispatchGroup
{
    dispatch_group_t group = dispatch_group_create() ;
    dispatch_queue_t queue = dispatch_queue_create("com.dadong.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0) ; //一般都是传入0 ，传入负值得到空的信号量
    
    dispatch_group_async(group, queue, ^{
        DDLog(@"-----dispatch_group_baidu----%@",[NSThread currentThread] );
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
        [manager GET:@"https://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"百度成功了--%ld-%@",i,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [NSThread sleepForTimeInterval:5] ;

            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"百度失败了-%ld",i);
        }];
        
    });
    
    dispatch_group_async(group, queue, ^{
        
        DDLog(@"-----dispatch_group_QQ----%@",[NSThread currentThread] );
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager GET:@"http://www.qq.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"QQ成功了--%ld-%@",i,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [NSThread sleepForTimeInterval:5] ;

            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"QQ失败了-%ld",i);
        }];
    });
    
    
    dispatch_group_notify(group, queue, ^{
        
        DDLog(@"-----loading------waiting-----") ;
//        [NSThread sleepForTimeInterval:5] ;

        long i = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
        NSLog(@"%ld",i) ;

        long j = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
        NSLog(@"%ld",j) ;
        
        DDLog(@"-----dispatch_group_notify----%@",[NSThread currentThread] );
    });
    
}

- (void)testSemaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2) ;
    
    long i = dispatch_semaphore_signal(semaphore) ;         //成功唤醒线程返回非0值，没有唤醒返回0 ；
    DDLog(@"%ld",i) ;
         i = dispatch_semaphore_signal(semaphore) ;
    DDLog(@"%ld",i) ;
    i = dispatch_semaphore_signal(semaphore) ;
    DDLog(@"%ld",i) ;
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ; //成功返回0，不成功返回非0
    DDLog(@"---------" ) ;
    
    /**
     *  初始信号量为2，照样全返回0 ；经API查看，这个返回的不是信号量、！！！
     */
}

/**
 *  测试异步并行中，同步最后的代码.-----是前面数第二个方法的改版。
 */
- (void)testAsynConcurrentSync
{
    dispatch_queue_t queue = dispatch_queue_create("com.dadong.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0) ; //一般都是传入0 ，传入负值得到空的信号量
    
    dispatch_async(queue, ^{
        DDLog(@"-----dispatch_group_baidu----%@",[NSThread currentThread] );
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
        [manager GET:@"https://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"百度成功了--%ld-%@",i,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            [NSThread sleepForTimeInterval:5] ;
            
            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"百度失败了-%ld",i);
        }];
        
    });
    
    dispatch_async(queue, ^{
        
        DDLog(@"-----dispatch_group_QQ----%@",[NSThread currentThread] );
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager GET:@"http://www.qq.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"QQ成功了--%ld-%@",i,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            [NSThread sleepForTimeInterval:5] ;
            
            long i = dispatch_semaphore_signal(semaphore) ;
            DDLog(@"QQ失败了-%ld",i);
        }];
    });
    
    
    //这个方法也可以放在主线程中，但是会堵塞主线程，并且如果里面用了回调主线程的，就会引起死锁！！！（比如AFN框架） 测试在下面 -testDeadLock
    dispatch_async(queue, ^{
        
        DDLog(@"-----loading------waiting-----") ;
                [NSThread sleepForTimeInterval:5] ;
        
        long i = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
        NSLog(@"%ld",i) ;
        
        long j = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
        NSLog(@"%ld",j) ;
        
        DDLog(@"-----dispatch_group_notify----%@",[NSThread currentThread] );
    });
}


/**
 *  在主线程中放置一个等待信号量，已经阻塞主线程了。又想在主线程中异步执行block内容，附带释放信号量，这是不可能的！
 */
- (void)testDeadLock
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0) ;
    dispatch_queue_t queue = dispatch_queue_create("www.dadong.deadlock", DISPATCH_QUEUE_CONCURRENT) ;
    
    dispatch_async(queue, ^{
        DDLog(@"异步执行里面") ;
        [NSThread sleepForTimeInterval:3] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLog(@"能被执行到吗") ;
            dispatch_semaphore_signal(semaphore) ;
        }) ;
    }) ;

//    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 5 * NSEC_PER_SEC))) ;     //5秒超时，则超时后，解锁！
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ; //死锁
    DDLog(@"释放了资源") ;
}


- (void)runLoopTest
{
    /*
    asyn_global(^(){
        bool shouldKeepRunning = YES ;
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop] ;
        [runloop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes] ;
        
        //通过这个表达式，可以在其他地方将shouldKeepRunning = NO , 则这个runLoop不会运行起来。
        while (shouldKeepRunning && [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) ;
        
        DDLog(@"runloop之后不会执行-------这句话不会得到执行" );
    });
     */
    
    static NSThread *myThread = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myThread = [[NSThread alloc] initWithTarget:self selector:@selector(customThreadInitialize) object:nil] ;
        [myThread setName:@"com.dadong.runLoopTest"] ;
        [myThread start] ;  //新开线程，如果此线程没有代码执行，则马上就会被关闭
    });
    
    
    [self performSelector:@selector(testDelay) onThread:myThread withObject:nil waitUntilDone:YES] ; //直接抛出异常，YES是不行的，是同步的，主线程等待myThread执行完，但是myThread没有运行循环，已经离开
}

- (void)customThreadInitialize
{
    DDLog(@"%@初始化成功...此方法会在start之后调用.....",[NSThread currentThread]) ;
}



/*
         ================================================================
         ===================通过底下测试自己建立runLoop=====================
         ================================================================
 */

- (void)runLoopTest2
{
   
    static NSThread *myThread = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myThread = [[NSThread alloc] initWithTarget:self selector:@selector(customThreadInitialize2) object:nil] ;
        [myThread setName:@"com.dadong.runLoopTest2"] ;
        [myThread start] ;  //新开线程，如果此线程没有代码执行，则马上就会被关闭
    });
    
    
//    [self performSelector:@selector(testDelay) onThread:myThread withObject:nil waitUntilDone:YES] ;      //这个方法虽然同步的，但是执行的线程是myThread,而不是平时同步主线程一样，用的MainThread执行。（从testDelay中打印可以得出）
    
    [self performSelector:@selector(doAfter3seconds) onThread:myThread withObject:nil waitUntilDone:NO] ;
}

- (void)customThreadInitialize2
{
    DDLog(@"%@初始化成功...此方法会在start之后调用.....",[NSThread currentThread]) ;
    NSRunLoop * runLoop = [NSRunLoop currentRunLoop] ;
    [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes] ;
    [runLoop run] ;
}
- (void)doAfter3seconds
{
    //通过这样子，变相实现，在不同的线程延迟xxx时间后，执行某个东西
    [self performSelector:@selector(testDelay) withObject:nil afterDelay:3] ;
}


@end
