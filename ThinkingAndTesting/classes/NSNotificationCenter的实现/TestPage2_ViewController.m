//
//  TestPage2_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "TestPage2_ViewController.h"
#import "ObserverMode_ViewController.h"

@interface TestPage2_ViewController ()
@property (nonatomic, strong) NSObject * a ;
/**
 *  <#note#>
 */
@property (nonatomic, strong)NSHashTable * hashTable ;
@end

@implementation TestPage2_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor] ;
    self.title = @"要跳转" ;
    
    
    self.a = [NSObject new] ;
    self.hashTable = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPersonality) capacity:1] ;
    [self.hashTable addObject:self.a] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DDLog(@"before clean:%@",self.hashTable) ;
    self.a = nil ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLog(@"after clean:%@",self.hashTable) ;
    });
    
    
    
    [self dd_navigateTo:[ObserverMode_ViewController new] ] ;
}
@end
