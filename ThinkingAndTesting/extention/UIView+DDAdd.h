//
//  UIView+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DDAdd)


/**
 对当前view进行截图，包含全部图层

 @return 生成的image对象
 */
- (nullable UIImage *)snapshotImage ;

- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates ;

- (nullable NSData  *)snapshotPDF ;


/**
 移除当前view的所有子视图
 */
- (void)removeAllSubViews ;


/**
 获取当前view所在的viewController,可能为空
 */
@property (nullable, nonatomic, readonly)UIViewController * viewController ;



#pragma mark - Effects

/**
 增加模糊效果,利用的是为当前view增加一个visualView
 @warning 执行一次增加操作，就要相对应的执行一次 -removeBlurEffect 才能消除
 */
- (void)addBlurEffect ;

/**
 移除模糊效果, 和 addBlurEffect 配套使用
 默认无动画
 */
- (void)removeBlurEffect ;
- (void)removeBlurEffectAnimated:(BOOL)animated ;
@end

NS_ASSUME_NONNULL_END