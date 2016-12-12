//
//  InfoShowViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "InfoShowViewController.h"
#import "InfoShowScrollView.h"

@interface InfoShowViewController ()

@end

@implementation InfoShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    InfoShowScrollView * infoView = [[InfoShowScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.dd_width, 100) style:UITableViewStylePlain] ;
    [self.view addSubview:infoView] ;
    
    NSMutableArray * array = @[].mutableCopy ;
    for (int i = 0 ; i < 100; i ++) {
        NSAttributedString * attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"das fs瑟尔daf sdsaf sad%d",i]] ;
        [array addObject:attr] ;
    }
    
    infoView.infos = array ;
}


@end
