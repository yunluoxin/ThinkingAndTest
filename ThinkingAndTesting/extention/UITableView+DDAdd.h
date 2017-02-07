//
//  UITableView+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (DDAdd)

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation ;

- (void)deselectRow:(NSUInteger)row inSection:(NSUInteger)section animated:(BOOL)animated ;

/**
 清除所有选中的行
 @warning 如果行数比较多，且需要动画，切记放在begin/end里面执行
 @param animated 是否动画清除的过程
 */
- (void)clearSelectedRowsAnimated:(BOOL)animated ;

/**
 全选>>>选中所有行
 @warning 如果行数比较多，且需要动画，切记放在begin/end里面执行
 @param animated 是否动画
 */
- (void)selectAllRowsAnimated:(BOOL)animated ;
@end

NS_ASSUME_NONNULL_END
