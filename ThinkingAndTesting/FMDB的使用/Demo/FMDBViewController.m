//
//  FMDBViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDB.h"
#import "DDAppCache.h"
#import "DDNotifications.h"
@interface FMDBViewController ()

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 50, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//    FMDatabase *conn = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
//        NSString *path = [NSString stringWithFormat:@"%@/test.db",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]] ;
    
    NSString *path = [NSString stringWithFormat:@"%@/test.db",[DDAppCache getMainCacheDirectoryPath] ] ;
    NSError *error ;
    [[NSFileManager defaultManager] createDirectoryAtPath:[DDAppCache getMainCacheDirectoryPath] withIntermediateDirectories:YES attributes:nil error:&error];
    DDLog(@"%ld",error.code);
    DDLog(@"%@",path);
    FMDatabase *conn = [FMDatabase databaseWithPath:path] ;
    
    if (![conn open]) {
        DDLog(@"打开数据库失败");
        return ;
    }
    
    //先删除表
    BOOL result1 = [conn executeUpdate:@"drop table if exists test ;"];
    
    BOOL result = [conn executeUpdate:@"create table test (test_id integer primary key autoincrement, age integer, name text);"];
    
    if (result) {
        DDLog(@"建表成功");
    }else{
        DDLog(@"错误码--->%d,原因--->%@",[conn lastErrorCode],[conn lastErrorMessage]);
    }
    
    
//插入数据
    
    //带主键插入
    [conn executeUpdate:@"insert into test (test_id, age, name) values (1,25,'张三');"];
    
    //不带主键插入
    [conn executeUpdate:@"insert into test (age,name) values (25, '哈哈');"];
    
    //批量插入
    [conn executeStatements:@"insert into test (age,name) values (25, '哈哈');"
                            "insert into test (age,name) values (253, '\"哈哈3');"
     
     ];
    
    //占位符方式(只能一条，批量没有这个用法）
    [conn executeUpdate:@"insert into test (age, name) values(?, ?);",@54,@"'占位符"];
    
    //Object-C NSString方式
    [conn executeUpdate:[NSString stringWithFormat:@"insert into test (age, name) values(%d,%@);",23,@"'DJ拉法基'"]];
    //另类的多条插入
    [conn executeStatements:[NSString stringWithFormat:@"insert into test (age, name) values(%d,%@); insert into test (age, name) values(%d,%@);",23,@"'DJ拉法基'",23,@"'333拉法基'"]];
    
    
    //把一个数组插入到数据库
    
    [conn beginTransaction];
    NSString *sqlBatch =@"";
    for(int i = 0 ; i < 1000 ; i++ ){
        //        int a = obj.xx ;
        //        NSString *b = obj.xxx ;
        int a = i ;
        NSString *b = [NSString stringWithFormat:@"name%d",i];
//        sqlBatch = [sqlBatch stringByAppendingFormat:@"insert into test (age, name) values(%d,'%@');",a,b];
        BOOL r = [conn executeUpdate:@"insert into test (age, name) values(?,?);",@(a),b];
        DDLog(@"%d",r);
    }
//    [conn executeStatements:sqlBatch];
    [conn commit];
    
    
    
    
    //查询数据
    NSString *sql = [NSString stringWithFormat:@"select * from test"];
    FMResultSet *rs =[conn executeQuery:sql];
    while (rs.next) {
        int test_id = [rs intForColumn:@"test_id"];
        NSString *name = [rs stringForColumn:@"name"];
        int age = [rs intForColumn:@"age"];
        DDLog(@"ID-->%d,age-->%d,name-->%@",test_id,age,name);
    }

    
//    NSString *sql = [NSString stringWithFormat:@"select *from test where test_id = ?;"];
//    FMResultSet *rs = [conn executeQuery:sql,@5];
    
//    NSString *sql = [NSString stringWithFormat:@"select *from test where name = ?;"];
//    FMResultSet *rs = [conn executeQuery:sql,@"哈哈"];
//    while (rs.next) {
//                int test_id = [rs intForColumn:@"test_id"];
//                NSString *name = [rs stringForColumn:@"name"];
//                int age = [rs intForColumn:@"age"];
//                DDLog(@"ID-->%d,age-->%d,name-->%@",test_id,age,name);
//
//    }
    
    
    [rs close];//可以不写（自己会关）
    
    
    [conn close];//必须写！！！
    
    
    ADD_NOTIFICATION([DDNotifications DATA_ERROR_NOT_NETWORK]);
}

- (void)adb:(UIButton *)sender
{
    DDLog(@"dd--->%d",[@"dd" isNumberWithLength:5]);
    DDLog(@"空格--->%d",[@" 5" isNumberWithLength:5]);
    DDLog(@"46ab33--->%d",[@"46ab333" isNumberWithLength:5]);
    DDLog(@"4633--->%d",[@"4633" isNumberWithLength:5]);
    DDLog(@"12345a--->%d",[@"12345a" isNumberWithLength:5]);
    DDLog(@"12345a--->%d",[NSString verifyString:@"12345a" isNumberWithLength:5]);
    
    DDLog(@"adf@qq.com--->%d",[@"adf@qq.com" validMail]);
    DDLog(@"adf@qq.com.cn--->%d",[@"adf@qq.com.cn" validMail]);
    DDLog(@"adf@qq.cn--->%d",[@"adf@qq.cn" validMail]);
    DDLog(@"@qq.com--->%d",[@"@qq.com" validMail]);
    DDLog(@"ad@f@qq.com--->%d",[@"ad@f@qq.com" validMail]);
    DDLog(@"ad@q.q.com--->%d",[@"ad@q.q.com" validMail]);
    DDLog(@"a3d@qq.com--->%d",[@"a3d@qq.com" validMail]);
    DDLog(@"a*d@qq.com--->%d",[@"a*d@qq.com" validMail]);
    
    DDLog(@"18758988185--->%d",[@"18758988185" validPhone]);
    DDLog(@"187589881853--->%d",[@"187589881853" validPhone]);
    DDLog(@"28758988185--->%d",[@"28758988185" validPhone]);
    DDLog(@"218758988185--->%d",[@"218758988185" validPhone]);
    
    POST_NOTIFICATION([DDNotifications DATA_ERROR_NOT_NETWORK], @{@"ad":@"d"});
}


- (void)DATA_ERROR_NOT_NETWORK:(NSNotification *)note
{
    DDLog(@"%@",note);
    
    REMOVE_NOTIFICATION() ;
}

@end
