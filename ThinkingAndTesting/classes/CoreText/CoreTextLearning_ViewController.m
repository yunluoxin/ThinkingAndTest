//
//  CoreTextLearning_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CoreTextLearning_ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"

@interface CoreTextLearning_ViewController ()


@end

@implementation CoreTextLearning_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor] ;
    
    [self test3] ;

}

- (void)test1
{
    CTFrameParserConfig * config = [[CTFrameParserConfig alloc] init] ;
    config.width = 200 ;
    config.lineSpace = 18 ;
    config.textColor = [UIColor purpleColor] ;
    CoreTextData * data = [CTFrameParser parseContent:@"加拉斯的法拉盛简单发链接撒旦浪费静安寺代理费啊撒老asdf第三方撒旦十大打啊发达打啊打啊电风扇爱的色放十大地方" config:config] ;
    
    
    CTDisplayView * displayView = [[CTDisplayView alloc] initWithFrame:CGRectMake(100, 150, 200, 100)] ;
    displayView.data = data ;
    displayView.dd_height = data.textHeight ;
    [self.view addSubview:displayView] ;
    displayView.backgroundColor = [UIColor yellowColor] ;
}

- (void)test2
{
    CTFrameParserConfig * config = [[CTFrameParserConfig alloc] init] ;
    config.width = 200 ;
    config.lineSpace = 8 ;
    
    NSString * content = @"sjdlf ajsldfjsajsdalf多少级了发拉萨dl lS Dflj sl受得了疯啦接受到浪费撒老地方拉萨大姐夫问u荣威积分；啊付款平时大夫-问人陪；我RP为啥批发商看打牌发；适当放宽；撒旦" ;
    NSAttributedString * attrStr = [CTFrameParser attributeStringWithContent:content config:config] ;
    NSMutableAttributedString * attrMString = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr] ;
    
    
    // add partial word color
    [attrMString addAttributes:@{
                                NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                                NSForegroundColorAttributeName:[UIColor redColor]
                                } range:NSMakeRange(0, 5)] ;
    
    
    
    CoreTextData * data = [CTFrameParser parseAttributedContent:attrMString config:config] ;
    
    
    CTDisplayView * displayView = [[CTDisplayView alloc] initWithFrame:CGRectMake(100, 100, config.width, 100)] ;
    displayView.data = data ;
    displayView.dd_height = data.textHeight ;
    [self.view addSubview:displayView] ;
    displayView.backgroundColor = [UIColor yellowColor] ;
    
    DDLog(@"%@",NSStringFromCGSize(displayView.bounds.size)) ;
}


/// test load content from json file
- (void)test3
{
    CTFrameParserConfig * config = [[CTFrameParserConfig alloc] init] ;
    config.width = self.view.dd_width ;
    config.lineSpace = 8 ;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"coretext" ofType:@"json"] ;
    CoreTextData * data = [CTFrameParser parseJSONFromFile:path config:config] ;
    
    CTDisplayView * displayView = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 100, config.width, 0)] ;
    displayView.data = data ;
    displayView.dd_height = data.textHeight ;
    [self.view addSubview:displayView] ;
    displayView.backgroundColor = [UIColor yellowColor] ;
}

@end
