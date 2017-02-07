//
//  UIView+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UIView+DDAdd.h"

@implementation UIView (DDAdd)

- (UIImage *)snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0) ;
    [self.layer renderInContext:UIGraphicsGetCurrentContext()] ;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0) ;
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterScreenUpdates] ;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}

- (NSData *)snapshotPDF
{
    CGRect bounds = self.bounds ;
    NSMutableData * data = [NSMutableData data] ;
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data) ;
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL) ;
    CGDataConsumerRelease(consumer) ;
    CGPDFContextBeginPage(context, NULL) ;
    
    CGContextTranslateCTM(context, 0, bounds.size.height) ;
    CGContextScaleCTM(context, 1, -1) ;
    [self.layer renderInContext:context] ;

    CGPDFContextEndPage(context) ;
    CGPDFContextClose(context) ;
    CGContextRelease(context) ;
    return data ;
}

- (void)removeAllSubViews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
}

- (UIViewController *)viewController
{
    for (UIView * view = self ; view; view = view.superview)
    {
        UIResponder * responder = [view nextResponder] ;
        if(responder && [responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder ;
        }
    }
    return nil ;
}
@end
