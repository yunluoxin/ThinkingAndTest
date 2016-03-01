//
//  GoodsStyleView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "GoodsStyleView.h"
#import "GoodsSytleButton.h"

/*========================================
                    ||
                    ||
                    ||
                    ||
                    ||
                    ||
                    ||
 
*/
#define GoodsStyleView_MaxHeight            30.0f   //定义 每行高度
#define GoodsStyleView_TitleWidth           60.0f  //左边title的宽度

@interface GoodsStyleView ()
{
    NSString *_title ;
    NSDictionary *_dic ;
    NSString *_code ;
    
    NSArray *_orderArray ;
    
    __weak GoodsSytleButton *_lastBtn ;//上一次点击的按钮
}

@end

@implementation GoodsStyleView

- (instancetype)initWithTitle:(NSString *)title andDictionary:(NSDictionary *)dic andSeletedCode:(NSString *)code
{
    if (self = [super initWithFrame:CGRectZero]) {
        _title  = title ;
        _dic    = dic ;
        _code   = code ;
        
        [self initData];
        
        [self initView];
    }
    return self ;
}

#pragma mark - 初始化数据

- (void)initData
{
   
    NSString *orders = _dic[@"keys"];
    _orderArray = [orders componentsSeparatedByString:@","];
}

#pragma mark - 初始化View

- (void)initView
{
    CGFloat margin = 8 ;
    CGFloat padding = 8 ;
    
    CGFloat sX = 0 ;
    CGFloat sY = 0 ;//全局的
    
    //增加左边的title标签
    CGFloat lx = margin ;
    CGFloat ly = 0 ;
    CGFloat lw = GoodsStyleView_TitleWidth;
    CGFloat lh = GoodsStyleView_MaxHeight ;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(lx, ly, lw,lh)];
    label.text = _title ;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft ;
    [self addSubview:label];

    sX = label.dd_right;
    CGFloat maxWidth = DD_SCREEN_WIDTH - sX;    //剩余的最大横向大小
    
    for (int i = 0; i < _orderArray.count; i++) {
        NSString *key = _orderArray[i]; //款式编号（不对外内部）
        NSString *value = _dic[key];    //款式名字
        
        //增加一个button
        GoodsSytleButton *button = [[GoodsSytleButton alloc]initWithFrame:CGRectZero];
        [button setTitle:value forState:UIControlStateNormal];
        button.tagString = key ;//编号作为标识
        [self addSubview:button];
        [button addTarget:self action:@selector(didBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat bW = button.dd_width ;
        CGFloat bH = button.dd_height ;
        if (bW <= maxWidth) {
            //本行还可以继续塞
            CGFloat bX = sX ;
            CGFloat bY = sY + (GoodsStyleView_MaxHeight - bH)/2;
            button.frame = CGRectMake(bX, bY, bW, bH);
            sX = button.dd_right + padding ;
        }else{
            //本行位置不够了，换行
            sY = sY + GoodsStyleView_MaxHeight;
            CGFloat bX = label.dd_right ;
            CGFloat bY = sY + (GoodsStyleView_MaxHeight - bH)/2 ;
            button.frame = CGRectMake(bX, bY, bW, bH);
            sX = button.dd_right + padding ;
        }
        maxWidth = DD_SCREEN_WIDTH - sX ;
        
        if ([key isEqualToString:_code]) {
            [self didBtnClicked:button];
        }
    }
}

#pragma mark - 计算自身的高度

+ (CGFloat)calcuateHeight:(NSDictionary *)dic
{
    NSString *orders = dic[@"keys"];
    NSArray *orderArray = [orders componentsSeparatedByString:@","];
    
    CGFloat margin = 8 ;
    CGFloat padding = 8 ;
    
    CGFloat sX = 0 ;
    CGFloat sY = 0 ;//全局的
    
    //左边的title标签
    CGFloat lx = margin ;
    CGFloat lw = GoodsStyleView_TitleWidth;
    
    sX = lx + lw;
    CGFloat maxWidth = DD_SCREEN_WIDTH - sX;    //剩余的最大横向大小
    
    for (int i = 0; i < orderArray.count; i++) {
        NSString *key = orderArray[i]; //款式编号（不对外内部）
        NSString *value = dic[key];    //款式名字
        
        //增加一个button
        CGSize size = [value sizeOfFont:[UIFont systemFontOfSize:13] maxWidth:DD_SCREEN_WIDTH maxHeight:25];
        
        CGFloat bW = size.width + 8 ;
        if (bW <= maxWidth) {
            //本行还可以继续塞
            CGFloat bX = sX ;
            sX = bX + bW + padding ;
        }else{
            //本行位置不够了，换行
            sY = sY + GoodsStyleView_MaxHeight;
            CGFloat bX = lx + lw ;
            sX = bX + bW + padding ;
        }
        maxWidth = DD_SCREEN_WIDTH - sX ;
    }
    return sY + GoodsStyleView_MaxHeight;
}


- (void)didBtnClicked:(GoodsSytleButton *)button
{
    if (button == _lastBtn) {
        return ;
    }
    
    _lastBtn.selected = NO ;
    _lastBtn = button ;
    button.selected = YES ;
    
    if (self.whenStyleBtnClicked) {
        self.whenStyleBtnClicked(button.tagString);
    }
}
@end
