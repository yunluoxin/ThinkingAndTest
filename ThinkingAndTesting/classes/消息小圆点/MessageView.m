//
//  MessageView.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/27.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "MessageView.h"
#import "UIImage+DD.h"

@interface MessageView ()
{
    CGFloat _height ;
}

@property (nonatomic, weak) UILabel * label ;

@end

@implementation MessageView

- (instancetype)initWithFontSize:(CGFloat)fontSize
{
    NSAssert(fontSize > 0 , @"fontSize can't lesserOrEqual than 0") ;
    
    if (self = [super initWithFrame:CGRectZero]) {
        UILabel * label = [[UILabel alloc] initWithFrame:self.bounds] ;
        self.label = label ;
        label.font = [UIFont systemFontOfSize:fontSize] ;
        label.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:label] ;
        
        
        _height = [UIFont systemFontOfSize:fontSize].lineHeight;
        
        self.messageBackgroundColor =  [UIColor redColor] ;
        self.messageNumColor = [UIColor blackColor] ;
    }
    
    return self ;
}


#pragma mark - override system methods

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    self.label.frame = self.bounds ;
    DDLog(@"%@",NSStringFromCGRect(self.bounds)) ;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor] ] ;
}


#pragma mark - setter and getter methods

- (void)setMessageNumColor:(UIColor *)messageNumColor
{
    _messageNumColor = messageNumColor ;
    self.label.textColor = messageNumColor ;
    
    [self relayout] ;
}

- (void)setMessageBackgroundColor:(UIColor *)messageBackgroundColor
{
    _messageBackgroundColor = messageBackgroundColor ;
    
    UIImage * image = [self createOriginalImage:CGSizeMake(_height, _height)] ;
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2 ] ;
    self.image = image ;
}

- (void)setMessageNum:(NSString *)messageNum
{
    _messageNum = messageNum ;
    
    if (!messageNum) {
        self.hidden = YES ;
        return ;
    }
    self.hidden = NO ;
    
    if (messageNum.integerValue > 99 ) {
        messageNum = @"99+" ;
    }
    
    self.label.text = messageNum ;
    
    [self relayout] ;
}


#pragma mark - utils method

- (UIImage *)createOriginalImage:(CGSize)size
{
    CGFloat min = MIN(size.width, size.height) ;
    CGSize newSize = CGSizeMake(min, min) ;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0) ;
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    CGContextAddArc(context, min/2 ,min / 2 , min/2, 0, M_PI * 2, YES ) ;
    [self.messageBackgroundColor setFill] ;
    CGContextFillPath(context) ;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}


#pragma mark - private methods

- (void)relayout
{
    if (self.messageNum.length == 1) {
        self.bounds = CGRectMake(0, 0, _height, _height) ;
        return ;
    }
    CGRect rect = [self.messageNum boundingRectWithSize:CGSizeMake(_height * 3, _height) options:0 attributes:@{NSFontAttributeName:self.label.font, NSForegroundColorAttributeName:self.label.textColor} context:NULL] ;
    
    self.bounds = CGRectMake(0, 0, rect.size.width + 8, _height ) ; // +5 is for the text of label not being out of range of the imageView .
}

@end
