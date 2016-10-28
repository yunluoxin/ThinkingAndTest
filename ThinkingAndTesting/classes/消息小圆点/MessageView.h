//
//  MessageView.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/27.
//  Copyright © 2016年 dadong. All rights reserved.
//

/**
 ———————————————————————————————————————————————————————————————————————————————————————————————
 ||                                                                                               ||
 ||  创建的小圆点，是基于调用initWithFrame:时候，传入的frame的frame.size.height作为小圆点里面数字Font的Size,||
 ||  进而限制整个的view大小的！                                                                       ||
 ||                                                                                               ||
 ———————————————————————————————————————————————————————————————————————————————————————————————
 */

#import <UIKit/UIKit.h>

@interface MessageView : UIImageView

/**
 *  消息数 
 *  > 99 自动变成 "99+"
 */
@property (nonatomic, copy) NSString * messageNum ;

/**
 *  消息数字的颜色，前景色
 */
@property (nonatomic, strong) UIColor * messageNumColor ;


/**
 *  消息的背景颜色
 */
@property (nonatomic, strong) UIColor * messageBackgroundColor ;

@end
