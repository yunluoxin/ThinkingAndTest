//
//  ConstraintDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/23.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ConstraintDemoViewController.h"

#import <objc/runtime.h>

@interface ConstraintDemoViewController ()
@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *secondView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *fourthView;

@end

@implementation ConstraintDemoViewController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super init]) {
        // init some datas
    }
    return self ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}


#pragma mark - view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Constraint Demo" ;
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    

    [self testVariableArgs:self.view, self.view.subviews.lastObject, self.view.subviews.firstObject, self.thirdView, nil] ;

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController * vc = [UIViewController new] ;
    vc.view.backgroundColor = [UIColor blackColor] ;
    [self.navigationController pushViewController:vc animated:YES] ;
    
    [self testIfPossbileExchangeMethodAfterCreateInstance] ;
}

- (void)testCollapseAndRestore
{
    static bool test ;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (!test) {
            //            [UIView collapseView:self.secondView ofConstraints:@[self.secondViewHeightConstraint]] ;
            [UIView collapseView:self.thirdView ofConstraints:@[self.thirdViewHeightConstraint]] ;
        }else{
            //            [UIView restoreView:self.secondView ofConstraints:@[self.secondViewHeightConstraint]] ;
            [UIView restoreView:self.thirdView ofConstraints:@[self.thirdViewHeightConstraint]] ;
        }
    } completion:^(BOOL finished) {
        test = !test ;
    }] ;
}

- (void)testAddLineWithOffset
{
    [self.secondView addLineToPosition:DDLineViewPositionTop frontOffset:5 behindOffset:16] ;
    
    [self.secondView addLineToPosition:DDLineViewPositionBottom frontOffset:5 behindOffset:16] ;
    
    [self.secondView addLineToPosition:DDLineViewPositionLeft frontOffset:5 behindOffset:16] ;
    
    [self.secondView addLineToPosition:DDLineViewPositionRight frontOffset:5 behindOffset:16] ;
}

- (void)testAddLine
{
    [self.secondView addHorizontalLineAtTop:YES] ;
    
    [self.firstView addHorizontalLineAtTop:NO] ;
    
    [self.thirdView addVerticalLineAtLeft:YES] ;
    
    [self.fourthView addVerticalLineAtLeft:NO] ;
}


// Test convert variable arguments to array
- (void)testVariableArgs:(UIView *)view,...{
    
    if (!view) {
        return ;
    }
    
    NSMutableArray * arrayM = @[].mutableCopy ;
    [arrayM addObject:view] ;
    
    va_list views ;
    va_start(views, view) ;
    
    UIView * temp = nil ;
    while ((temp = va_arg(views, UIView *))){
        [arrayM addObject:temp] ;
    }

    va_end(views) ;
    
    DDLog(@"%@",arrayM) ;
}











- (void)testIfPossbileExchangeMethodAfterCreateInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMP originImp = class_getMethodImplementation([self class], @selector(viewWillAppear:)) ;
        IMP targetImp = class_getMethodImplementation([self class], @selector(testA)) ;
        BOOL result = class_addMethod(self.class, @selector(viewWillAppear:), targetImp, method_getTypeEncoding(class_getInstanceMethod(self.class, @selector(testA)))) ;
        
        if (result) {
            class_replaceMethod(self.class, @selector(testA), originImp, "v@::") ;
        }else{
            method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(viewWillAppear:)), class_getInstanceMethod(self.class, @selector(testA))) ;
        }
    });
}

- (void)testA{
    DDLog(@"%s",__FUNCTION__) ;
    [self testA] ;
}


@end
