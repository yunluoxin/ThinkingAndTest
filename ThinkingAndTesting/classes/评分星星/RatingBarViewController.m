//
//  RatingBarViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "RatingBarViewController.h"
#import "DDRatingBar.h"
@interface RatingBarViewController ()

@end

@implementation RatingBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DDRatingBar * bar = [[DDRatingBar alloc] initWithFrame:CGRectMake(0, 100, 120, 20)] ;
    [self.view addSubview:bar] ;
    bar.mode = DDRatingBarNormalMode ;
    
    bar.currentRating = 2 ;
    bar.numberOfStars = 6 ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
