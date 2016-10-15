//
//  NormalView.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormItem.h"

@interface NormalView : UIView <DDFormProtocol>

//底下两个都是重写DDFormProtocol里的东西， 不重写也可以，但是要自己定义相应名字的成员属性
@property (nonatomic, strong) FormItem * item ;
@property (nonatomic, copy ) void (^whenOpearte)(UIView * sender, NSString *eventName, FormItem * item) ;

@end
