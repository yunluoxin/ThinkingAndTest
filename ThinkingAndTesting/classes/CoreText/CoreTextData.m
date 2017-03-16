//
//  CoreTextData.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CoreTextData.h"

@implementation CoreTextData

- (void)setFrameRef:(CTFrameRef)frameRef
{
    if (_frameRef != frameRef) {
        if (_frameRef) {
            CFRelease(_frameRef) ;
        }
        
        CFRetain(frameRef) ;
        _frameRef = frameRef ;
    }
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray ;
    
    [self calculateFillingImagePosition] ;
}


- (void)calculateFillingImagePosition
{
    
    if (!_imageArray || _imageArray.count <= 0) {
        return ;
    }
    
    NSArray * lines = (__bridge id)CTFrameGetLines(self.frameRef) ;
    
    int lineCount = (int)lines.count ;
    
    CGPoint lineOrigins[lineCount] ;    // what we can get is just the origin position ({x,y}) of every line.
    
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), lineOrigins) ;
    
    
    int imageIndex = 0 ;
    CoreTextImageData * imageData = _imageArray[imageIndex] ;
    
    for (int i = 0; i < lineCount; i ++) {
        if (imageData == nil) { // all images are filled.
            break ;
        }
        
        CTLineRef lineRef = (__bridge CTLineRef)lines[i] ;
        
        NSArray * runs = (__bridge id)CTLineGetGlyphRuns(lineRef) ;
        
        for (int j = 0 ; j < runs.count; j ++) {
            CTRunRef runRef = (__bridge CTRunRef)runs[j] ;
            NSDictionary *dic = (__bridge id)CTRunGetAttributes(runRef) ;
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)(dic[(id)kCTRunDelegateAttributeName]) ;
            
            if (delegate == nil) {  // this CTRun is not occupied word.
                continue ;
            }
            
            NSDictionary * refCon = CTRunDelegateGetRefCon(delegate) ;
            if ([refCon isKindOfClass:[NSDictionary class]] == NO) {    // judge again, in case some condition.
                continue ;
            }
            
            
            
            
            /// begin calculate image rect
            
            CGRect runBounds ;
            CGFloat ascent ;
            CGFloat decent ;
            runBounds.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &ascent, &decent, NULL) ;
            runBounds.size.height = ascent + decent ;
            
            // 计算出==某行上第Index字，相对于此行的原点的位移
            CGFloat xOffset = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL) ;
            runBounds.origin.x = lineOrigins[i].x + xOffset ;
            runBounds.origin.y = lineOrigins[i].y ;
            
            runBounds.origin.y -= decent ;                  // ????????????是不是此时的坐标系还是左下方
            // 此项也是控制，当前是要图片和字的底部（即基准线）对齐，还是和Decent对齐的关键
            
            
            
            // 为了防止， Path的原点不是(0,0),也就是创建frame时候，CGPath不是常用的，self.bounds为Rect创建。这时候，相对于要在某个displayView上drawRect时，相对于它有偏移， 这时候应该算出图片真正相对于他的位置，好进行绘图
            CGPathRef path = CTFrameGetPath(self.frameRef) ;
            CGRect colRect = CGPathGetBoundingBox(path) ;
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y) ;
            
            /// end calculate image rect
            
            /// consulution :
            ///         frameRef --> lineOrigin -- +xOffset,-decent --> runBound --- relative to path ---> realRunBound(ImageRect)
            ///
            
            
            
            
            imageData.imageRect = delegateBounds ;
            
            imageIndex ++ ;
            
            if (imageIndex == self.imageArray.count) {
                imageData = nil ;
                break ;
            }else{
                imageData = self.imageArray[imageIndex] ;
            }
            
            
        }//for runs
        
    }//for lines
}


+ (CoreTextLinkData *)findLinkOnTouchedPoint:(CGPoint)touchPoint inLinkArray:(NSArray *)links ofFrameRef:(CTFrameRef)frameRef
{
    if (!frameRef || !links || links.count < 1) {
        return nil ;
    }
    
    NSArray * lines = (__bridge id)CTFrameGetLines(frameRef) ;
    
    CGPoint lineOrigins[lines.count] ;
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins) ;
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef  lineRef = (__bridge CTLineRef)lines[i] ;
        CGPoint origin = lineOrigins[i] ;
        
        CGFloat ascent ;
        CGFloat decent ;
        CGFloat width = CTLineGetTypographicBounds(lineRef, &ascent, &decent, NULL) ;
        CGRect lineRect = CGRectMake(origin.x, origin.y - decent, width, ascent + decent) ;
        
        if (CGRectContainsPoint(lineRect, touchPoint)) {
            
            // find touch point, the link is right in this row. But we don't know which link is touched.
            
            /// step 1. calculate the relative location to the line's origin.
            CGPoint offset = CGPointMake(touchPoint.x - lineRect.origin.x, touchPoint.y - lineRect.origin.y) ;
            
            ///
            /// @param  position
            /// The location of the mouse click relative to the line's origin.
            ///
            CFIndex index = CTLineGetStringIndexForPosition(lineRef, offset) ;
            
            DDLog(@"点击了第%li个",index) ;
            
            for (int j = 0; j < links.count; j ++) {
                CoreTextLinkData * link = links[j] ;
                if (NSLocationInRange(index, link.range)) {
                    return link ;
                }
            }
            
        }
    }

    return nil ;
}



- (void)dealloc
{
    if (_frameRef) {
        CFRelease(_frameRef) ;
        _frameRef = nil ;
    }
}

@end



@implementation CoreTextImageData
@end
@implementation CoreTextLinkData
@end
