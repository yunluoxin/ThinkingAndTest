//
//  DDSearchBar.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/23.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDSearchBar ;

@protocol DDSearchBarDelegate <NSObject>
@optional
- (BOOL)searchBarShouldBeginEditing:(DDSearchBar *)searchBar;        // return NO to disallow editing.
- (void)searchBarDidBeginEditing:(DDSearchBar *)searchBar;           // became first responder
- (BOOL)searchBarShouldEndEditing:(DDSearchBar *)searchBar;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)searchBarDidEndEditing:(DDSearchBar *)searchBar ;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)searchBar:(DDSearchBar *)searchBar textDidChange:(NSString *)searchText ;   // called when text changes (including clear)
- (BOOL)searchBar:(DDSearchBar *)searchBar shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
- (BOOL)searchBarShouldClear:(DDSearchBar *)searchBar ;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)searchBarShouldReturn:(DDSearchBar *)searchBar ;            // called when 'return' key pressed. return NO to ignore.

- (void)searchBarCancelButtonClicked:(DDSearchBar *)searchBar ;
@end


@interface DDSearchBar : UIView

@property (nonatomic,   weak)id<DDSearchBarDelegate> delegate ;

@property (nonatomic,   copy)NSString   * placeholder ;
@property (nonatomic, strong)NSAttributedString * placeholderAttributedText ;
@property (nonatomic, strong)UIColor    * placeholderTextColor ;
@property (nonatomic, strong)UIFont     * placeholderTextFont ;


@property (nonatomic, strong)UIColor    * textColor ;
@property (nonatomic, strong)UIFont     * textFont ;
@property (nonatomic,   copy)NSString   * text ;
@property (nonatomic, strong)NSAttributedString   * attributedText ;

/**
 *  是否显示·取消·按钮
 */
@property (assign, nonatomic)BOOL showCancelButton ;
/**
 `取消`按钮，可以进行一些属性设置
 */
@property (strong, nonatomic, readonly)UIButton * cancelButton ;


/**
 *  设置输入框的背景颜色 （不是整个控件，整个控件请直接设置bar.backgroundColor）
 */
@property (nonatomic, strong)UIColor    * barTintColor;

/**
 *  输入框左边的图片
 */
@property (nonatomic, strong)UIImage    * searchBarLeftImage ;

/**
 *  输入框的圆角半径
 */
@property (assign, nonatomic)CGFloat   textFieldCornerRadius ;

/**
 *  指针颜色
 */
@property (nonatomic, strong)UIColor    * cursorColor ;

/**
 *  输入的指针偏移量
 *  @warning 如果存在左边的图片，则连同图片一起向右移动了。。
 */
@property (assign , nonatomic)CGFloat     cursorHorizontalOffset ;
@end
