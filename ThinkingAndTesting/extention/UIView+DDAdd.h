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
 递归打印出当前视图的所有子视图，内部已经设置只在debug打印
 */
- (void)printSubviewsRecursively ;

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
- (void)addBlurEffectWithStyle:(UIBlurEffectStyle)style ;

/**
 移除模糊效果, 和 addBlurEffect 配套使用
 默认无动画
 */
- (void)removeBlurEffect ;
- (void)removeBlurEffectAnimated:(BOOL)animated ;
@end

typedef NS_ENUM(NSInteger, DDLineViewPosition){
    DDLineViewPositionTop ,
    DDLineViewPositionBottom ,
    DDLineViewPositionLeft ,
    DDLineViewPositionRight
};

@interface UIView (DD_CollapseAndRestore)

/**
 *  在折叠之前，保存视图显隐藏的状态
 */
@property (assign , nonatomic)BOOL dd_originalHidden ;

+ (void)collapseView:(UIView *)view ofConstraints:(NSArray <NSLayoutConstraint *> *)constranints ;

+ (void)restoreView :(UIView *)view ofConstraints:(NSArray <NSLayoutConstraint *> *)constranints ;

- (void)collapseOfConstraints:(NSArray <NSLayoutConstraint *> *)constranints ;
- (void)restoreOfConstraints :(NSArray <NSLayoutConstraint *> *)constranints ;

- (UIView *)addLineToPosition:(DDLineViewPosition)position
                  frontOffset:(CGFloat)frontOffset
                 behindOffset:(CGFloat)behindOffset ;

- (UIView *)addHorizontalLineAtTop:(BOOL)isAtTop ;
- (UIView *)addVerticalLineAtLeft:(BOOL)isAtLeft ;

@end


NS_ASSUME_NONNULL_END
