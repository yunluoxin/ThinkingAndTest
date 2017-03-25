//
//  NSObject+KVO_Implementation.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/24.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSObject+KVO_Implementation.h"

#import <objc/runtime.h>
#import <objc/message.h>

#ifndef DDLog
#define DDLog(...) NSLog(__VA_ARGS__)
#endif

@interface _DDKVOInternalObserverInfo : NSObject
@property (nonatomic, weak)id         observer ;
@property (nonatomic, copy)DDKVOCallBack block ;
@property (nonatomic, copy)NSString  * keyPath ;
@end

@implementation _DDKVOInternalObserverInfo
- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath andBlock:(DDKVOCallBack)block
{
    if (self = [super init]) {
        self.observer = observer ;
        self.keyPath = keyPath ;
        self.block = block ;
    }
    return self ;
}
@end


static NSString * const DDKVONewSubclassNamePrefix = @"_DDKVOSubclass_" ;
static char DDKVOObserverInfosKey ;

@implementation NSObject (KVO_Implementation)

#pragma mark - public api

- (void)dd_addObserver:(id)observer forKeyPath:(NSString *)keyPath withBlock:(void (^)(NSString *, id, id, id))block
{
    NSAssert(observer && keyPath && block , @"observer, keyPath and block are all can'be nil ! Otherwise it's not meaningful at all. ") ;
    
    DDLog(@"%@",methodList(object_getClass(self)) );
//    DDLog(@"%p",object_getClass(self)) ;
//    DDLog(@"%p",object_getClass(object_getClass(self)));
    
    // generate new subclass of this class
    Class clazz = object_getClass(self) ;
    
    /// 1. if no setter in class, it means user provide wrong key.
    SEL             setter = setterFromGetter(NSSelectorFromString(keyPath)) ;
    Method  originalMethod = class_getInstanceMethod(clazz, setter) ;
    if (!originalMethod) {
        NSAssert(NO, @"setter isn't exist!!!") ;
    }
    
    // 2. check if this class has alreay been subclass
    if (![NSStringFromClass(clazz) hasPrefix:DDKVONewSubclassNamePrefix]) {
        
        /// generate new class
        Class newClass = [self _dd_makeKVOSubClass] ;
        
        /// replace isa point to newClass
        object_setClass(self, newClass) ;
    }
    
    
    // 3. add setter to new class. (we have to write this, because the new kvosubclass may have create for other observed keyPath!!!  but this setter didn't)
    if (![self _dd_hasSelector:setter]) {
        ///
        /// @warning 这里之前一直错！因为这时候isa指针已经变了！不能再用刚才的缓存的局部变量。。。clazz, 必须重新用object_getClass(self)获取
        ///
        class_addMethod(object_getClass(self), setter, (IMP)_dd_setter_implementation, method_getTypeEncoding(originalMethod)) ;
        
    }
    
    
    // 4. save observer info
    
    NSMutableArray *infos = objc_getAssociatedObject(self, &DDKVOObserverInfosKey) ;
    if (!infos) {
        infos = @[].mutableCopy ;
        objc_setAssociatedObject(self, &DDKVOObserverInfosKey, infos, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
    }
    _DDKVOInternalObserverInfo * info = [[_DDKVOInternalObserverInfo alloc] initWithObserver:observer keyPath:keyPath andBlock:block] ;
    [infos addObject:info] ;
}

- (void)dd_removeObserver:(id)observer forKeyPath:(NSString *)keyPath
{
    if (!observer || !keyPath) return ;
    
    NSMutableArray *infoArray = objc_getAssociatedObject(self, &DDKVOObserverInfosKey) ;
    NSEnumerator<_DDKVOInternalObserverInfo *> * infos = infoArray.objectEnumerator ;
    _DDKVOInternalObserverInfo * info = nil ;
    while (info = [infos nextObject]) {
        if ([info.keyPath isEqualToString:keyPath] && [info.observer isEqual:observer]) {
            [infoArray removeObject:info] ;
//            break ;
        }
    }
}



#pragma mark - private

- (Class)_dd_makeKVOSubClass
{
    Class       clazz       = object_getClass(self) ;
    NSString * newClassName = [DDKVONewSubclassNamePrefix stringByAppendingString:NSStringFromClass(clazz)] ;
    Class      newClass     = NSClassFromString(newClassName) ;
    if (newClass) {
        // in case that there is already same class exist. we don't need to create.
        return newClass ;
    }
    
    newClass = objc_allocateClassPair(clazz, newClassName.UTF8String, 0) ;
    
    const char * types = method_getTypeEncoding(class_getInstanceMethod(clazz, @selector(class))) ;
    
    // override setter method
    class_addMethod(newClass, @selector(class), (IMP)_dd_kvo_class, types) ;
    
    
    // register new class
    objc_registerClassPair(newClass) ;
    
    return newClass ;
}

- (BOOL)_dd_hasSelector:(SEL)selector
{
    // get isa showing class
    Class clazz = object_getClass(self) ;
    
    unsigned int count = 0;
    Method * methodList = class_copyMethodList(clazz, &count) ;
    
    for (unsigned int i = 0; i < count; i ++) {
        SEL temp = method_getName(methodList[i]) ;
        if (temp == selector) {
            /// important!! Due to use this writting style, not use flag and finally judge, we need to remember free varible.
            free(methodList) ;
            return YES ;
        }
    }
    
    free(methodList) ;
    return NO ;
}


#pragma mark - override methods

Class _dd_kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self)) ;
}

