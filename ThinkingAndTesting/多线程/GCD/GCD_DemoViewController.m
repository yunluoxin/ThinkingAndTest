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
    
    [self testAsynRequest];
    
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
@end
