//
//  LKDBHelperViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/11.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "LKDBHelperViewController.h"

#import <LKDBHelper.h>

@interface LKDBHelperViewController ()
@property (strong, nonatomic) LKDBHelper *dbHelper;
@end

@implementation LKDBHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dbHelper = [[LKDBHelper alloc] init];
    
    [self query2];
}

#pragma mark - Test

- (void)insert {
    User *user = [User new];
    user.age = arc4random() % 100;
//    user.uid = 10;
    user.name = [NSString stringWithFormat:@"name_%c", arc4random() % 128];
    
    BOOL result = [user saveToDB];
//    [self.dbHelper insertToDB:user];
    NSLog(@"%d",result);
}

- (void)delete {
    User *u = User.new;
    u.rowid = 1;
    BOOL res = [u deleteToDB];
//    [self.dbHelper deleteToDB:u];
    NSLog(@"%d", res);
}


- (void)emptyTable {
    [LKDBHelper clearTableData:User.class];
}

- (void)update {
    User *user = User.new;
    user.uid = 21;
    user.name = @"fuck";
    
    ///
    /// 都可以使用。 saveToDB在没有id情况下，就会insert，已经有了的就会update
    ///
    [self.dbHelper updateToDB:user where:nil];
//    [user saveToDB];
}

- (void)update2 {
    [self.dbHelper updateToDB:User.class set:@"name = 'test test test'" where:@"uid = 58"];
}

- (void)query {
    NSMutableArray *array = [User searchWithWhere:nil orderBy:nil offset:0 count:200];
    NSLog(@"%@",array);
}

- (void)query2 {
    NSString *sql = @"select * from user where uid = 22";
    NSArray *array = [self.dbHelper search:[User class] withSQL:sql];
    NSLog(@"%@",array);
    
    array = [self.dbHelper searchWithSQL:sql toClass:User.class];
    NSLog(@"%@",array);
    
    array = [self.dbHelper search:[User class] withSQL:@"select * from user where name = ?", @"name_I"];
    NSLog(@"%@",array);
    
    // ... 就是筛选出 返回的列， select age from user where xxx
    array = [User searchColumn:@"age" where:nil orderBy:nil offset:0 count:100];
    NSLog(@"%@",array);
}

- (void)queryById {
    NSMutableArray *array = [User searchWithWhere:@"uid = 20" orderBy:nil offset:0 count:200];
    NSLog(@"%@",array);
}

- (void)queryByDictionary {
    NSDictionary *conditions = @{
                                 @"age":@58,
                                 @"name":@"name_T",
                                 };
    NSArray *array = [User searchWithWhere:conditions orderBy:nil offset:0 count:100];
    NSLog(@"%@",array);

}
#pragma mark - Actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self insert];
    [self update2];

//    [self query2];
    
//    [self emptyTable];
    [self queryByDictionary];
//    [self delete];
}

@end

@implementation User

+ (NSString *)getTableName {
    return @"user";
}

+ (NSString *)getPrimaryKey {
    return @"uid";
}

//是否将父实体类的属性也映射到sqlite库表
+ (BOOL)isContainParent {
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"rowid: %ld, uid: %ld, name: %@, age: %ld", self.rowid, _uid, _name, _age];
}

@end
