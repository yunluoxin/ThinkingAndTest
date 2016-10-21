//
//  BoxCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BoxCell.h"

@interface BoxCell ()

@property (nonatomic, weak) UILabel *titleLabel ;
@property (nonatomic, weak) UIImageView *imageV ;

@end

@implementation BoxCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self) {
        [self initView] ;
    }
    return self ;
}

- (void)initView
{
    self.backgroundColor = [UIColor purpleColor] ;
    UILabel * titleLabel = [UILabel new] ;
    titleLabel.textColor = [UIColor blueColor] ;
    self.titleLabel = titleLabel ;
    [self addSubview:titleLabel] ;
    
    UIImageView *imageV = [UIImageView new] ;
    self.imageV = imageV ;
    [self addSubview:imageV] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.entity && self.entity.whenTapCell) {
        self.entity.whenTapCell()  ;
    }
}

- (void)setEntity:(BoxEntity *)entity
{
    _entity = entity ;
    
    self.titleLabel.text = entity.title ;
    self.imageV.image = [UIImage imageNamed:entity.imageName] ;
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    CGFloat margin = 8 ;
    CGFloat tx = margin ;
    CGFloat ty = 0 ;
    CGFloat tw = self.dd_width ;
    CGFloat th = 20 ;
    self.titleLabel.frame = CGRectMake(tx, ty, tw, th) ;
    
    CGFloat iy = self.titleLabel.dd_bottom + margin ;
    CGFloat ih = self.dd_height - iy - margin ;
    CGFloat iw = ih ;
    CGFloat ix = ( self.dd_width - iw ) / 2 ;
    self.imageV.frame = CGRectMake(ix, iy , iw , ih ) ;
    
}
@end
