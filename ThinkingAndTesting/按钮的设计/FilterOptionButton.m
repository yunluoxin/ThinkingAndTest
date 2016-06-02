//
//  FilterOptionButton.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FilterOptionButton.h"

@implementation FilterOptionButton
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

- (void)initView
{
    self.imageView.backgroundColor =  [UIColor purpleColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) { //选中时候
        
        self.layer.borderWidth = 1 / IOS_SCALE ;
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.cornerRadius = 2 ;
        
    }else{  //取消选中
        self.layer.borderWidth = 0 ;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    DDLog(@"%@",NSStringFromCGRect(self.titleLabel.frame));
//    DDLog(@"%@",NSStringFromCGRect(self.imageView.frame));

    
    //下面几行代码，可以让图片和文字的位置调换，并且还是居中
    if (self.imageView.hidden == NO) {
        //难点是，当状态改变没有图片时候，imageView照样缓存着之前的frame，只是隐藏了，导致移动后，Label位置不正常，所以必须判断当前imageView是否隐藏，再决定移动不移动
        self.titleEdgeInsets = UIEdgeInsetsMake(0, - self.imageView.dd_width, 0, self.imageView.dd_width);
    }else{
        self.titleEdgeInsets = UIEdgeInsetsZero ;
    }
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.dd_width, 0, - self.titleLabel.dd_width);
}
@end
