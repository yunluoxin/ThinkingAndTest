//
//  DDProtocolDispatcher.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/21.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDProtocolDispatcher.h"
#import <objc/runtime.h>


@interface _DDProtocolDispatcherInternalWeakObject : NSObject

/**
 *  要包装的weak 对象
 */
@property (nonatomic, weak) id weakObject ;

@end

@implementation _DDProtocolDispatcherInternalWeakObject @end


@interface DDProtocolDispatcher ()

/**
 *  协议
 */
@property (nonatomic, strong)Protocol * protocol ;

/**
 *  注册的实现者
 */
@property (nonatomic, strong)NSMutableArray * implementors ;
@end

@implementation DDProtocolDispatcher

+ (instancetype)dispatchProtocol:(Protocol *)protocol toImplementors:(NSArray *)implementors
{
    NSAssert(protocol != nil , @"protocol 不能为空") ;
    
    NSAssert(implementors != nil , @"implementors 不能为空") ;
    
    return [[self alloc] initWithProtocol:protocol implementors:implementors] ;
}

- (instancetype)initWithProtocol:(Protocol *)protocol implementors:(NSArray *)implementors
{
    if (self = [super init]) {
        
        self.protocol = protocol ;
        
        self.implementors = @[].mutableCopy ;
        
        for (int i = 0 ; i < implementors.count ; i ++) {
            
            /// wrap object
            _DDProtocolDispatcherInternalWeakObject * wrapper = [_DDProtocolDispatcherInternalWeakObject new] ;
            wrapper.weakObject = implementors[i] ;
            [self.implementors addObject:wrapper ] ;
            
            
            // Good idea !
            // important!!!  Bind self to the implementors ! Not bind implementors to self .
            // once implementors are all dealloc, it will dealloc ! Right row it have no effect .
            
            // fix. This key can't use `_cmd`, because some implementors may be included in two dispatchers ,and then the former which use same key to store will be replaced by the later.
            // so thie associate key must be dynamic.
            objc_setAssociatedObject(implementors[i], &self, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
        }
        
        
    }
    
    return self ;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    // if this method is included in the protocol, recursive search obj to determine.
    if ([[self class] isProtocol:self.protocol containsSelector:aSelector]) {
        NSEnumerator * enumerator = [self.implementors objectEnumerator] ;
        
        _DDProtocolDispatcherInternalWeakObject * obj ;
        
        while (obj = [enumerator nextObject]) {
            if (obj.weakObject && [obj.weakObject respondsToSelector:aSelector]) {
                return YES ;
            }
        }
        return NO ;
    }
    
    return [super respondsToSelector:aSelector] ;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([[self class] isProtocol:self.protocol containsSelector:aSelector]) {
        NSMethodSignature * signature = [NSMethodSignature signatureWithObjCTypes:methodDescriptionInProtocol(self.protocol, aSelector).types];
        return signature ;
    }
    
    return [super methodSignatureForSelector:aSelector] ;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = anInvocation.selector ;
    
    if ([[self class] isProtocol:self.protocol containsSelector:aSelector]) {
        
        NSEnumerator * enumerator = [self.implementors objectEnumerator] ;
        
        _DDProtocolDispatcherInternalWeakObject * obj ;
        
        while (obj = [enumerator nextObject]) {
            if (obj.weakObject && [obj.weakObject respondsToSelector:aSelector]) {
//                [obj.weakObject performSelector:aSelector] ; // wrong!!!!!这里已经是转发了，不能再用这个了
                [anInvocation invokeWithTarget:obj.weakObject] ;
            }
        }
        return ;
    }
    
    [super forwardInvocation:anInvocation] ;
}


#pragma mark - utils

+ (BOOL)isProtocol:(Protocol *)protocol containsSelector:(SEL)selector
{
    if (methodDescriptionInProtocol(protocol, selector).types) {
        return YES ;
    }
    return NO ;
}

struct objc_method_description methodDescriptionInProtocol(Protocol * protocol, SEL selector)
{
    struct objc_method_description method_descrption = {NULL, NULL} ;
    
    method_descrption = protocol_getMethodDescription(protocol, selector, YES, YES) ;
    if (method_descrption.types) return method_descrption ;
    
    method_descrption = protocol_getMethodDescription(protocol, selector, NO, YES) ;
    if (method_descrption.types) return method_descrption ;
    
    method_descrption = protocol_getMethodDescription(protocol, selector, NO, NO) ;
    if (method_descrption.types) return method_descrption ;
    
    method_descrption = protocol_getMethodDescription(protocol, selector, YES, NO) ;
    
    return method_descrption ;
}

- (void)dealloc
{
    DDLog(@"protocol dispatcher dealloc ··· ") ;
}

@end