void _dd_setter_implementation(id self, SEL _cmd, id newValue)
{
    SEL getter = getterFromSetter(_cmd) ;
    if (!getter) {
        DDLog(@"getter isn't exist, we can't get newValue") ;
        return ;
    }
    
    NSString * keyPath = NSStringFromSelector(getter) ;
    
    // 1. get old value before set new value !!!
    id oldValue = [self valueForKey:keyPath] ;
    
    
    // 2. set new value, by invoking superclass's method
    Class superClass = class_getSuperclass(object_getClass(self)) ;
    
    /// cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper ;
    struct objc_super objcSuper ;
    objcSuper.receiver = self ;
    objcSuper.super_class = superClass ;
    /// invoke
    objc_msgSendSuperCasted(&objcSuper,_cmd, newValue) ;
    
    
    // 3. notify all observers
    NSMutableArray *infos = objc_getAssociatedObject(self, &DDKVOObserverInfosKey) ;
    NSEnumerator * enumerator = infos.objectEnumerator ;
    _DDKVOInternalObserverInfo * info = nil ;
    while (info = [enumerator nextObject]) {
        if ([keyPath isEqualToString:info.keyPath]) {
            if (info.observer) {
                info.block(keyPath, info.observer, oldValue, newValue) ;
            }else{
                /// if this observer isn't exist now, remove it by the way.
                [infos removeObject:info] ;
            }
        }
    }
}


#pragma mark - C methods 

static SEL getterFromSetter(SEL setter){
    NSString * setterString = NSStringFromSelector(setter) ;
    NSString * truckedString = [setterString substringWithRange:NSMakeRange(3, setterString.length - 4)] ;
    NSString * getterString = truckedString.lowercaseString ;
    return NSSelectorFromString(getterString) ;
}

static SEL setterFromGetter(SEL getter){
    NSString * setterString = [NSString stringWithFormat:@"set%@:",NSStringFromSelector(getter).capitalizedString] ;
    return NSSelectorFromString(setterString) ;
}


#pragma mark - Test methods, removable.
static NSArray* methodList(Class clazz){
    unsigned int count = 0 ;
    NSMutableArray * list = @[].mutableCopy ;
    Method * methodList = class_copyMethodList(object_getClass(clazz), &count) ;
    for (int i = 0; i < count; i ++) {
        SEL sel = method_getName(methodList[i]) ;
        [list addObject:NSStringFromSelector(sel)] ;
    }
    free(methodList) ;
    return list ;
}

@end
