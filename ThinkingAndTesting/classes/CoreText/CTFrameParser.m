//
//  CTFrameParser.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

@implementation CTFrameParser

+ (NSAttributedString *)attributeStringWithContent:(NSString *)content config:(CTFrameParserConfig *)config
{
    NSDictionary * dict = [self p_attributesWithConfig:config] ;
    NSAttributedString * attr = [[NSAttributedString alloc] initWithString:content attributes:dict] ;
    return attr ;
}


+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config
{
    
    NSAttributedString * attrStr = [self attributeStringWithContent:content config:config] ;
    return [self parseAttributedContent:attrStr config:config] ;
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config
{
    return [self parseAttributedContent:content config:config imageArray:nil] ;
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config imageArray:(NSMutableArray *)array
{
    // create FrameSetterRef
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)content) ;
    
    
    
    /// 有了framesetter 就可以算高的由来。。。。。。。。。。。。。。。
    
    // get drawing area's height
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX) ;
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRangeMake(0, 0), nil, restrictSize, nil) ;
    CGFloat textHeight = coreTextSize.height ;
    
    
    // create frameRef
    CTFrameRef frame = [self p_createFrameWithFrameSetter:setter config:config height:textHeight] ;
    
    // wrap data
    CoreTextData * data = [CoreTextData new] ;
    data.frameRef = frame ;
    data.textHeight = textHeight ;
    
    if (array && array.count > 0) {
        data.imageArray = array ;
    }
    
    CFRelease(frame) ;
    CFRelease(setter) ;
    
    return data ;
}

+ (CoreTextData *)parseJSONFromFile:(NSString *)path config:(CTFrameParserConfig *)config
{
    NSData * data = [NSData dataWithContentsOfFile:path] ;
   
    NSError * error ;
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] ;
    if (error) {
        return nil ;
    }
    
    NSMutableAttributedString * attrM = [[NSMutableAttributedString alloc] init] ;
    NSMutableArray * imageArray = @[].mutableCopy ;
    
    if (array && array.count > 0) {
        for (NSDictionary * dic in array)
        {
            NSString * type = dic[@"type"] ;
            if ([@"txt" isEqualToString:type])
            {
                NSString * content = dic[@"content"] ;
                NSString * colorName = dic[@"color"] ;
                CGFloat fontSize = [dic[@"size"] floatValue] ;
                
                
                NSMutableDictionary * dicM = [self p_attributesWithConfig:config].mutableCopy ;
                dicM[NSForegroundColorAttributeName] = [self p_colorFromString:colorName] ;
                dicM[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize] ;
                NSAttributedString * attr = [[NSAttributedString alloc] initWithString:content attributes:dicM] ;
                [attrM appendAttributedString:attr] ;
            }
            
            if ([@"img" isEqualToString:type])
            {
                NSString * imageName = dic[@"imageName"] ;
//                CGFloat width = [dic[@"width"] floatValue] ;
//                CGFloat height = [dic[@"height"] floatValue] ;
                
                CoreTextImageData * imageData = [CoreTextImageData new] ;
                imageData.imageName = imageName ;
                imageData.position = attrM.length ;
                [imageArray addObject:imageData] ;
                
                NSString * specialStr = @" " ;
                CTRunDelegateCallbacks callbacks ;
                callbacks.version = kCTRunDelegateVersion1 ;
                callbacks.getWidth = &getWidthCallBack ;
                callbacks.getAscent = &getAscentCallBack ;
                callbacks.getDescent = &getDecentCallBack ;
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dic)) ;
                
                NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:specialStr attributes:@{
                                                                                                                     (id)kCTRunDelegateAttributeName:(__bridge id)delegate
                                                                                                                     }] ;
                
                [attrM appendAttributedString:attrString] ;
                
                CFRelease(delegate) ;
            }
        }/* for */
        
    }
    
    return [self parseAttributedContent:attrM config:config imageArray:imageArray] ;
}


#pragma mark - kCTRunDelegate callbacks

CGFloat getWidthCallBack(void * __nullable ref){
    NSDictionary * dic = (__bridge id)ref ;
    return [dic[@"width"] doubleValue] ;
}

CGFloat getAscentCallBack(void * __nullable ref){
    NSDictionary * dic = (__bridge id)ref ;
    return [dic[@"height"] doubleValue] - getDecentCallBack(ref);
}

CGFloat getDecentCallBack(void * __nullable ref){
    return 0.0f ;
}


#pragma mark - private

+ (NSDictionary *)p_attributesWithConfig:(CTFrameParserConfig *)config
{
    CGFloat fontSize = config.fontSize ;
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)@"ArialMT", fontSize, NULL) ;
    
    CGFloat lineSpacing = config.lineSpace ;
    
    const CFIndex kNumberOfSettings = 3 ;
    
    CTParagraphStyleSetting settings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpacing}
    } ;// CTParagraphStyleSetting is struct
    
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, kNumberOfSettings) ;
    
    UIColor * textColor = config.textColor ;
    
    NSMutableDictionary * dict = @{}.mutableCopy ;
    dict[NSForegroundColorAttributeName] = textColor ;
    dict[NSFontAttributeName] = (__bridge id)fontRef ;
    dict[NSParagraphStyleAttributeName] = (__bridge id)paragraphRef ;
    
    CFRelease(paragraphRef) ;
    CFRelease(fontRef) ;
    
    return dict ;
}


+ (UIColor *)p_colorFromString:(NSString *)name
{
   
    NSString * colorName = [NSString stringWithFormat:@"%@Color",name] ;
    
    if ([UIColor respondsToSelector:NSSelectorFromString(colorName)]) {
        UIColor * color = [(id)UIColor.class performSelector:NSSelectorFromString(colorName)] ;
        return color ;
    }
    
    /// here we can add more custom color, which not use the form [UIColor xxxColor].
    /// such as below
    if ([@"default" isEqualToString:name]) {
        return [UIColor blackColor] ;
    }
    
    return [UIColor clearColor] ;
}

+ (CTFrameRef)p_createFrameWithFrameSetter:(CTFramesetterRef)setter config:(CTFrameParserConfig *)config height:(CGFloat)height
{
    CGMutablePathRef path = CGPathCreateMutable() ;
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height)) ;
    
    CTFrameRef frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, NULL) ;
    
    CFRelease(path) ;
    
    return frame ;
}
@end
