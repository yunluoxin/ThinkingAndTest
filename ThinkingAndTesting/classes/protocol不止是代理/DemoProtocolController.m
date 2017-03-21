//
//  DemoProtocolController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoProtocolController.h"
#import "Cat.h"
@interface DemoProtocolController () < AnimalBehaviorProtocol>

@end

@implementation DemoProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];

    //多态
    id<AnimalBehaviorProtocol> animal = [Cat new];
    [animal run] ;
    
    Animal *animal2 = [Cat new] ;
    [animal2 walk] ;
    [animal2 isCute] ;
    
    //iOS中无法定义抽象类
//    Animal *a  = [Animal new] ;
//    [a walk] ;
    
    
    
    
    //私有变量也能被KVC
    Cat *cat = [Cat new] ;
    [cat setValue:@"dsf" forKey:@"_privateVar"] ;
    [cat setValue:@"dsf" forKey:@"privateVar"] ;
    [cat test] ;
    
    
    ///
    /// come the conclusion: Only classes which explictly show that conforming to the protocol can be true.
    /// 这个只是检测字面上的，代码上没标记遵守的<>就是，返回false, 不是实际检测方法
    ///
    if ([Animal conformsToProtocol:@protocol(AnimalBehaviorProtocol)]) {
        DDLog(@"Animal class conform to the 'AnimalBehaviorProtocol'") ;
    }
    
    // For an example. this vc doesn't comform to the protocol. but i write that.
    if ([self conformsToProtocol:@protocol(AnimalBehaviorProtocol)]) {
        
        DDLog(@"%s conform to the protocol", object_getClassName(self)) ;
        /*
            `2017-03-18 05:19:19: DemoProtocolController.m 第52行: DemoProtocolController conform to the protocol`
             当前vc竟然遵守!!! 可见只是字面上的
         */
    }else{
        DDLog(@"%s doesn't comform to the protocol", object_getClassName(self)) ;
    }
    
}


@end
