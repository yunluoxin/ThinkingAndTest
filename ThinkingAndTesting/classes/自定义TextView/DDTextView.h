//
//  DDTextView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTextView : UITextView
/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholder ;

/**
 *  占位文字的颜色
 */
@property (nonatomic, strong) UIColor *textColorOfPlaceholder ;

@end
