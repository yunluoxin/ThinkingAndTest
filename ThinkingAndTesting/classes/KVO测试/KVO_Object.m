//
//  KVO_Object.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "KVO_Object.h"

@interface KVO_Object ()
{

//    NSNumber * _test ;

}

//@property (nonatomic, readwrite) NSNumber * test ;

@end

@implementation KVO_Object

- (NSNumber *)test
{
    return @(arc4random() % 100) ;
}

@end

/*------------------------------------------------------------------------
    在.h中暴露在外的是readonly属性时候，能否kvo，对他进行监听，关键不是不在这个是什么属性，
 而在于，.m里面内部，也就是对象内部是否有这个成员属性（实例变量），如果有才可能涉及到属性值的
 变化，才能监测到！
    如上， 不管是定义一个@property的readwrite或者直接定义一个，_test属性都是可以的，这
 样就能成功KVO，当值变化时候，外界能监测到！所以，如果只是一个单纯的get方法（写成readonly）,
 是无法成功KVO的。监听方法无法得到回调的！
    另外，当回掉时候，得到的新值是默认读取getter方法里面的，假设你设置了属性为1，但是在
 getter里面重写成2,则监听到的是2. ~~~这个也很重要
 ------------------------------------------------------------------------*/
