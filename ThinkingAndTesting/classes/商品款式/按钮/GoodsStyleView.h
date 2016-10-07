//
//  GoodsStyleView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsStyleView : UIView

@property (nonatomic, copy)void (^whenStyleBtnClicked)(NSString *);
/**
 *  创建一个View
 *
 *  @param title 左边的title名称
 *  @param dic   右边的数组
 *  @param code  当前选中的code
 */
- (instancetype)initWithTitle:(NSString *)title andDictionary:(NSDictionary *)dic andSeletedCode:(NSString *)code;

/**
 *  计算整个View的高度
 *
 */
+ (CGFloat)calcuateHeight:(NSDictionary *)dic ;
@end
