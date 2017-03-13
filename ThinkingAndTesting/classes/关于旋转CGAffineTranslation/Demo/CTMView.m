//
//  CTMView.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CTMView.h"

@implementation CTMView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    CGContextTranslateCTM(context, 0, self.bounds.size.height) ;
    CGContextScaleCTM(context, 1, -1) ;
    CGContextRotateCTM(context, M_PI / 4) ;

    [@"Hello World???????????????????????????????\n???\n" drawInRect:CGRectMake(0, 0, self.dd_width, self.dd_width) withAttributes:@{
                                                                                                                                     NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:25],
                                                                                                                                     NSStrikethroughColorAttributeName:[UIColor redColor],
                                                                                                                                     NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                                                                                                                                     }] ;
}

- (void)testRotation
{
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    
    CGContextTranslateCTM(context, 100, 100) ;
    CGContextRotateCTM(context, M_PI / 4) ;
    
    [@"Hello World???????????????????????????????\n???\n" drawInRect:CGRectMake(0, 0, self.dd_width, self.dd_width) withAttributes:@{
                                                                                                                                     NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:25],
                                                                                                                                     NSStrikethroughColorAttributeName:[UIColor redColor],
                                                                                                                                     NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                                                                                                                                     }] ;
}

- (void)testFilp
{
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    
    // flip CTM
    CGContextTranslateCTM(context, 0, self.bounds.size.height) ;
    CGContextScaleCTM(context, 1, -1) ;
    
    UIImage * image = [UIImage imageNamed:@"ali"] ;
    CGContextDrawImage(context, self.bounds, image.CGImage) ;
    
    
    // flip CTM back
    CGContextScaleCTM(context, 1, -1) ;
    CGContextTranslateCTM(context, 0, -self.bounds.size.height) ;
    
    
    [@"Hello World???????????????????????????????\n???\n" drawInRect:CGRectMake(0, 64, self.dd_width, self.dd_width) withAttributes:@{
                                                                                                                                      NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                                                      NSFontAttributeName:[UIFont systemFontOfSize:25],
                                                                                                                                      NSStrikethroughColorAttributeName:[UIColor redColor],
                                                                                                                                      NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                                                                                                                                      }] ;
}

@end
