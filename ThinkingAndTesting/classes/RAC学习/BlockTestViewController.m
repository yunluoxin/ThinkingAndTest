//
//  BlockTestViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/10.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "BlockTestViewController.h"
#import "RACLearningViewController.h"

@interface BlockTestViewController ()

@end

@implementation BlockTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    void (^testBlock)(void) = ^{
        DDLog(@"%s",__func__) ;
    } ;
    
    /// It can be pushed. because current vc (self) is the root VC of navigationController. it has been pushed early, not normally pushed at  `- viewDidAppeared:`.
    /// the below output prove it.
    /// but not recommend this due to the view's life cycle method having not been executed completely yet.
    DDLog(@"%@",self.navigationController) ; //<UINavigationController: 0x7f92a982ce00>
    
    RACLearningViewController * vc = [RACLearningViewController new] ;
    vc.block = testBlock ;
    [self dd_navigateTo:vc] ; // Unbalanced calls to begin/end appearance transitions for <RACLearningViewController: 0x7fb7ba5f4b70>.
    
    
    
    
    /// At the vc(RACLearningViewController), the block is still `__NSGlobalBlock__`
    /// So I guess
    ///        the block can be `__NSGlobalBlock` in which not reference to the outside variable, otherwise it become `__NSMallocBlock__`
    
    
    
    /// URL Test
    NSURL * url = [NSURL URLWithString:@"/Volumns/Application"] ;
    if ([url absoluteString].length > 0 && ![url.absoluteString hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""] ;       /// Attention please, this is "", not " "!
    }
    
    DDLog(@"%@",url) ;
}


@end
