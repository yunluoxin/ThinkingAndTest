//
//  DDUtils+HookInstance.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/24.
//  Copyright © 2017年 dadong. All rights reserved.
//

/// ====================================================================================================
/// `HookInstance`和`SwizzleMethod`的区别:
/// hookInstance利用的是生成的类似匿名子类进行swizzle,影响的只有你想要hook的实例对象，从而把造成的影响范围弄到最小!
/// 而一旦对类直接swizzle, 会影响所有此类生成的对象!
/// ====================================================================================================




#import "DDUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDUtils (HookInstance)

/**
    eg. 
        - (void)test{} ;
        - (void)hook_test{ 
            NSLog(@"hook successfully");
            [self hook_test];
        } ;
        
 调用时候，直接写 
 
        [DDUtils hookInstance:xxx originalSel:@selector(test) withTargetSel:@selector(hook_test)] ;
    
    在hook方法里面继续调用自身，即可实现回调原来方法，则此时的Hook方法就类似AOP功能了.
    [self hook_test] 放置的位置，可决定AOP的时机.
 */
/**
 对某个实例对象的方法进行互调， 可以实现对象级AOP
 @param instance 实例对象
 @param originalSel 原来方法名
 @param targetSel 目标方法名
 @return 是否调换成功. 同一个方法无法二次调换
 */
+ (BOOL)hookInstance:(__nonnull id)instance
         originalSel:(SEL)originalSel
       withTargetSel:(SEL)targetSel ;

/**
 打印一个类所有的实例方法列表（不包括父类的)
 @clazz  要打印的类. Attenttion: 如果你传入的是一个类，则获得的是所有类方法
 @return 实例方法，不包括静态方法
 */
+ (NSArray<NSString *> *)allInstanceMethodNames:(Class)clazz ;

/**
 全部的实例变量列表
 @param clazz 要打印的类
 @return ivar的字符串列表
 */
+ (NSArray<NSString *> *)allIVarsOfClass:(Class)clazz ;

/**
 实例的properties列表，每个property是一个string,其中的name和attributes用逗号隔开。格式如 "T, xx2"
 @param clazz 要打印的类
 @return property列表
 */
+ (NSArray<NSString *> *)allPropertiesOfClass:(Class)clazz ;

/**
 检测某个对象是否包括某个方法，和系统的 `- respondeToSelector:`，`+ instanceRespondeToSelector`不一样，此方法只搜索自己的，不搜索父类的
 @param instance 某个实例对象. Attenttion: 如果你传入的是一个类，则获得的是所有类方法是否包含该方法!
 @param selector 选择子
 @return 是否包含某个方法
 */
+ (BOOL)instances:(id)instance hasSelector:(SEL)selector ;

@end

NS_ASSUME_NONNULL_END
