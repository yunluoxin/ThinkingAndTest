//
//  RegularViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/30.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "RegularViewController.h"
#import "DDUtils+Security.h"
@interface RegularViewController ()

@end

@implementation RegularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *emotions = @{
                               @"<哈哈/>":@"arrow",
                               @"<abc/>":@"back"
                               } ;
    
    NSString *contents = @"哈哈<哈哈/>我就说嘛，他肯定不会这样的，嘿嘿<abc/>都是时间到了发老" ;
    NSString *pattern = @"<[\\w\u4e00-\u9fa5]+/>" ;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil] ;
    NSArray<NSTextCheckingResult *> *array = [regEx matchesInString:contents options:0 range:NSMakeRange(0, contents.length) ] ;
    
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:contents] ;
    for (int i = (int)array.count - 1 ; i >= 0; i --) {
        NSString *emo = [contents substringWithRange:array[i].range] ;
        NSString *name = emotions[emo] ;
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init ] ;
        attachment.image = [UIImage imageNamed:name] ;
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:attachment] ;
        [attrStrM replaceCharactersInRange:array[i].range  withAttributedString:attrStr] ;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 300)] ;
    label.numberOfLines = 0 ;
    [self.view addSubview:label] ;
    label.attributedText = attrStrM ;
    label.center = self.view.center ;
    label.backgroundColor = [UIColor redColor] ;
    [label sizeToFit] ;
    NSLog(@"%@",NSStringFromCGRect(label.frame)) ;
    
    CGRect rect = [attrStrM boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil] ;
        NSLog(@"%@",NSStringFromCGRect(rect)) ;
    label.frame = CGRectMake(0, 100, rect.size.width, rect.size.height) ;

    DDLog(@"%ld,%ld",attrStrM.string.length,attrStrM.length) ;

    
    [self test3] ;
    
    
    NSString * re = [DDUtils encrypt_MD5:@"123456"] ;
     DDLog(@"%@",re) ;
    
    re = [DDUtils encode_base64:@"123456sadfsadfsdfsad"] ;
    
    DDLog(@"%@",re) ;
    
    re = [DDUtils decode_base64:re] ;
    DDLog(@"%@",re) ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test3
{
    NSString * pattern = @"^\\d{3,5}$" ;
    NSRegularExpression * regEx = [NSRegularExpression  regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL] ;
    
    NSString * text = @"46464" ;
    
    NSArray<NSTextCheckingResult *> * array = [regEx matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)] ;
    if (array.count < 1 ) {
        DDLog(@"不匹配") ;
        return ;
    }
    for (int i = 0 ; i < array.count;  i ++) {
        NSTextCheckingResult * result = array[i];
        NSString * r = [text substringWithRange:result.range] ;
        DDLog(@"%@",r) ;
    }
    
    
    
    //直接求第一个匹配
    NSRange range =    [regEx rangeOfFirstMatchInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length) ] ;
    NSString * r = [text substringWithRange:range] ;
    DDLog(@"%@",r) ;
    
}


- (void)testDataDetector
{
    //用系统自带的type样式做正则匹配
    NSString * text = @"http://www.baidu.com，嘿嘿我是说" ;
    NSDataDetector * detector =  [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllCustomTypes| NSTextCheckingTypeLink error:NULL] ;
    NSArray * array = [detector matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)] ;
    for (int i = 0 ; i < array.count;  i ++) {
        NSTextCheckingResult * result = array[i];
        if (result.resultType == NSTextCheckingTypeLink) {
            NSString * r = [text substringWithRange:result.range] ;
            DDLog(@"link——%@",r) ;
        }
    }
}

- (void)testPredicate
{
    NSString * a = @"asd324sdf231d" ;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"\\d{3}" ] ;
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains '24'"] ;
    
    BOOL result = [predicate evaluateWithObject:a] ;
    NSLog(@"%d",result) ;
    
    NSArray *array1 = @[@"dadong",@"xiaodong",@"zhagn",@"xiao",@"dong"] ;
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self contains 'dong'"] ;
    NSArray *array2 = [array1 filteredArrayUsingPredicate:predicate1] ;
    NSLog(@"%@",array2) ;
}


- (void)testRegularExpress
{
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"\\d{3}" options:NSRegularExpressionCaseInsensitive error:nil] ;
    NSString *a = @"asdfla2343sdaf233b" ;
    NSArray<NSTextCheckingResult *> *array = [regEx matchesInString:a options:0 range:NSMakeRange(0, a.length)] ;
    //    NSLog(@"%@",array) ;
    
    for (int i = 0 ; i < array.count; i ++) {
        NSLog(@"%@",NSStringFromRange(array[i].range)) ;
    }

}
@end
