//
//  UIView+DD.h
//  卡车妈妈
//
//  Created by 张小冬 on 15/12/17.
//  Copyright © 2015年 张小东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DD)
@property (nonatomic,strong)id data ;
//给view绑定的一个标签属性
@property (nonatomic,copy) NSString *tagString ;
- (void) dataDidChanged;

/**-------view的四个方位的快捷获取方法---------*/
@property (nonatomic, assign) CGFloat dd_height ;
@property (nonatomic, assign) CGFloat dd_width ;
@property (nonatomic, assign) CGFloat dd_left ;
@property (nonatomic, assign, readonly) CGFloat dd_right ;
@property (nonatomic, assign) CGFloat dd_top ;
@property (nonatomic, assign, readonly) CGFloat dd_bottom ;
@property (nonatomic, assign) CGPoint dd_center ;
/**----------------------------------------*/

/**
 *  找出当前view的视图层次下的，存在的第一响应者，若都没有则返回nil
 *
 *  @return 当前第一响应者
 */
- (UIView *) findCurrentFirstResponder ;

/**
 *  打印view的所有子类（不包括子类的子类）
 */
- (void)printSubviews ;
@end
