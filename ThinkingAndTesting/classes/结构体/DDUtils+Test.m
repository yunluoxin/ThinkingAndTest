//
//  DDUtils+Test.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/30.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDUtils+Test.h"

@implementation DDUtils (Test)

@end

@interface DDUtils (HaHa)

+ (void)ifIAmPublic ;

/**
 *  @result     不行！！！ 调用下面的方法崩溃！
 *  @conclusion 在Category里，是无法通过property生成方法实现的！***都必须手动增加方法实现！下面这句话只能增加选择子(selector)!***
 */
@property (strong, nonatomic)NSMutableArray * array ;

@end

@implementation DDUtils (HaHa)

+ (void)ifIAmPublic
{
    DDLog(@"%s",__func__) ;
}

@end





// Extention可以有多个！！！

@interface DDUtils ()

+ (void)testAnymouse ;

/**
 *  @result     不行！！！ 调用下面的方法崩溃！
 *  @conclusion 在Category里，是无法通过property生成方法实现的！***都必须手动增加方法实现！下面这句话只能增加选择子(selector)!***
 */
@property (strong, nonatomic)UIColor * color ;

@end

/// 可以使用
//@implementation DDUtils (t)
//
//@end

@interface DDUtils ()

+ (void)areYouOK ;

@end

@implementation DDUtils (Anonymous)

- (void)testAnonymouse
{
    /// 下面的都是只有方法子，没有实现!!! 所以会出错！
    //    DDLog(@"%@",[self color]) ;   // Error Happens! => -[DDUtils color]: unrecognized selector sent to instance
    
//    DDLog(@"%@",self.array) ;         // Error Happens! => [DDUtils array]: unrecognized selector sent to instance
    
//    DDLog(@"%@",self.name) ;
}

@end


@implementation DDUtils (Kao)

+ (void)kaoYa
{
    DDLog(@"%s",__func__) ;
    
    DDUtils * u = [[self alloc] init] ;
    [u testAnonymouse] ;
}

@end
