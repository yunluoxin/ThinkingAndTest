//
//  DDBorderButton.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//
//  >>>>>>>>>>>>>>>>>>>>>自定义的边框按钮>>>>>>>>>>>>>>>>>>>>>>>>>>>

#import <UIKit/UIKit.h>

@interface DDBorderButton : UIButton
/**
 *  边框颜色
 */
@property (nonatomic, strong)UIColor *borderColor ;
/**
 *  边框宽度
 */
@property (nonatomic, assign)CGFloat borderWidth ;
@end
