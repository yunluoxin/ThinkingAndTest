//
//  MacroDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/17.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "MacroDemoViewController.h"

#ifndef TestMacroA
#define TestMacroA(args) #args      //#的功能是将其后面的宏参数进行字符串化操作，意思就是对它所应用的宏变量通过替换后在其左右各加上一个双引号
#endif

#ifndef WARN_IF
#define WARN_IF(condition)    \
do{\
    if(condition){\
        printf("WARNING! "#condition"\n");\
    }\
}while(0);
#endif


#ifndef LinkA
#define LinkA(A,B)  (A#B)
#endif

#define LinkB(a,b)  a##b        //##的功能用来将两个token连接为一个token，但它不可以位于第一个token之前or最后一个token之后。注意这里连接的对象只要是token就行，而不一定是宏参数,但是##又必须位于宏定义中才有效，因其为编译期概念

typedef NSString LinkB(Fresh,string) ;




#define weakify(object) try{} @finally{} __weak __typeof__(object) weak##_##object = object ;
#define strongify(object) try{} @finally{} __strong __typeof__(object) object = weak##_##object ;


typedef void (^BlockB)(NSInteger) ;

@interface MacroDemoViewController ()

@end

@implementation MacroDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"宏定义Demo" ;
    
    
    
    int abc = 10 ;
    
    printf("-------"TestMacroA(abc)"\n") ;  //输出的是abc，只是字符串abc，和上面的int定义没关系
    
    
    
    
    WARN_IF(abc == 10) ;                //输出 WARNING! abc == 10
    
    WARN_IF(1 == 1) ;                   //输出 WARNING! 1 == 1
    
    
    
    
    printf("linkA(5,6) = %s\n",LinkA("5",6));
    
    int m56 = 111 ;
    printf("linkB(m5,6) = %d\n",LinkB(m5,6));
    
    int mn = 333 ;
    printf("linkB(m,n) = %d\n",LinkB(m, n)) ;
    
    
    Freshstring * str = @"6" ;
    DDLog(@"%@",str) ;

    
    
    

#pragma mark 指针强弱，防止循环引用
    
    @weakify(self)
    void (^blockA)() = ^(){
        @strongify(self)
        DDLog(@"%@",self) ;
    } ;
    
    
    blockA() ;
    
    
    //一种block用法
    BlockB b = ^(NSInteger a){
        DDLog(@"%zd",a);
    } ;
    
    b(5555) ;
}

- (void)dealloc
{
    DDLog(@"%@",NSStringFromSelector(_cmd)) ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController * vc = [[self class] new] ;
    [self.navigationController pushViewController:vc animated:YES ] ;
}
@end

/*
 #define              定义一个预处理宏
 #undef               取消宏的定义
 #include            包含文件命令
 #include_next   与#include相似, 但它有着特殊的用途
 #if                      编译预处理中的条件命令, 相当于C语法中的if语句
 #ifdef                判断某个宏是否被定义, 若已定义, 执行随后的语句
 #ifndef             与#ifdef相反, 判断某个宏是否未被定义
 #elif                  若#if, #ifdef, #ifndef或前面的#elif条件不满足, 则执行#elif之后的语句, 相当于C语法中的else-if
 #else                与#if, #ifdef, #ifndef对应, 若这些条件不满足, 则执行#else之后的语句, 相当于C语法中的else
 #endif              #if, #ifdef, #ifndef这些条件命令的结束标志.
 defined            与#if, #elif配合使用, 判断某个宏是否被定义
 #line                标志该语句所在的行号
 #                      将宏参数替代为以参数值为内容的字符窜常量
 ##                   将两个相邻的标记(token)连接为一个单独的标记
 #pragma        说明编译器信息#warning       显示编译警告信息
 #error            显示编译错误信息
 */
