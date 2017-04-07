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
//          DD_DYNAMIC_PROPERTY_TYPE(UIColor *, myColor, setMyColor, RETAIN_NOATOMIC)   (记得不要漏了类型后的*号）
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

#endif /* DDMacro_h */
