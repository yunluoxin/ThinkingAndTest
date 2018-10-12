//
//  NSArray+DDAdd.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/12.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "NSArray+DDAdd.h"

@implementation NSArray (DDAdd)

- (NSArray *)reverse {
    if (self.count == 0) return self;
    
    NSMutableArray *newArr = self.mutableCopy;
    int i = 0;
    int j = (int)self.count - 1;
    while (i < j) {
        [newArr exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;
        j--;
    }
    return newArr.copy;
}

- (NSArray *)reverse2 {
    NSMutableArray *newArr = [NSMutableArray arrayWithCapacity:self.count];
    
    // 备注和没备注的写法几乎差不多，都是reverse方法快！
//    NSEnumerator *enumerator = self.reverseObjectEnumerator;
//    id obj = nil;
//    while ((obj = enumerator.nextObject) != nil) {
//        [newArr addObject:obj];
//    }
    for (NSInteger i = self.count - 1; i >= 0; i--) {
        [newArr addObject:self[i]];
    }
    return newArr.copy;
}
@end
