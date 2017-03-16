
//
//  ArrayKVO_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/15.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ArrayKVO_ViewController.h"
#import "ArrayKVO_Test.h"

@interface ArrayKVO_ViewController ()
{
    ArrayKVO_Test * _test ;
}
@end

@implementation ArrayKVO_ViewController

- (void)dealloc
{
    if (_test) [_test removeObserver:self forKeyPath:@"array"] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _test = [ArrayKVO_Test new] ;
    
    [_test addObserver:self forKeyPath:@"array" options:NSKeyValueObservingOptionNew context:nil] ;
    
    
    NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 8)] ;
    DDLog(@"%@",set) ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_test testAddData] ;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    DDLog(@"%@",change) ;
}

@end
