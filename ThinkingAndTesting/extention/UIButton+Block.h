//
//  UIButton+Block.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block)(UIButton *button);

@interface UIButton (Block)
+ (instancetype)buttonWithBlock:(block)target ;
@end
