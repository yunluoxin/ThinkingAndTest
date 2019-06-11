//
//  DDLinkedDictionary.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/6/3.
//  Copyright © 2019 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDLinkedDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType> {
    NSMutableArray<KeyType> *_orderKeys;     /**< 存储有序的key的数组(手动去重后的) */
    NSMutableDictionary<KeyType, ObjectType> *_interal;
}

@end

NS_ASSUME_NONNULL_END
