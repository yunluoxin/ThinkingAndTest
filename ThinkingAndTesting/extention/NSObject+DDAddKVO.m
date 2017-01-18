//
//  NSObject+DDAddKVO.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSObject+DDAddKVO.h"

DDSYNTH_DUMMY_CLASS(NSObject_DDAddKVO)

/**
 *  在.m文件中， block参数里面，可以用__weak修饰，但是.h文件中不可以。。从提示错误（说在mrc文件中不能用__weak reference）看，如果非要在.h文件中写并且一定声明成weak的，只好改成__unsafe_unretained
    
    typedef void (^Block)(__unsafe_unretained id obj, id newValue) ;
*/


/**
    KVO block的目标内部类
 */
@interface _DDAddNSObjectKVOTarget : NSObject

@property (nonatomic, copy) void (^block)( __weak id obj, id oldValue,  id newValue) ;

@end

@implementation _DDAddNSObjectKVOTarget

- (instancetype)initWithBlock:(void (^)(__weak id obj, id oldValue, id newValue)) block
{
    self = super.init ;
    if(!self) return nil ;
    self.block = block ;
    return self ;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString * ,id> *)change context:(void *)context
{
    if(keyPath == nil) return ;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_0
    BOOL isPrior = change[NSKeyValueChangeNotificationIsPriorKey] ;
    if(isPrior) return ;
    
    NSInteger kind = [change[NSKeyValueChangeKindKey] integerValue] ;
    if (kind != NSKeyValueChangeSetting) return ;
#endif//只有在Xcode8.0以上才有的key
    
    id oldValue = change[NSKeyValueChangeOldKey] ;
    
    id newValue = change[NSKeyValueChangeNewKey] ;
    
    self.block(object, oldValue, newValue) ;
}

@end

@implementation NSObject (DDAddKVO)

- (void)addObserverForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldValue, id newValue))block
{
    if(!keyPath) return ;
    
    NSMutableArray * arrayM = [[self _dd_addNSObjectKVODictionaries] objectForKey:keyPath] ;
    if (!arrayM) {
        arrayM = @[].mutableCopy ;
        [[self _dd_addNSObjectKVODictionaries] setObject:arrayM forKey:keyPath] ;
    }
    
    _DDAddNSObjectKVOTarget * target = [[_DDAddNSObjectKVOTarget alloc] initWithBlock:block] ;
    [arrayM addObject:target] ;
    
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL ] ;
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath
{
    if(!keyPath) return ;
    
    NSMutableArray * arrayM = [[self _dd_addNSObjectKVODictionaries] objectForKey:keyPath] ;
    if(!arrayM) return ;
    
    [arrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath] ;
    }] ;
    
    //记得移除内部对象
    [arrayM removeAllObjects] ;
}


- (void)removeAllObserverBlocks
{
    NSMutableDictionary * dicM = [self _dd_addNSObjectKVODictionaries] ;
    [dicM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray * arrayM, BOOL * _Nonnull stop) {
        [arrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:key] ;
        }] ;
    }] ;
    
    //移除所有的对象
    [dicM removeAllObjects] ;
}

#pragma mark - lazy load

- (NSMutableDictionary *)_dd_addNSObjectKVODictionaries
{
    static char kvo_key ;
    NSMutableDictionary * dicM = [self getAssociateValueByKey:&kvo_key] ;
    if (!dicM) {
        dicM = @{}.mutableCopy ;
        [self setAssociateValue:dicM forKey:&kvo_key] ;
    }
    return dicM ;
}
@end
