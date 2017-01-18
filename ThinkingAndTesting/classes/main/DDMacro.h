//
//  DDMacro.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#ifndef DDMacro_h
#define DDMacro_h

/**
 为了使用纯Category文件时候，不需要在工程里面加 -all_load 或者 -force_load参数, 在Category的.m文件中生成一个虚拟的类来让系统加载

 @param _name_ 类名：建议写成 原来类名_Category名，
                如  NSObject(Method)分类，可以写成DDSYN_DUMMY_CLASS(NSObject_Method)
 */
#ifndef DDSYNTH_DUMMY_CLASS
#define DDSYNTH_DUMMY_CLASS(_name_) \
@interface  dummy_class_##_name_ : NSObject @end \
@implementation dummy_class_##_name_ @end
#endif


#import <pthread.h>


/**
    保证肯定要在主线程运行的程序！另外，防止在主线程中又syn_main造成死锁。
 */
static inline void dd_safe_syn_main(dispatch_block_t block){
    if (pthread_main_np())
    {
        block() ;
    }else{
        dispatch_sync(dispatch_get_main_queue(), block) ;
    }
}

static inline void dd_safe_asyn_main(dispatch_block_t block){
    if(pthread_main_np()) block() ;
    dispatch_async(dispatch_get_main_queue(), block) ;
}


///================================================================
///* 超出变量的作用域后自动清理的 宏 */
///================================================================

#define ContactAB(A,B) A##B
//定义一个临时生成的block的类型
typedef void (^_Clean_Temp_Block_)();


//执行清理操作的函数，实质上执行传入的block
// void(^block)(void)的指针是void(^*block)(void)
static inline void FinallyCleanUp(__strong _Clean_Temp_Block_ *block){
    (*block)() ;
}

#define onExit \
try {} @finally {} \
__strong _Clean_Temp_Block_ ContactAB(_clean_temp_block_,__LINE__) __attribute__((cleanup(FinallyCleanUp),unused)) = ^()

///================================================================

#endif /* DDMacro_h */
