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
    
    
    //统一键盘处理
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [DDUtils generatePlistWithObject:entity toFile:nil] ;
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
- (void)popKeyboard:(NSNotification *)note
{
    DDLog(@"%@",note.object) ;
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

#pragma mark -

#pragma mark 键盘要出现
- (void)showKeyboard:(NSNotification *)note
{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat top = CGRectGetMinY(frame);
    if (top < self.inputBottom) {
        self.view.transform = CGAffineTransformMakeTranslation(0, top - self.inputBottom);
    }
}

#pragma mark 键盘消失
- (void)hideKeyboard:(NSNotification *)note
{
    self.view.transform = CGAffineTransformIdentity ;
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