//
//  DemoCollapsiableViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/10/11.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoCollapsiableViewController.h"
#import "UIView+FDCollapsibleConstraints.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"
@interface DemoCollapsiableViewController ()
{
    BOOL _expanding ;
}
@property (nonatomic, strong) NSMutableArray *arrayM ;
@property (nonatomic, weak) UIImageView *imageV ;
@end

@implementation DemoCollapsiableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [UILabel new] ;
    label.text = @"测试一下是否可以展开" ;
    [self.view addSubview:label] ;
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ali.jpg"]] ;
    [self.view addSubview:imageV] ;
    self.imageV = imageV ;
    
    UIView *view = [UIView new] ;
    view.backgroundColor = [UIColor redColor] ;
    [self.view addSubview:view] ;
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(8) ;
        make.right.equalTo(self.view).offset(-8) ;
    }] ;
    
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view) ;
       MASConstraint *constraint =  make.top.equalTo(label.bottom).offset(15) ;
        [self.arrayM addObject:constraint] ;
        constraint = make.height.equalTo(100) ;
        [self.arrayM addObject:constraint] ;
    }] ;
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.bottom).offset(10) ;
        make.left.right.equalTo(label) ;
        make.bottom.equalTo(self.view).offset(-10) ;
    }] ;
    
    
    label.tagString = @"这是一个tagString" ;
    label.tagString = nil ;
    label.data = @"sdf" ;
    NSLog(@"A%@",label.tagString) ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _expanding = !_expanding ;

    [self.imageV updateConstraints:^(MASConstraintMaker *make) {
        if (_expanding) {
            make.height.equalTo(200) ;
        }else{
            make.height.equalTo(0) ;
        }
    }];
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (NSMutableArray *)arrayM
{
    if (!_arrayM) {
        _arrayM = @[].mutableCopy ;
    }
    return _arrayM ;
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
