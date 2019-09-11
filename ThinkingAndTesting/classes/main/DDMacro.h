//
//  DDMacro.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#ifndef DDMacro_h
#define DDMacro_h

#ifndef DD_Deprecated_iOS
#define DD_Deprecated_iOS(description) __attribute__((deprecated(description)))
#endif

///
/// 简便的使用weak和strong
/// @warning strong(obj)必须在weak(obj)方法之后调用！也就是不能单独使用strong(obj)
///
#define weak(obj) autoreleasepool{} __typeof(obj) __weak weak##obj = obj
#define strong(obj) autoreleasepool{} __typeof(weak##obj) __strong strong##obj = weak##obj
#define weakify(object) try{} @finally{} __weak __typeof__(object) weak##_##object = object ;
#define strongify(object) try{} @finally{} __strong __typeof__(object) object = weak##_##object ;


/** 把数字(必须是基础类型的)转换成OC字符串 */
#define stringify(basicNumber) ([@(basicNumber) stringValue])

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


#import <mach/mach.h>

/**
 打印设备当前的内存信息
 @return 当前设备可用的内存(单位:MB)
 */
static inline double logDeviceMemoryInfo() {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn == KERN_SUCCESS) {
        //        DDLog( @" free: %u\nactive: %u\ninactive: %u\nwire: %u\nzero fill: %u\nreactivations: %u\npageins: %u\npageouts: %u\nfaults: %u\ncow_faults: %u\nlookups: %u\nhits: %u ",
        //              vmStats.free_count * vm_page_size,
        //              vmStats.active_count * vm_page_size,
        //              vmStats.inactive_count * vm_page_size,
        //              vmStats.wire_count * vm_page_size,
        //              vmStats.zero_fill_count * vm_page_size,
        //              vmStats.reactivations * vm_page_size,
        //              vmStats.pageins * vm_page_size,
        //              vmStats.pageouts * vm_page_size,
        //              vmStats.faults,
        //              vmStats.cow_faults,
        //              vmStats.lookups,
        //              vmStats.hits
        //              );
        double memory = vmStats.free_count * vm_page_size / (1024.0 * 1024.0);
        DDLog(@"Device available memory:%.3f", memory);
        return memory;
    }
    
    DDLog(@"%s", mach_error_string(kernReturn));
    return 0;
}

/**
 打印当前app的内存使用信息
 @return app已经使用的内存量(单位:MB)
 */
static inline double logAppMemoryInfo() {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn =task_info(mach_task_self(),
                                        TASK_BASIC_INFO,
                                        (task_info_t)&taskInfo,
                                        &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        DDLog(@"%s", mach_error_string(kernReturn));
        return 0;
    }
    
    double memory = taskInfo.resident_size / (1024.0 * 1024.0);
    DDLog(@"Used memory:%.3f", memory);
    return memory;
}


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


///
///     动态合成一个属性，主要用在分类中，进行属性的添加
//      @param policy:  COPY, RETAIN, ASSIGN, COPY_NOATOMIC, RETAIN_NOATOMIC
//      @warning #import <objc/runtime.h>, 必须导入<objc/runtime.h>
//
//      用法:
//      @interface xxx : NSObject
//          @property (nonatomic, strong) UIColor * myColor ;
//      @end
//      @implementation xxx
//          DD_DYNAMIC_PROPERTY_TYPE(UIColor *, myColor, setMyColor, RETAIN_NONATOMIC)   (记得不要漏了类型后的*号）
//      @end
///
#ifndef DD_DYNAMIC_PROPERTY_TYPE
#define DD_DYNAMIC_PROPERTY_TYPE(_type_, _getter_, _setter_, _policy_)\
- (void)_setter_ : (_type_)object{\
    [self willChangeValueForKey:@#_getter_] ;\
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _policy_ ) ; \
    [self didChangeValueForKey:@#_getter_] ; \
}\
- (_type_)_getter_{\
    return objc_getAssociatedObject(self, @selector(_setter_:)) ;\
}
#endif

///     动态合成一个c语言类型的属性，用法如上
#ifndef DD_DYNAMIC_PROPERTY_CTYPE
#define DD_DYNAMIC_PROPERTY_CTYPE(_type_, _getter_, _setter_)\
- (void)_setter_ : (_type_)cValue{\
    [self willChangeValueForKey:@#_getter_] ;\
    NSValue * value = [NSValue value:&cValue withObjCType:@encode(_type_)] ; \
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN) ; \
    [self didChangeValueForKey:@#_getter_] ; \
}\
- (_type_)_getter_{\
    NSValue * value = objc_getAssociatedObject(self, @selector(_setter_:)) ;\
    _type_ cValue = {0} ; \
    [value getValue:&cValue]; \
    return cValue ; \
}
#endif


/**
 方便计时的宏定义，把代码写在TIK 和 TOCK之间，即可统计运行时间
 
 @example
         TIK(1);
         NSArray *i1 = items.reverse;    // 0.000940s
         TOCK(1);
 
         TIK(2);
         NSArray *i2 = items.reverse2;   // 0.003287s
         TOCK(2);
 */
#ifdef DEBUG
#define TIK(id) \
double tik_start_##id##_ = CFAbsoluteTimeGetCurrent()
#define TOCK(id) \
DDLog(@"Clock(%s) cost %fs", #id, CFAbsoluteTimeGetCurrent() - tik_start_##id##_)
#else
#define TIK
#define TOCK
#endif

#import "DDNotifications.h"

#ifdef DEBUG
#import "FuckLogs.h"
#define TempString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#undef NSLog
#define NSLog(FORMAT, ...) do{ \
    if (![FuckLogs areYouNeedToFuckLogs]) { \
        printf(" %s 第%d行: %s\n\n", [TempString UTF8String] ,__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]); \
    } \
}while(0);
#else
#define NSLog(FORMAT, ...)
#endif



#ifdef DEBUG // 开发环境
#define DDAssert(condition, desc, ...) do { \
    if (condition) break; \
    NSString *r = [NSString stringWithFormat:desc, ##__VA_ARGS__]; \
    NSString *cond = @#condition; \
    @throw [NSException exceptionWithName:@"DDAssertError" reason:r userInfo:@{@"condition":cond ? : @""}]; \
}while(0);
#else        // 正式或者自动打包的
#define DDAssert(condition, desc, ...) do { \
    if (condition) break; \
    NSString *reason = [NSString stringWithFormat:desc, ##__VA_ARGS__]; \
    NSString *cond = @#condition; \
    DDLog(@"condition: %@, reason:%@", cond, reason);\
} while (0);
#endif

#endif /* DDMacro_h */
