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

    MessageView * msg = [[MessageView alloc] initWithFrame:CGRectMake(50, 100, self.view.dd_width, 62)] ;
    msg.messageNum = @"223" ;
    msg.messageBackgroundColor = [UIColor orangeColor] ;
    msg.messageNumColor = [UIColor whiteColor] ;
    [self.view addSubview:msg] ;
    
    MessageView * msg2 = [[MessageView alloc] initWithFrame:CGRectMake(0, 200, self.view.dd_width, 12)] ;
    msg2.messageNum = @"2" ;
    msg2.messageNumColor = [UIColor whiteColor] ;
    [self.view addSubview:msg2] ;
    
    MessageView * msg3 = [[MessageView alloc] initWithFrame:CGRectMake(0, 300, self.view.dd_width, 12)] ;
    msg3.messageNum = @"23" ;
    [self.view addSubview:msg3] ;
    
    
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
