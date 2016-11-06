//
//  MessageNumViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/27.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "MessageNumViewController.h"
#import "MessageView.h"
#import "UIView+DD.h"
@interface MessageNumViewController ()

@end

@implementation MessageNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MessageView * msg = [[MessageView alloc] initWithFontSize:12] ;
    msg.messageNum = @"23" ;
    msg.messageBackgroundColor = [UIColor orangeColor] ;
    msg.messageNumColor = [UIColor whiteColor] ;
    msg.center = CGPointMake(70, 100) ;
    [self.view addSubview:msg] ;
    
    MessageView * msg2 =  [[MessageView alloc] initWithFontSize:12] ;
    msg2.messageNum = @"2" ;
    msg2.messageNumColor = [UIColor whiteColor] ;
    msg2.center = CGPointMake(70, 200) ;
    [self.view addSubview:msg2] ;
    
    MessageView * msg3 =  [[MessageView alloc] initWithFontSize:12] ;
    msg3.messageNum = @"23" ;
    [self.view addSubview:msg3] ;
    msg3.center = CGPointMake(70, 300) ;
    
    
    UIImage * i = [msg snapshot] ;
    NSData * data =  UIImagePNGRepresentation(i) ;
    [data writeToFile:@"/Users/dadong/Desktop/a.png" atomically:YES] ;
}

- (UIImage *)getOriginalImage:(CGSize)size
{
    CGFloat min = MIN(size.width, size.height) ;
    CGSize newSize = CGSizeMake(min, min) ;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0) ;
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    CGContextAddArc(context, min/2 ,min / 2 , min/2, 0, M_PI * 2, YES ) ;
    [[UIColor purpleColor]setFill] ;
    CGContextFillPath(context) ;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}
@end
