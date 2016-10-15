//
//  NormalView.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NormalView.h"
@interface NormalView()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField ;

@end

@implementation NormalView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UITextField *textFiled = [UITextField new] ;
        _textField = textFiled ;
        [self addSubview:textFiled] ;
        textFiled.delegate = self ;
        textFiled.returnKeyType = UIReturnKeyDone ;
    }
    return self ;
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.whenOpearte) {
        //自行设置一个和外面通信的标识，比如keyboard代表所有的键盘处理事件
        self.whenOpearte(textField,@"keyboard",nil);
    }
    
    return YES ;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //利用plist里填写的正则，自动进行简单的合法性填写验证
    if (self.item.extra) {
        FormItemExtra *extra = self.item.extra ;
        if (extra.pattern == nil) {
            NSLog(@"想要验证%@却没有写正则",self.item.propertyName) ;
            return ;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",extra.pattern] ;
        BOOL result = [predicate evaluateWithObject:textField.text] ;
        if (!result) {
            NSLog(@"输入有问题---%@",extra.tip) ;
        }else{
            self.item.obj = textField.text ;
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES] ;
    return YES ;
}


#pragma mark - getter and setter

- (void)setItem:(FormItem *)item
{
    _item = item ;
    
    if ([item.obj isKindOfClass:[NSString class]] && item.obj) {
        self.textField.text = [NSString stringWithFormat:@"%@",item.obj] ;
    }
    
    FormItemExtra *extra = item.extra ;
    self.textField.placeholder = extra.placeholder ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    self.textField.frame = CGRectMake(15, 8 , self.dd_width, self.dd_height - 16) ;
}
@end
