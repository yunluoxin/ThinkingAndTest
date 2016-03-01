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

@end
