//
//  CTFrameParserConfig.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init
{
    if (self = [super init]) {
        _width = 100.f ;
        _fontSize = 15.0f ;
        _lineSpace = 8.0f ;
        _textColor = [UIColor blackColor] ;
    }
    return self ;
}



@end
