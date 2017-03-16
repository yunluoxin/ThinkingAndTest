//
//  ArrayKVO_Test.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/15.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ArrayKVO_Test.h"

@interface ArrayKVO_Test ()
/**
 *  <#note#>
 */
@property (atomic, strong, readonly)NSMutableArray * arrayM ;
@end

@implementation ArrayKVO_Test

- (instancetype)init
{
    if (self = [super init]) {
        _arrayM = @[].mutableCopy ;
    }
    return self ;
}

- (NSArray *)array
{
    return [self.arrayM copy] ;
}

- (void)testAddData
{
    assert(self.arrayM) ;
    
    @synchronized (self.array) {
        NSNumber * number = @(arc4random_uniform(100)) ;
        DDLog(@"%@",number) ;
        
        if ([self.arrayM indexOfObject:number] != NSNotFound) {
            return ;
        }
        
        NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:self.arrayM.count] ;

//        NSInteger old = 0 ;
//        if (self.arrayM.count > 0) {
//            old = self.arrayM.count - 1 ;
//        }
//        NSIndexSet * oldIndexes = [NSIndexSet indexSetWithIndex:old] ;
//        如果加了这个oldIndexes,并且放在willChange里面，didChange还是放indexes，===> 发现observer那边接受到的都是这个oldIndexes指向的值，但是notification里面，不包含oldKey值
        
        [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"array"] ;
        
        ///
        /// Try to add two objects, but just the first object is notificated to observers. Because indexes point to the first.
        /// So if we use `NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:self.arrayM.count + 1]` , then the second object is notificated.
        ///
        [self.arrayM addObject:@(number.integerValue + 1)] ;
        
        [self.arrayM addObject:number] ;

        [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"array"] ;
    }
}


@end
