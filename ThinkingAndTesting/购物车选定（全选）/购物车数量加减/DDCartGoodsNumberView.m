//
//  DDCartGoodsNumberView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/2.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDCartGoodsNumberView.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface DDCartGoodsNumberView()<UITextFieldDelegate>

@property (nonatomic, strong) UIToolbar *toolbar ;

@property (nonatomic, weak) UITextField *numberField ;
@property (nonatomic, weak) UIButton *minusBtn ;
@property (nonatomic, weak) UIButton *plusBtn ;
@end

@implementation DDCartGoodsNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.minNumber = 1 ;
        
        [self createView];
    }
    return self ;
}



- (void)createView
{
    UIButton *minusBtn = [UIButton new];
    _minusBtn = minusBtn ;
    [self addSubview:minusBtn];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [minusBtn addTarget:self action:@selector(DidMinusBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    UITextField *numberField = [UITextField new];
    _numberField = numberField ;
    [self addSubview:numberField];
    numberField.textAlignment = NSTextAlignmentCenter ;
    numberField.textColor = [UIColor blackColor];
    numberField.font = [UIFont systemFontOfSize:13];
    numberField.delegate = self ;
    numberField.text = [NSString stringWithFormat:@"%ld",self.minNumber];
    numberField.keyboardType = UIKeyboardTypeNumberPad ;
    
    
    UIButton *plusBtn = [UIButton new];
    _plusBtn = plusBtn ;
    [self addSubview:plusBtn];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [plusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [plusBtn addTarget:self action:@selector(DidPlusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [minusBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(44);
        make.height.equalTo(minusBtn.width);
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [numberField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(minusBtn.right).offset(8);
        make.right.equalTo(plusBtn.left).offset(- 8);
        make.centerY.equalTo(minusBtn);
        make.height.equalTo(minusBtn.height);
    }];
    
    
    [plusBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(minusBtn);
        make.centerY.equalTo(minusBtn) ;
        make.right.equalTo(self);
    }];
}


#pragma mark - 加、减点击事件
- (void)DidMinusBtnClicked
{
    NSInteger number = self.numberField.text.integerValue ;
    
    if ([self isNumberAvailable:(number - 1)]) {
        self.currentNumber = number - 1 ;
    }
}

- (void)DidPlusBtnClicked
{
    NSInteger number = self.numberField.text.integerValue ;
    if ([self isNumberAvailable:(number + 1)]) {
        self.currentNumber = number + 1 ;
    }
}

#pragma mark - UITextField代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES ;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = self.toolbar ;   //只有在真正弹出输入框时候，才加载
    
    return YES ;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSInteger number = textField.text.integerValue ;
    BOOL flag = [self isNumberAvailable:number] ;
    if (flag) {
        self.currentNumber = number ;
    }
    return YES ;

}


//检测数字是否合法
- (BOOL)isNumberAvailable:(NSInteger)number
{
    if (number < self.minNumber) {
        DDLog(@"不能少于最小购买个数%ld",self.minNumber);
        self.currentNumber = self.minNumber ;
        return NO ;
    }
    
    if (self.maxNumber > self.minNumber && number > self.maxNumber) {
        DDLog(@"不能多于最大购买个数%ld",self.maxNumber);
        self.currentNumber = self.maxNumber ;
        return NO ;
    }
    return YES ;
}


// - lazy load
- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DD_SCREEN_WIDTH, 44)];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *completeItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
        
        _toolbar.items = @[leftItem, completeItem];
    }
    return _toolbar ;
}


- (void)complete
{
    [self endEditing:YES];
}

- (void)setCurrentNumber:(NSInteger)currentNumber
{
    _currentNumber = currentNumber ;
    
    self.numberField.text = [NSString stringWithFormat:@"%ld",currentNumber];
    
    
    //底下配置是否不能继续增加的时候，禁止按钮点击
    if (currentNumber == self.minNumber) {
        self.minusBtn.enabled = NO ;
    }else{
        self.minusBtn.enabled = YES ;
    }
    
    if (currentNumber == self.maxNumber) {
        self.plusBtn.enabled = NO ;
    }else{
        self.plusBtn.enabled = YES ;
    }
}

@end
