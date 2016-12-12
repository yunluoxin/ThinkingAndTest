//
//  JsonTestViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "JsonTestViewController.h"
#import "AFHTTPSessionManager.h"
@interface JsonTestViewController ()

@end

@implementation JsonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testWrongJsonData] ;
}

- (void)test
{
    NSString *s = @"{\"abc\":\"353\",\"n1ame\":\"badd\",\"name\":\"badd\",\"n2ame\":\"badd\"}";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *a = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    DDLog(@"%d",[a isKindOfClass:[NSDictionary class]]);
    DDLog(@"%@",a);
    
    //    for (int i =  0; i < a.allKeys.count; i ++) {
    //        DDLog(@"key-->%@",a.allKeys[i]);
    //    }
    //
    //    [a enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    //        DDLog(@"key2-->%@",key);
    //    }];
}

- (void)testWrongJsonData
{
    NSString *s = @"{\"abc\":\"353\",\"n1ame\":\"badd\",\"name\":\"badd\",\"n2ame\"\"badd\"}";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError * error = nil ;
    NSDictionary *a = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    DDLog(@"%d",[a isKindOfClass:[NSDictionary class]]);
    DDLog(@"%@",a);
    DDLog(@"%@",error) ;
}

/**
 *  将一个无序的字典转换成一个依靠原json字符串顺序的数组，数组里面的元素是一个单元素字典
 * 
 *  @param dic        无序的字典
 *  @param jsonString json字符串
 *  @return           返回一个数组
 */
+ (NSArray *)sortDictonary:(NSDictionary *)dic withJsonString:(NSString *)jsonString
{
    NSMutableArray *arrayM  = [NSMutableArray array];
    for (int i = 0; i < dic.allKeys.count; i ++) {
        NSString *key = dic.allKeys[i];
        NSDictionary *tempDic = @{
                                  key:dic[key]
                                  };
        [arrayM addObject:tempDic];
    }
    
    [arrayM sortUsingComparator:^NSComparisonResult(NSDictionary *dic1, NSDictionary *dic2) {
        NSString *key1 = dic1.allKeys.lastObject ;
        NSString *key2 = dic2.allKeys.lastObject ;
        
        NSString *newKey1 = [NSString stringWithFormat:@"\"%@\"", key1]; //构造 "name"  这样的key
        NSString *newKey2 = [NSString stringWithFormat:@"\"%@\"", key2];
        NSInteger d1 = [jsonString rangeOfString:newKey1].location ;
        NSInteger d2 = [jsonString rangeOfString:newKey2].location ;
        return d1 - d2 ;
    }];
    return [arrayM copy];
}
@end
