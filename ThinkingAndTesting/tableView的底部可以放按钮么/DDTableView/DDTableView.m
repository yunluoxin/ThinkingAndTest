//
//  DDTableView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDTableView.h"
@interface DDTableView()
{
    __weak UILabel *_tipsLabel ;
    __weak UIButton *_button ;
}
@end

@implementation DDTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self initView];
    }
    return self ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self ;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initView];
    }
    return self ;
}


#pragma mark - 初始化View

- (void)initView
{
    //增加一个背景View
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    //增加一个提示
    UILabel *label = [[UILabel alloc]init];
    _tipsLabel = label ;
    self.tips = @"好像没有数据哦亲，检测下网络再重新加载试试吧！";
    CGSize size = [label.text sizeOfFont:label.font maxWidth:DD_SCREEN_WIDTH/2 maxHeight:100];
    CGFloat lx = (DD_SCREEN_WIDTH - size.width)/2 ;
    CGFloat ly = 200 ;
    label.frame = CGRectMake(lx, ly, size.width, size.height);
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0 ;
    [backgroundView addSubview:label];
    
    
    //增加一个按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button = button ;
    CGFloat bw = 80 ;
    CGFloat bx = (DD_SCREEN_WIDTH - bw)/2 ;
    CGFloat by = CGRectGetMaxY(label.frame) + 20 ;
    button.frame = CGRectMake(bx, by , bw, 30);
    button.layer.masksToBounds = YES ;
    button.layer.cornerRadius = 3 ;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(RefreshAgain:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:button];
    

    self.backgroundView = backgroundView ;
}

#pragma mark - 再刷新一次时候的操作

- (void)RefreshAgain:(UIButton *)button
{
    DDLog(@"-----");
    if (self.whenRefreshBtnClicked) {
        self.whenRefreshBtnClicked();
    }
}

- (void)setTips:(NSString *)tips
{
    if (!tips) {
        return ;
    }
    _tips = tips ;
    _tipsLabel.text = tips;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //布局label
    CGSize size = [_tipsLabel.text sizeOfFont:_tipsLabel.font maxWidth:DD_SCREEN_WIDTH/2 maxHeight:100];
    CGFloat lx = (DD_SCREEN_WIDTH - size.width)/2 ;
    CGFloat ly = 200 ;
    _tipsLabel.frame = CGRectMake(lx, ly, size.width, size.height);
    
    //布局button
    CGFloat bw = 80 ;
    CGFloat bx = (DD_SCREEN_WIDTH - bw)/2 ;
    CGFloat by = CGRectGetMaxY(_tipsLabel.frame) + 20 ;
    _button.frame = CGRectMake(bx, by , bw, 30);
}
@end
