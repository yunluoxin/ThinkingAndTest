//
//  ProductAmoutChangeView.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/5/22.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ProductAmoutChangeView.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface ProductAmoutChangeView()<UITextFieldDelegate>
{
    CALayer * _borderLayer ;        // 边框
    CALayer * _verticalLayer1 ;     // 减号右边的竖线
    CALayer * _verticalLayer2 ;     // 加号左边的竖线
}
@property (nonatomic, strong) UIToolbar *toolbar ;

@property (nonatomic, weak) UITextField *numberField ;
@property (nonatomic, weak) UIButton *minusBtn ;
@property (nonatomic, weak) UIButton *plusBtn ;
@end


@implementation ProductAmoutChangeView
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
    _borderLayer = [self layerWithCornerRadius:5] ;
    [self.layer addSublayer:_borderLayer] ;
    
    [self.minusBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.dd_height) ;
        make.width.equalTo(self.minusBtn.height);
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.numberField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBtn.right);
        make.right.equalTo(self.plusBtn.left);
        make.centerY.equalTo(self.minusBtn);
        make.height.equalTo(self.minusBtn.height);
    }];
    
    
    [self.plusBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.minusBtn);
        make.centerY.equalTo(self.minusBtn) ;
        make.right.equalTo(self);
    }];
    
    _verticalLayer1 = [self layerWithCornerRadius:0] ;
    [self.layer addSublayer:_verticalLayer1] ;
    _verticalLayer2 = [self layerWithCornerRadius:0] ;
    [self.layer addSublayer:_verticalLayer2] ;
}

- (CALayer *)layerWithCornerRadius:(CGFloat)cornerRadius
{
    CALayer * borderLayer = [CALayer new] ;
    borderLayer.cornerRadius = cornerRadius ;
    borderLayer.borderColor = HexColor(0xff232326).CGColor ;
    borderLayer.borderWidth = 1 / [UIScreen mainScreen].scale ;
    return borderLayer ;
}
#pragma mark - override

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    _borderLayer.frame = self.bounds ;
    
    _verticalLayer1.frame = CGRectMake(self.minusBtn.dd_right, 0, 1 / [UIScreen mainScreen].scale, self.dd_height) ;
    _verticalLayer2.frame = CGRectMake(self.plusBtn.dd_left, 0, 1 / [UIScreen mainScreen].scale, self.dd_height) ;
}

#pragma mark - Actions & Events

- (void)didMinusBtnClicked
{
    NSInteger number = self.numberField.text.integerValue ;
    
    if ([self isNumberAvailable:(number - 1)]) {
        self.currentNumber = number - 1 ;
    }
}

- (void)didPlusBtnClicked
{
    NSInteger number = self.numberField.text.integerValue ;
    if ([self isNumberAvailable:(number + 1)]) {
        self.currentNumber = number + 1 ;
    }
}

- (void)complete
{
    [self.numberField endEditing:YES];
}

#pragma mark - UITextField代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES ;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!textField.inputAccessoryView) {
        textField.inputAccessoryView = self.toolbar ;   //只有在真正弹出输入框时候，才加载
    }
    
    return YES ;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSInteger number = textField.text.integerValue ;
    BOOL flag = [self isNumberAvailable:number] ;
    if (flag) {
        self.currentNumber = number ;
        
        if (_delegate && [_delegate respondsToSelector:@selector(productAmountChangeView:didChangeToNum:)]) {
            [_delegate productAmountChangeView:self didChangeToNum:number] ;
        }
    }
    return YES ;
    
}

#pragma mark - private methods
//检测数字是否合法
- (BOOL)isNumberAvailable:(NSInteger)number
{
    if (number < 1 || number < self.minNumber) {
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

#pragma mark - lazy load

- (UITextField *)numberField
{
    if (!_numberField) {
        UITextField *numberField = [UITextField new];
        _numberField = numberField ;
        [self addSubview:numberField];
        numberField.textAlignment = NSTextAlignmentCenter ;
        numberField.textColor = [UIColor blackColor];
        numberField.font = [UIFont systemFontOfSize:12];
        numberField.delegate = self ;
        numberField.text = [NSString stringWithFormat:@"%ld",self.minNumber];
        numberField.keyboardType = UIKeyboardTypeNumberPad ;
    }
    return _numberField ;
}

- (UIButton *)plusBtn
{
    if (!_plusBtn) {
        UIButton *plusBtn = [UIButton new];
        _plusBtn = plusBtn ;
        [self addSubview:plusBtn];
        [plusBtn setImage:[UIImage imageNamed:@"icon_amount_plus_normal"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"icon_amount_plus_disabled"] forState:UIControlStateDisabled];
        [plusBtn addTarget:self action:@selector(didPlusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn ;
}

- (UIButton *)minusBtn
{
    if (!_minusBtn) {
        UIButton *minusBtn = [UIButton new];
        _minusBtn = minusBtn ;
        [self addSubview:minusBtn];
        [minusBtn setImage:[UIImage imageNamed:@"icon_amount_minus_normal"] forState:UIControlStateNormal];
        [minusBtn setImage:[UIImage imageNamed:@"icon_amount_minus_disabled"] forState:UIControlStateDisabled];
        [minusBtn addTarget:self action:@selector(didMinusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusBtn ;
}

- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 44)];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *completeItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
        
        _toolbar.items = @[leftItem, completeItem];
    }
    return _toolbar ;
}
@end
