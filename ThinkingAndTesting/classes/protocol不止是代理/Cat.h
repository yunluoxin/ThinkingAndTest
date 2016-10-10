//
//  Cat.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"
@interface Cat : Animal
{
    @private
    NSString *_privateVar ;
}

@property (nonatomic, strong, readonly) NSString * readOnlyString ;

- (void)test ;

@end
