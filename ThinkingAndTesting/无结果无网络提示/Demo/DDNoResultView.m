//
//  DDNoResultView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDNoResultView.h"

#define DDNoResultViewFontSize    18

@interface DDNoResultView()
/**
 *  居中的图片
 */
@property (nonatomic, weak)UIImageView *imageV ;
/**
 *  提示的文字
 */
@property (nonatomic, weak)UILabel *tipLabel ;

@end

@implementation DDNoResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self ;
}

- (void)initView {
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_search"]];
    _imageV = imageV ;
    [self addSubview:imageV];
    CGFloat y = self.dd_height/2 ;
    imageV.center = CGPointMake(self.dd_width/2, y );
    
    UILabel *label = [[UILabel alloc]init];
    _tipLabel = label ;
    label.font = [UIFont systemFontOfSize:DDNoResultViewFontSize];
    label.numberOfLines = 0 ;
    label.text = @"很抱歉，暂无记录" ;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter ;
    label.frame = CGRectMake(0, _imageV.dd_bottom + 8, self.dd_width, 44);
    [self addSubview:label];
}

- (void)setTips:(NSString *)tips
{
    _tips = tips ;
    self.tipLabel.text = tips ;
    if (tips) {
        CGSize size = [tips sizeOfFont:[UIFont systemFontOfSize:DDNoResultViewFontSize] maxWidth:self.dd_width/2 maxHeight:self.dd_height - self.imageV.dd_height - 8];
        CGFloat x = (self.dd_width - size.width)/2 ;
        CGFloat y = _tipLabel.dd_top ;
        _tipLabel.frame = CGRectMake(x, y, size.width, size.height);
    }
}

@end
