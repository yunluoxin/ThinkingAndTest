//
//  GestureUnlockView.h
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/9/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

/**
    3种方案解决大于10个数以后的密码或者说内部码核对问题:
 
    a. 把原来的0-9，输出成00，01，...,09两位数的，这样就支持10x10宫格的解锁了
    b. 定义一长串的字符串str，对UIView扩张一个属性tagString，第一个按钮就对应str的第一个字符串（用charAt）,从而输出，理论应该支持0-9，a-z，A—Z,等多个ASCII合并，你能定义多少长串不同的，就可以弄相应格子数
    c. 代理对外界输出的时候，不输出字符串，而是输出一个NSString数组，这样就可以支持n个宫格的比对。
 
    推荐使用方案a，可以根据相应的方案自行修改代理方法。
 */

#import <UIKit/UIKit.h>
@class GestureUnlockView ;

@protocol GestureUnlockViewDelegate <NSObject>
@optional
//对于用户输入input，判断是否正确，正确返回YES，错误返回NO
- (BOOL)gestureUnlockView:(GestureUnlockView *)view isRightWithReceivedInput:(NSString *)input ;

@end

@interface GestureUnlockView : UIView

@property (nonatomic, assign) NSInteger rowNumber ;
@property (nonatomic, assign) NSInteger colNumber ;

@property (nonatomic, strong) UIImage *normalImage ;
@property (nonatomic, strong) UIImage *selectedImage ;

@property (nonatomic, strong) UIColor *lineColor ;
@property (nonatomic, strong) UIColor *lineColorWhenWrong ;

@property (nonatomic, assign) CGFloat spacing ;

@property (nonatomic, weak) id<GestureUnlockViewDelegate> delegate ;
@end
