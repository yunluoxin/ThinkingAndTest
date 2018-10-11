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

@interface FMDBViewController ()

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testFMDBDatabaseQueue];
}

- (void)testFMDBDataBase {
    
    //    FMDatabase *conn = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
    //        NSString *path = [NSString stringWithFormat:@"%@/test.db",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]] ;
    
    NSString *dir = [DDAppCache getMainCacheDirectoryPath] ;
    if (!dir) return ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir] == NO) {
        NSError *error ;
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        DDLog(@"%ld",error.code);
    }
    
    NSString *path = [dir stringByAppendingString:@"/test.db"] ;
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
    NSString *sqlBatch = @"";
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
}


- (void)testFMDBDatabaseQueue {
    NSString *dir = [DDAppCache getMainCacheDirectoryPath] ;
    if (!dir) return ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir] == NO) {
        NSError *error ;
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            DDLog(@"errorCode: %ld reason: %@", error.code, error.localizedDescription);
        }
    }
    
    NSString *path = [dir stringByAppendingString:@"/test_queue.db"] ;
    DDLog(@"%@",path);
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [queue inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            DDLog(@"打开数据库失败");
            return ;
        }
        
        // 先删除表
        BOOL result = [db executeUpdate:@"drop table if exists user;"];
        
        result = [db executeUpdate:@"create table user (uid integer primary key autoincrement, age integer, name varchar(10));"];
        
        if (result) {
            DDLog(@"建表成功");
        }else{
            DDLog(@"错误码--->%d,原因--->%@",[db lastErrorCode],[db lastErrorMessage]);
        }
        
        /////////////
        /// 插入数据///
        /////////////
        
        // 普通单条插入
        result = [db executeUpdate:@"insert into user values (1, 28, 'Dadong') "];
        if (!result) DDLog(@"%@", db.lastErrorMessage);
        
        
        // 【批量插入】
        result = [db executeStatements:@""
                  "insert into user (name, age) values ('weiwei', 15);"
                  "insert into user (name, age) values ('dongxu', 13);"
                  "insert into user (name, age) values ('mingming', 14);"
                  ];
        if (!result) DDLog(@"%@", db.lastErrorMessage);
        
        ///
        /// 占位符方式(只能一条，批量没有这个用法）
        /// @warning 占位符这里是"?",而不是NSLog里面的占位！
        ///
        [db executeUpdate:@"insert into user (age, name) values(?, ?);", @54, @"'占位符"];
        if (!result) DDLog(@"%@", db.lastErrorMessage);

        // Object-C NSString方式
        [db executeUpdate:[NSString stringWithFormat:@"insert into user (age, name) values(%d,%@);", 23, @"'DJ拉法基'"]];
        if (!result) DDLog(@"%@", db.lastErrorMessage);

        
        ///
        /// @attention 下面的两个方法都不能嵌套调用！会死锁！FMDB只处理了其中一个(inDatabase),另外一个没有进行处理！
        ///
//        [queue inDatabase:^(FMDatabase *db) {
//            NSLog(@"test 'in database' if can make deadlock");
//        }];
//
//        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//            NSLog(@"test if can make deadlock");
//        }];
        
        NSLog(@"in the end!");
    }];
    
    
    
    /////////////
    /// 事务///
    /////////////
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL res = NO;
        for (int i = 0; i < 1000; i++) {
            res = [db executeUpdate:@"insert into user (name, age) values (?, ?);", [NSString stringWithFormat:@"name_%d", i], @(i%100)];
            if (!res) {
                *rollback = YES;
                DDLog(@"回滚中...");
                return ;
            }
        }
    }];
    
    
    
    /////////////
    /// 查询///
    /////////////
    
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from user"];
        while ([rs next]) {
            int uid = [rs intForColumn:@"uid"];
            NSString *name = [rs stringForColumn:@"name"];
            int age = [rs intForColumn:@"age"];
            DDLog(@"ID-->%d,age-->%d,name-->%@",uid,age,name);
        }
    }];
    
    [queue close];
}

@end
