//
//  ElasticityLayoutView.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ElasticityLayoutView.h"
#import "ElasticityButton.h"
@implementation ElasticityEntity
- (instancetype)initWithDic:(NSDictionary*)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic] ;
    }
    return self ;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{} ;

@end

@interface ElasticityLayoutView ()

@property (nonatomic, strong) NSMutableArray * buttons ;

@end

@implementation ElasticityLayoutView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.buttons = @[].mutableCopy ;
        self.backgroundColor = [UIColor whiteColor] ;
    }
    return self ;
}


- (void)setDatas:(NSArray *)datas
{
    if (datas.count > _datas.count) {
        for (int i = 0 ; i < datas.count - _datas.count; i ++ ) {
            ElasticityButton * btn = [ElasticityButton buttonWithType:UIButtonTypeCustom] ;
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal] ;
            btn.backgroundColor = [UIColor whiteColor] ;
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside] ;
            [self addSubview:btn] ;
            [self.buttons addObject:btn] ;
        }
    }
    
    _datas = datas ;
    
    for (UIView * subView in self.buttons) {
        subView.hidden = YES ;
    }
    
    
    CGFloat buttonHeight = self.dd_height ;
    CGFloat left_margin = 8 ;
//    CGFloat buttonWidth = 55 ;
//    CGFloat spacing = (self.dd_width - left_margin * 2 - buttonWidth * _datas.count ) / ( _datas.count - 1 ) ;
    CGFloat spacing = DDRealValue(5) ;
    CGFloat buttonWidth = (self.dd_width - left_margin * 2 - spacing * (_datas.count - 1 )) / _datas.count ;
    
    
    for (int i = 0 ; i < _datas.count; i ++) {
        UIButton * btn = self.buttons[i] ;
        btn.hidden = NO ;
        btn.tag = i ;
        
        ElasticityEntity * entity = _datas[i] ;
        [btn setTitle:entity.title forState:UIControlStateNormal] ;
        [btn setImage:[UIImage imageNamed:entity.imageName] forState:UIControlStateNormal] ;
        
        CGFloat x = left_margin + (spacing + buttonWidth) * i ;
        CGFloat y = 0 ;
        btn.frame = CGRectMake(x, y, buttonWidth, buttonHeight) ;
    }
}


- (void)click:(UIButton * )btn
{
    if (self.whenClick) {
        NSUInteger tag = btn.tag ;
        ElasticityEntity * entity = self.datas[tag] ;
        
        self.whenClick(entity) ;
    }
}

@end
