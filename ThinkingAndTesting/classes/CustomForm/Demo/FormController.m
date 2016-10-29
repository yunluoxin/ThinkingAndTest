//
//  FormController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FormController.h"
#import "FormItem.h"
#import "DDFormCell.h"
#import "TestEntity.h"
#import "DDUtils+FormCellListGenerator.h"
#import "UIImage+DD.h"
#import "UIImageView+DD.h"
#import "UIViewController+DDKeyboardManager.h"
#import "UIViewController+Swizzling.h"
@interface FormController () <UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) NSArray *groups ;
@property (nonatomic, assign)CGFloat inputBottom ;
@end

@implementation FormController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped] ;
    [self.view addSubview:tableView] ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.rowHeight = 200 ;
    TestEntity *entity = [TestEntity new] ;
    entity.sex = @"男" ;
    entity.age = @"19" ;
    entity.name = @"晓东" ;
    
    //组装数据
    [FormItem convertObjectData:entity IntoArrays:self.groups] ;
    
    self.shouldAutoHandleKeyboard = YES ;    
    
    [DDUtils generatePlistWithObject:entity toFile:nil] ;
    

    
    CFAbsoluteTime t1 =  CFAbsoluteTimeGetCurrent() ;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.view.bounds] ;
    [imageV setImageAndFill:[UIImage dd_imageNamed:@"ali" ext:@"png"]] ;
    [self.view addSubview:imageV] ;
    CFAbsoluteTime t2 =  CFAbsoluteTimeGetCurrent() - t1 ;
    NSLog(@"%f",t2) ;
//    
//    CFAbsoluteTime t3 =  CFAbsoluteTimeGetCurrent() ;
//    UIImageView *imageV2 = [[UIImageView alloc]initWithFrame:self.view.bounds] ;
//    imageV2.image = [UIImage imageNamed:@"ali"] ;
//    [self.view addSubview:imageV2] ;
//    CFAbsoluteTime t4 =  CFAbsoluteTimeGetCurrent() - t3 ;
//    NSLog(@"%f",t4) ;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FormGroup *group = self.groups[section] ;
    return group.items.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self ;
    FormGroup *group = self.groups[indexPath.section] ;
    DDFormCell *cell = [DDFormCell cellWithTableView:tableView] ;
    cell.item = group.items[indexPath.row] ;
    cell.whenOpearte = ^(UIView *sender, NSString *eventName, FormItem *item){
        if ([@"keyboard" isEqualToString:eventName]) {
            CGRect f = [sender convertRect:sender.frame toView:weakSelf.view];
            weakSelf.inputBottom = CGRectGetMaxY(f);
            return  ;
        }
    };
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormGroup *group = self.groups[indexPath.section] ;
    FormItem * item = group.items[indexPath.row] ;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES] ;
}

- (NSArray *)groups
{
    if (!_groups) {
        NSMutableArray *arrayM = [NSMutableArray array] ;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"formitem_template.plist" ofType:nil] ;
        NSArray *array = [[NSArray alloc]initWithContentsOfFile:path] ;
        for (NSDictionary *dic in array) {
            FormGroup *group = [[FormGroup alloc] initWithDictionary:dic] ;
            NSMutableArray *arrM = [NSMutableArray array] ;
            for (NSDictionary *dic2 in group.items ) {
                FormItem *item = [[FormItem alloc]initWithDictionary:dic2] ;
                if (item.extra) {
                    FormItemExtra *extra = [[FormItemExtra alloc]initWithDictionary:item.extra] ;
                    item.extra = extra ;
                }
                [arrM addObject:item] ;
            }
            group.items = [arrM copy] ;
            arrM = nil ;
            [arrayM addObject:group] ;
        }
        
        _groups = [arrayM copy] ;
        arrayM = nil ;
        
    }
    return _groups ;
}

@end
