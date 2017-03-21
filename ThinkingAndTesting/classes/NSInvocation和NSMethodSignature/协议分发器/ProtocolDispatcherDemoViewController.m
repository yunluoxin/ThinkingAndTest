
//
//  ProtocolDispatcherDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/21.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ProtocolDispatcherDemoViewController.h"

#import "DDProtocolDispatcher.h"

#import "ProtocolDispatcher_TestA_Object.h"
#import "ProtocolDispacher_TestB_Object.h"

@interface ProtocolDispatcherDemoViewController ()< ProtocolDispatcherTestDelegate>
@property (nonatomic, strong) ProtocolDispatcher_TestA_Object * aobject ;
@end

@implementation ProtocolDispatcherDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Protocol Dispatcher Demo" ;
    
    self.view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5] ;
    
    ProtocolDispacher_TestB_Object * bobject = [ProtocolDispacher_TestB_Object new] ;
    
    
    
    self.aobject = [ProtocolDispatcher_TestA_Object new] ;
    
    self.aobject.delegate = [DDProtocolDispatcher dispatchProtocol:@protocol(ProtocolDispatcherTestDelegate) toImplementors:@[self, bobject] ] ;
    
    
    /// change order
//    self.aobject.delegate = [DDProtocolDispatcher dispatchProtocol:@protocol(ProtocolDispatcherTestDelegate) toImplementors:@[bobject, self] ] ;
    
    [self.aobject startTest] ;
    
}

- (void)printSomething
{
    DDLog(@"%@ , %s",self, __func__) ;
}


- (NSInteger)personInThisRoom
{
    return 888 ;
}

@end
