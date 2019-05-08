//
//  ClassLoadViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/5/8.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "ClassLoadViewController.h"
#import "Person.h"
#import "Son.h"


/**
 +load方法都只会调用一次
 +initialize方法会在使用时候调用一次。 如果子类被使用，父类还没用过，也会在这时候被调用一次,经测试会在调用子类的+initialize前就调用！
 +initialize会被分类覆盖！！！ +load方法不会被分类覆盖！ 所以谨慎在分类中重写+initialize方法
 
 如果在子类中手动调用了[super initialize]，父类的+initialize还是会被执行的，这时候等于强行调方法，不受一次的限定!
 */
@interface ClassLoadViewController ()

@end

@implementation ClassLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    Person *p = [Person new];
    Son *s = [Son new];
}

@end
