//
//  BoxController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BoxController.h"
#import "DynamicBox.h"
#import "BoxCell.h"
#import "BoxEntity.h"
@interface BoxController ()
{
    __weak DynamicBox * _box ;
}
@property (nonatomic, strong) NSMutableArray *arrayM ;

@end

@implementation BoxController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayM = @[].mutableCopy ;
    for (int i = 0 ; i < 10; i ++ ) {
        BoxEntity *entity = [BoxEntity new] ;
        entity.title = [NSString stringWithFormat:@"title_%d",i] ;
        entity.imageName = @"arrow" ;
        
        __weak __typeof(entity) e = entity ;
        entity.whenTapCell = ^(){
            DDLog(@"%@被点击",e.title) ;
        };
        [_arrayM addObject:entity] ;
    }
    
    BoxEntity *entity = [BoxEntity new] ;
    entity.title = [NSString stringWithFormat:@"++++++"] ;
    entity.imageName = @"arrow" ;
    
    __weak __typeof(entity) e = entity ;
    __weak __typeof(self) wself = self ;
    entity.whenTapCell = ^(){
        if (wself.arrayM.count > 1) {
            [wself.arrayM removeObjectAtIndex:wself.arrayM.count - 2] ;
            _box.entities = wself.arrayM.copy ;
        }
    };
    [_arrayM addObject:entity] ;
    
    DynamicBox *box = [[DynamicBox alloc] initWithFrame:self.view.bounds] ;
    box.countsPerRow = 4 ;
    box.entities = [self.arrayM copy] ;
    _box = box ;
    [self.view addSubview:box] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BoxEntity *entity = [BoxEntity new] ;
    entity.title = [NSString stringWithFormat:@"title_%ld",self.arrayM.count] ;
    entity.imageName = @"arrow" ;
    
    __weak __typeof(entity) e = entity ;
    entity.whenTapCell = ^(){
        DDLog(@"%@被点击",e.title) ;
    };
    [self.arrayM insertObject:entity atIndex:self.arrayM.count-1] ;
    
    _box.entities = [self.arrayM copy ];
    
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
