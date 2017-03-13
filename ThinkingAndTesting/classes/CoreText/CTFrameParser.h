//
//  CTFrameParser.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"
@interface CTFrameParser : NSObject

// According to the given content and config, create a rich text entity NSAttributeString.
+ (NSAttributedString *)attributeStringWithContent:(NSString *)content config:(CTFrameParserConfig *) config ;



/// parse methods

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config ;

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config ;

+ (CoreTextData *)parseJSONFromFile:(NSString *)path config:(CTFrameParserConfig *)config ;

@end
