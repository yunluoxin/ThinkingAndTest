//
//  DatePickerViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
{
    __weak UITextField *_textFiled ;
}
@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    
    picker.frame = CGRectMake(0, 200, 300, 200);
    
    
    //设置位日期模式
    picker.datePickerMode = UIDatePickerModeDate ;
    
    //设置显示中文
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    //添加监控改变事件
    [picker addTarget:self action:@selector(pick:) forControlEvents:UIControlEventValueChanged];
    
    picker.minimumDate = [[NSDate alloc]initWithTimeIntervalSince1970:1];
    
    [self.view addSubview:picker];
    
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(0, 100, 200, 30);
    [self.view addSubview:textField];
    _textFiled = textField ;
    textField.enabled = NO ;
    textField.borderStyle = UITextBorderStyleLine ;
    textField.textColor = [UIColor redColor];
}


#pragma mark - 日期选择器改变的操作

- (void)pick:(UIDatePicker *)picker
{
    NSDate *selectedDate = picker.date ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init] ;
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:selectedDate];
    _textFiled.text = str ;
    
}

@end
