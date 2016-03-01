//
//  ParamGridView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ParamGridView.h"

#define ParamGrid_FontSize          14.0f     //设置字体大小
#define ParamGrid_Left_MaxWidth     80.0f    //设置竖线左边的最大宽度
#define ParamGrid_MaxHeight         75.0f      //设置最大的行高.如果设置负数，则表示每行高度无上限
@interface ParamGridView()

@property (nonatomic, strong) NSDictionary *dic ;
@end
@implementation ParamGridView
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if (dic) {
            self.dic = dic ;
            __weak typeof(self) weakSelf = self ;
            [weakSelf initView] ;
        }
    }
    return self ;
}

- (void)initView
{
    __block CGFloat y = 0 ;
    CGFloat margin = 8 ;
    CGFloat margin_right = 16 ;
    CGFloat leftMaxWidth = ParamGrid_Left_MaxWidth - margin - margin_right ;
    CGFloat rightMaxWidth = DD_SCREEN_WIDTH - ParamGrid_Left_MaxWidth - margin_right - margin ;
    
    if (self.dic.allKeys.count > 0) {
        UIView *firstLine = [self thinLineWithWidth:DD_SCREEN_WIDTH height:0.5 x:0 y:0];
        [self addSubview:firstLine];
    }else{
        return ;
    }
    
    [self.dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        CGSize keySize = [key sizeOfFont:[UIFont systemFontOfSize:ParamGrid_FontSize] maxWidth:leftMaxWidth maxHeight:ParamGrid_MaxHeight];
        CGSize valueSize = [value sizeOfFont:[UIFont systemFontOfSize:ParamGrid_FontSize] maxWidth:rightMaxWidth maxHeight:ParamGrid_MaxHeight];
        
        CGFloat maxH = MAX(keySize.height, valueSize.height) + margin*2;//取两者中最大高度
        if (ParamGrid_MaxHeight>0 && maxH > ParamGrid_MaxHeight) {
            maxH = ParamGrid_MaxHeight ;
        }
        
        UILabel *keyLable = [[UILabel alloc]initWithFrame:CGRectMake(margin,y, keySize.width, maxH)];
        keyLable.text = key ;
        keyLable.textAlignment = NSTextAlignmentLeft ;
        keyLable.font = [UIFont systemFontOfSize:ParamGrid_FontSize];
        keyLable.textColor = [UIColor blackColor];
        keyLable.numberOfLines = 0 ;
        [self addSubview:keyLable];
        
        UILabel *valueLable = [[UILabel alloc]initWithFrame:CGRectMake(ParamGrid_Left_MaxWidth + margin ,y, valueSize.width, maxH)];
        valueLable.text = value ;
        valueLable.textAlignment = NSTextAlignmentLeft ;
        valueLable.font = [UIFont systemFontOfSize:ParamGrid_FontSize];
        valueLable.textColor = [UIColor blackColor];
        valueLable.numberOfLines = 0 ;
        [self addSubview:valueLable];
        
        UIView *lineV = [self thinLineWithWidth:0.5 height:maxH x:ParamGrid_Left_MaxWidth y:y];
        [self addSubview:lineV];
        y = y + maxH ;
        
        UIView *lineH = [self thinLineWithWidth:DD_SCREEN_WIDTH height:0.5 x:0 y:y];
        [self addSubview:lineH];
    }];
    self.frame = CGRectMake(0, 0, DD_SCREEN_WIDTH, y);
}

- (UIView *) thinLineWithWidth:(CGFloat )width height:(CGFloat)height x:(CGFloat)x y:(CGFloat) y
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5 ;
    return line ;
}
@end
