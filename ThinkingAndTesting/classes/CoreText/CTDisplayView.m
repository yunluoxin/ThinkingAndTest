//
//  CTDisplayView.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect] ;
    
    // step 1
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    
    // step 2
    CGContextSetTextMatrix(context, CGAffineTransformIdentity) ;
    CGContextTranslateCTM(context, 0, self.bounds.size.height) ;
    CGContextScaleCTM(context, 1, -1) ;
    
    // step 3
//    CGMutablePathRef path = CGPathCreateMutable() ;
//    CGPathAddRect(path, NULL, self.bounds) ;
//    CGPathAddEllipseInRect(path, NULL, self.bounds) ;
    
    // step 4
//    NSAttributedString * attr = [[NSAttributedString alloc] initWithString:@"Hello World!!!\n 时间段啦封建礼教撒老地方拉萨大姐夫乐山大佛拉萨大姐夫拉萨大姐夫拉沙德发链接啊是第六感觉欧文urows拉萨，打飞机拉萨地方"] ;
//    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attr) ;
//    CTFrameRef frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attr.length), path, NULL) ;
    CTFrameRef frame = self.data.frameRef ;
    
    
    // step 5
    CTFrameDraw(frame, context) ;
    
    
    for (int i = 0 ; i < self.data.imageArray.count ; i ++)
    {
        CoreTextImageData * imageData = self.data.imageArray[i] ;
        UIImage * image = [UIImage imageNamed:imageData.imageName] ;
        CGContextDrawImage(context, imageData.imageRect, image.CGImage) ;
        image = nil ;
        imageData = nil ;
    }
    
    // step 6
    /// clean
//    CFRelease(setter) ;
//    CFRelease(frame) ;
//    CGPathRelease(path) ;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self] ;
    
    // transform point from UIKit to CoreQuartz
    touchPoint.y = self.bounds.size.height - touchPoint.y  ;
    
    for (CoreTextImageData * imageData in  self.data.imageArray) {
        if (CGRectContainsPoint(imageData.imageRect, touchPoint)) {
            DDLog(@"image be touched") ;
            break ;
        }
    }
}

@end
