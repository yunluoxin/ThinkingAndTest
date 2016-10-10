//
//  DemoProtocolController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoProtocolController.h"
#import "Cat.h"
@interface DemoProtocolController ()

@end

@implementation DemoProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];

    //多态
    id<AnimalBehaviorProtocol> animal = [Cat new];
    [animal run] ;
    
    Animal *animal2 = [Cat new] ;
    [animal2 walk] ;
    [animal2 isCute] ;
    
    //iOS中无法定义抽象类
//    Animal *a  = [Animal new] ;
//    [a walk] ;
    
    
    
    
    //私有变量也能被KVC
    Cat *cat = [Cat new] ;
    [cat setValue:@"dsf" forKey:@"_privateVar"] ;
    [cat setValue:@"dsf" forKey:@"privateVar"] ;
    [cat test] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
