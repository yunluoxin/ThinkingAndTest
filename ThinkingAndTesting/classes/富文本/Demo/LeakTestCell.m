//
//  LeakTestCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/7.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "LeakTestCell.h"

@interface LeakTestCell ()

@property (nonatomic, strong) UILabel * nameLabel ;

@end

@implementation LeakTestCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        DDLog(@"---initWithFrame....") ;
        self.contentView.backgroundColor = [UIColor whiteColor] ;
    }
    return self ;
}

- (void)setContent:(NSString *)content
{
    _content = content ;
    
    NSMutableAttributedString * attrM = [[NSMutableAttributedString alloc] initWithString:content] ;
    
    NSRegularExpression * pattern = [NSRegularExpression regularExpressionWithPattern:@"\\[img_\\d\\]" options:NSRegularExpressionCaseInsensitive error:nil] ;
    NSArray <NSTextCheckingResult *> * array = [pattern matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length) ];
    for (NSInteger i = array.count - 1 ; i >= 0 ; i --) {
        NSTextCheckingResult *result = array[i];
        NSString * name = [content substringWithRange:result.range] ;
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init] ;
        attachment.image = [self getImageByName:name] ;
        attachment.bounds = CGRectMake(0, 0, self.nameLabel.font.lineHeight, self.nameLabel.font.lineHeight) ;
        
        NSAttributedString * attr = [NSAttributedString attributedStringWithAttachment:attachment] ;
        [attrM replaceCharactersInRange:result.range withAttributedString:attr] ;
    }
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init] ;
    attachment.image = [self getImageByName:@"[img_0]"] ;
    attachment.bounds = CGRectMake(0, 0, self.nameLabel.font.lineHeight, self.nameLabel.font.lineHeight) ;
    
    NSAttributedString * attr = [NSAttributedString attributedStringWithAttachment:attachment] ;

    [attrM insertAttributedString:attr atIndex:0] ;
    
    self.nameLabel.attributedText = attrM ;
    
    

}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        DDLog(@"---create label....") ;
        _nameLabel = [[UILabel alloc] initWithFrame:self.bounds] ;
        _nameLabel.font =  [UIFont systemFontOfSize:15] ;
        _nameLabel.textColor = [UIColor redColor ] ;
        _nameLabel.textAlignment = NSTextAlignmentCenter ;
        
        [self.contentView addSubview:_nameLabel] ;
    }
    return _nameLabel ;
}

- (UIImage *)getImageByName:(NSString * )key
{
    NSDictionary * dic = @{
                           @"[img_0]":@"ali",
                           @"[img_1]":@"arrow",
                           @"[img_2]":@"empty_search",
                           @"[img_3]":@"4"
                           } ;
    return [UIImage imageNamed:dic[key]] ;
}
@end
