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
 *  不行！！！
 */
@property (strong, nonatomic)UIColor * color ;

@end

@interface DDUtils ()

+ (void)areYouOK ;

@end

@implementation DDUtils (Anymouse)

- (void)testAnymouse
{
    DDLog(@"%@",self.color) ;
}

@end


@implementation DDUtils (Kao)

+ (void)kaoYa
{
    DDLog(@"%s",__func__) ;
    
    DDUtils * u = [[self alloc] init] ;
    [u testAnymouse] ;
}

@end
