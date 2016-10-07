//
//  DemoPrintViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoPrintViewController.h"
#import "MJExtension.h"
#import "People.h"
#import <objc/runtime.h>

//异步主线程
#define MainGCD(block) dispatch_async(dispatch_get_main_queue(), block)
//异步全局线程
#define GlobalGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
//弱指针
#define DDWeak(weakSelf) __typeof(&*self) __weak weakSelf = self ;

@interface DemoPrintViewController ()
@property (nonatomic, copy) NSString *str ;
@end

@implementation DemoPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self printObjectProperties];
    
    People *p = [People new];
    p.name = @"zhaznag";
    p.age = @5 ;
    [self printObjectPropertiesAndValues:p];
}

/**
 *  打印对象的属性列表(不包括属性值)
 */
- (NSArray *)printObjectProperties
{
    u_int count ;
    objc_property_t *properties = class_copyPropertyList([People class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0 ; i < count;  i ++ ) {
        const char * propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
//    DDLog(@"%@",propertiesArray);
    return propertiesArray ;
}



/**
 *  打印对象的属性和值
 *
 */
- (void)printObjectPropertiesAndValues:(NSObject *)object
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *array = [self printObjectProperties] ;

    for (int i = 0 ; i  < array.count; i ++) {
        NSString *key = array[i];
        NSString *value = [object valueForKey:key];
        [dic setObject:value forKey:key];
    }
    DDLog(@"%@",dic);
}




- (void)printJsonStringToPropertyString
{
    NSString *str = @"{\"name\":\"zhangxiaodong\",\"age\":26,\"mobile\":\"18759598185\",\"array\":[                                                                 ]}" ;
    NSDictionary *dic  = [str mj_JSONObject];
    DDLog(@"%@",dic);
    NSMutableString *strM = [NSMutableString string];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [strM appendFormat:@"@property(nonatomic,copy) NSString *%@;\n",key];
        }else if([obj isKindOfClass:[NSNumber class]]){
            [strM appendFormat:@"@property(nonatomic,strong) NSNumber *%@;\n",key];
        }else if([obj isKindOfClass:[NSArray class]]){
            [strM appendFormat:@"@property(nonatomic,strong) NSArray *%@;\n",key];
        }
        
    }];
    
    DDLog(@"%@",strM);
    
    DDWeak(weakSelf)
    
    MainGCD(^{
        [NSThread sleepForTimeInterval:2];
        DDLog(@"异步主线程%@",weakSelf.str);
        
    });
    
    GlobalGCD(^{
        DDLog(@"我先被执行吧。");
        weakSelf.str = @"ds";
    });
}
@end
