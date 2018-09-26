//
//  MultiAnonymousExtension.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/9/26.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "MultiAnonymousExtension.h"

@interface MultiAnonymousExtension ()

@property (nonatomic, assign)int age;

@end

@interface MultiAnonymousExtension ()

@property (nonatomic, strong)NSMutableArray *words;

@end

@implementation MultiAnonymousExtension

- (void)test {
    self.age = 5 ;
    
    self.words = @[@"H", @"E", @"L", @"L", @"O"].mutableCopy ;
}

- (void)print {
    NSLog(@"age: %d, items: %@", self.age, [self.words componentsJoinedByString:@""]) ;
}

@end

