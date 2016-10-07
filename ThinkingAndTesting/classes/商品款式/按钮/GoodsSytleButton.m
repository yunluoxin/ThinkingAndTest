//
//  GoodsSytleButton.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "GoodsSytleButton.h"


#define GoodsSytleButton_ImageWidth       17.0f //定义按钮里面被选中图片的宽
#define GoodsSytleButton_FontSize         13.0f //字体大小
#define GoodsSytleButton_Height           25.0f //按钮最大高度

@interface GoodsSytleButton(){
    __weak UIImageView *_imageV ;               //右下角的指示器
}

@end

@implementation GoodsSytleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self ;
}

#pragma mark - 初始化View

- (void)initView
{
    self.layer.masksToBounds = YES ;
    self.layer.cornerRadius = 3 ;
    self.layer.borderColor = DDColor(56, 154, 187, 1).CGColor;
    self.layer.borderWidth = 0.8 ;
    
    
    self.titleLabel.font = [UIFont systemFontOfSize:GoodsSytleButton_FontSize];
    self.titleLabel.textAlignment = NSTextAlignmentCenter ;
    self.titleLabel.textColor = [UIColor blackColor];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    if (state == UIControlStateNormal) {
        CGSize size = [title sizeOfFont:[UIFont systemFontOfSize:GoodsSytleButton_FontSize] maxWidth:DD_SCREEN_WIDTH maxHeight:GoodsSytleButton_Height];
        self.bounds = CGRectMake(0, 0, size.width + 8, GoodsSytleButton_Height);
    }
}

#pragma mark - 重写选中时候的view

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (!_imageV) {
        UIImage *image = [UIImage imageNamed:@"goods_selected"] ;
        UIImageView *imageV = [[UIImageView alloc]initWithImage:image];
        _imageV = imageV ;
        [self addSubview:imageV];

    }else{
        [_imageV removeFromSuperview];
        _imageV = nil ;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_imageV) {
        CGFloat w = GoodsSytleButton_ImageWidth ;
        CGFloat h = w ;
        CGFloat x = self.bounds.size.width - w ;
        CGFloat y = self.bounds.size.height - h ;
        _imageV.frame = CGRectMake(x, y, w, h);
    }
}
@end
