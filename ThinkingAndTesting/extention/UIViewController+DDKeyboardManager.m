//
//  UIViewController+DDKeyboardManager.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UIViewController+DDKeyboardManager.h"
#import <objc/runtime.h>

static char dd_shouldAutoHandleKeyboard ;
static UIToolbar * toolbar ;
@implementation UIViewController (DDKeyboardManager)

+ (void)load
{
    SEL originSels[] = {
                @selector(viewDidAppear:),
                @selector(viewDidDisappear:)
    } ;
    
    SEL swizzlingSels[] = {
        @selector(dd_keyboard_viewDidAppear:),
        @selector(dd_keyboard_viewDidDisappear:)
    } ;
    
    for (int i = 0 ; i < sizeof(originSels)/sizeof(SEL); i ++) {
        Method originMethod = class_getInstanceMethod(self, originSels[i]) ;
        Method swizzlingMethod = class_getInstanceMethod(self, swizzlingSels[i]) ;
        bool result = class_addMethod(self, originSels[i], method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod)) ;
        if (result) {
            IMP originImp = method_getImplementation(originMethod) ;
            if (originImp) {
                class_replaceMethod(self, swizzlingSels[i], originImp , method_getTypeEncoding(originMethod) );
            }else{
                class_replaceMethod(self, swizzlingSels[i], (IMP)case_for_exception, "v@:") ;   //this situation is almost not exist, due to this category is specially writed and used by yourself, not exchange any unknown methods .
            }
        }else{
            method_exchangeImplementations(originMethod, swizzlingMethod) ;
        }
    }
    
}

static void case_for_exception(id s,SEL _cmd){
    NSLog(@"%@ original selector -%@ not be implemented ",[s class], NSStringFromSelector(_cmd));
}

#pragma mark - 交换的方法
- (void)dd_keyboard_viewDidAppear:(BOOL)animated
{
    [self dd_keyboard_viewDidAppear:animated] ;
    if (self.shouldAutoHandleKeyboard) {
        [self dd_registerNotifications] ;
    }
}

- (void)dd_keyboard_viewDidDisappear:(BOOL)animated
{
    if (self.shouldAutoHandleKeyboard) {
        [self dd_unregisterNotifications] ;
    }
    [self dd_keyboard_viewDidDisappear:animated] ;
}


- (BOOL)shouldAutoHandleKeyboard
{
    return [objc_getAssociatedObject(self, &dd_shouldAutoHandleKeyboard) boolValue];
}

- (void)setShouldAutoHandleKeyboard:(BOOL)shouldAutoHandleKeyboard
{
    objc_setAssociatedObject(self, &dd_shouldAutoHandleKeyboard, @(shouldAutoHandleKeyboard), OBJC_ASSOCIATION_ASSIGN) ;
}

- (void)dd_registerNotifications
{
    //统一键盘处理
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dd_showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dd_hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)] ;
        CGFloat w = 40.0f ;
        CGFloat h = toolbar.bounds.size.height ;
        CGFloat x = toolbar.bounds.size.width - w ;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, w, h)] ;
        label.text = @"完成" ;
        label.font = [UIFont systemFontOfSize:14] ;
        label.textAlignment = NSTextAlignmentRight ;
        label.textColor = [UIColor blackColor] ;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dd_endEditing)] ;
        [label addGestureRecognizer:tap] ;
        label.userInteractionEnabled = YES ;
        UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithCustomView:label] ;
        UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] ;
        toolbar.items = @[left,done] ;
    });
    
    asyn_global(^{
        findAndAddToolbarForInputView(self.view) ;
    });
}

- (void)dd_endEditing
{
    [[self dd_currentEditView] endEditing:YES] ;
//    [self.view endEditing:YES] ;          //这两个速度哪个快，也是不知道
}

- (void)setDd_currentEditView:(UIView *)editView
{
    objc_setAssociatedObject(self, sel_getName(_cmd), editView, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

- (UIView *)dd_currentEditView
{
    return objc_getAssociatedObject(self, sel_getName(@selector(setDd_currentEditView:))) ;
}

static void findAndAddToolbarForInputView(UIView *view ){
    if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UISearchBar class]]) {
        UITextView *v = (UITextView *)view ;
        sync_main_safe(^{
            if (!v.inputAccessoryView) {
                v.inputAccessoryView = toolbar ;
            }
        });
        return ;
    }
    for (UIView *subView in view.subviews) {
        findAndAddToolbarForInputView(subView) ;
    }
}

static void findAndRemoveToolbarForInputView(UIView *view ){
    if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UISearchBar class]]) {
        UITextView *v = (UITextView *)view ;
        sync_main_safe(^{
            if (v.inputAccessoryView == toolbar) {
                v.inputAccessoryView = nil ;
            }
        });
        return ;
    }
    for (UIView *subView in view.subviews) {
        findAndRemoveToolbarForInputView(subView) ;
    }
}

- (void)dd_unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
    
    asyn_global(^{
        findAndRemoveToolbarForInputView(self.view) ;
    });
}

#pragma mark -

#pragma mark 键盘要出现
- (void)dd_showKeyboard:(NSNotification *)note
{
    UIView *view = [self.view findCurrentFirstResponder] ;
    
    [self setDd_currentEditView:view] ;//保存起来
    
    //````````````````inputAccessoryView只有在文本成为第一响应者，即弹框前设置有效！所以这里设置是不行的！`````````````````````
   
    CGRect rect = [view convertRect:view.bounds toView:self.view] ;
    CGFloat bottom = CGRectGetMaxY(rect) ;
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat top = CGRectGetMinY(frame);
    if (top < bottom) {
        self.view.transform = CGAffineTransformMakeTranslation(0, top - bottom);
    }
}

#pragma mark 键盘消失
- (void)dd_hideKeyboard:(NSNotification *)note
{
    [self setDd_currentEditView:nil] ;
    self.view.transform = CGAffineTransformIdentity ;
}



@end
