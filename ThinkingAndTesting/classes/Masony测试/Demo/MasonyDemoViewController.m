//
//  MasonyDemoViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "MasonyDemoViewController.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

#import "UIButton+Block.h"

@interface MasonyDemoViewController ()

@end

@implementation MasonyDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, DD_SCREEN_WIDTH, 64)];
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"Setting"];
    item.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"好了" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [bar setItems:@[item]];
    [self.view addSubview:bar];
    
//    [self test];
    
//    [self testScrollView];
    
//    [self testEdge];
    
//    [self testForm];
    
//    [self testSizeThatFits];
    
//    [self testAnimatation];
    
//    [self testPriorty ];
    
//    [self testHugAndCompressionResistance] ;

    [self testCropImage] ;
}

- (void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//测试---是否可以在某个view添加约束之前，被其他的view依赖
- (void)testPriorty
{
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    [purpleView addSubview:greenView];
    
    
    [purpleView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(greenView).offset(10);
        make.top.equalTo(self.view).offset(79);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [greenView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(purpleView).offset(8);
        make.width.equalTo(100);
        make.centerX.equalTo(purpleView);
        make.height.equalTo(50);
    }];
}


- (void)testAnimatation
{
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    __block NSMutableArray *animates = @[].mutableCopy;
    [purpleView makeConstraints:^(MASConstraintMaker *make) {
        MASConstraint * c = make.height.equalTo(100) ;
        MASConstraint * c2 = make.width.equalTo(100) ;
        make.center.equalTo(self.view);
        [animates addObject:c] ;
        [animates addObject:c2] ;
    }];
    
    __block CGFloat height = 10 ;
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
        for (MASConstraint *constraint in animates) {
//            constraint.offset(height) ;           /// ok
//            constraint.equalTo(height) ;          /// ok
//            constraint.height.equalTo(height) ;   /// 不行
        }
        
        /// 更新约束可以直接用这个，也可以用上面那个。上面的需要把需要更新的约束，事先加到数据里面。
        [purpleView updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(height, height)) ;
        }];
        
//        [purpleView setNeedsUpdateConstraints] ;
//        [purpleView updateConstraintsIfNeeded] ;
//        [purpleView setNeedsLayout] ;
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view layoutIfNeeded];     //动画有这行就够了。
            
        } completion:^(BOOL finished) {
            height += 20 ;
        }];
    }];
    [self.view addSubview:button];
    
    button.backgroundColor = [UIColor blackColor];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(100);
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view);
    }];
    
    
}


- (void)testSizeThatFits
{
    UILabel *valueLabel = [UILabel new];
    valueLabel.backgroundColor = [UIColor redColor];
    valueLabel.font = [UIFont systemFontOfSize:13];
    valueLabel.numberOfLines = 0 ;
    valueLabel.text = @"环市东路废旧塑料的放假了了电费三四点水电费sdds水电费水电费水电费";
    [self.view addSubview:valueLabel];
    CGSize size = [valueLabel sizeThatFits:CGSizeMake(300, 100)];
    DDLog(@"%@",NSStringFromCGSize(size));
    valueLabel.frame = CGRectMake(0, 64, size.width,size.height);
}
- (void)testBase
{
    
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenView];
    
    CGFloat margin = 15 ;
    [purpleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(margin);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.height.equalTo(50);
        
    }];
    
    [greenView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(purpleView.right);
        make.height.equalTo(purpleView.height);
        make.left.equalTo(purpleView.centerX);
        make.top.equalTo(purpleView.bottom).offset(margin);
    }];
}

- (void)testLabel
{
    CGFloat margin = 8 ;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.backgroundColor = [UIColor greenColor];
    nameLabel.text = @"我们水水";
    [self.view addSubview:nameLabel];
    
    UILabel *valueLabel = [UILabel new];
    valueLabel.backgroundColor = [UIColor redColor];
    valueLabel.text = @"环市东路废旧塑料的放假了了电费三四点水电费sdds水电费水电费水电费";
    [self.view addSubview:valueLabel];
    
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        
        make.height.equalTo(30);
        
        make.top.offset(32);
        
        make.width.lessThanOrEqualTo(200);//最大上限
    }];
    
    [valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.right).offset(margin);
        
        make.right.offset(-margin);
        
        make.top.equalTo(nameLabel);
        
        make.height.equalTo(nameLabel);
    }];
    
    
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
        [nameLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(100);
        }];
        [nameLabel layoutIfNeeded];
    }];
    button.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100);
        make.height.equalTo(50);
        make.top.equalTo(valueLabel.bottom).offset(margin);
        make.centerX.equalTo(self.view);
    }];
}


- (void)test
{
    CGFloat margin = 8 ;
    
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenView];
    
    UIView *blueView = [UIView new];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    [purpleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        make.right.equalTo(greenView.left).offset(-margin);
        make.top.offset(64);
        make.bottom.equalTo(blueView.top).offset(-margin);
        
        make.height.and.width.equalTo(greenView);
        make.height.equalTo(blueView.height);
    }];
    
    [greenView makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-margin);
        
        make.top.equalTo(purpleView.top);
    }];
    
    [blueView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(purpleView.left);
        
        make.bottom.offset(-margin);
        
        make.right.equalTo(self.view).offset(-margin);
    }];
}

/**
 *  frame里面可以包含autolayout,autolayout里面可以包含frame.
    ... 同一个控件不可同时使用frame和autolayout
 */
- (void)testScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:scrollView];
//    scrollView.contentSize  = CGSizeMake(DD_SCREEN_WIDTH, DD_SCREEN_HEIGHT *2 );
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(100, 100, 100, 100));
        make.height.equalTo(600);
        make.width.equalTo(300);
        make.left.top.equalTo(self.view);
    
    }];
//    [self.view layoutIfNeeded];
//    DDLog(@"%@",scrollView);
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:mainView];
    
    [mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        
        make.height.equalTo(scrollView.height).multipliedBy(2);
//
        make.width.equalTo(scrollView.width);
        
    }];

//    [scrollView makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(mainView).multipliedBy(4);
//    }];
    
//    [self.view layoutIfNeeded];
//    DDLog(@"%@",mainView);
//    DDLog(@"%@",scrollView);
    
    
    //---  autolayout 里面包含frame ---
    UILabel *nameLabel = [UILabel new];
    nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.text = @"我们水水:";
    [mainView addSubview:nameLabel];
    nameLabel.frame = CGRectMake(10, 70, 100, 30);
    
}

- (void)testEdge
{
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:purpleView];
    
    [purpleView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
}

- (void)testForm
{
    CGFloat margin = 15 ;
    CGFloat spacing = 8 ;
    
    UIView *lastView = nil ;
    for (int i = 0 ; i < 10 ; i ++ ) {
        UILabel *nameLabel = [UILabel new];
//        nameLabel.backgroundColor = [UIColor greenColor];
        nameLabel.text = @"我们水水:";
        [self.view addSubview:nameLabel];
        
        UILabel *valueLabel = [UILabel new];
//        valueLabel.backgroundColor = [UIColor redColor];
        valueLabel.textAlignment = NSTextAlignmentLeft ;
        if (i == 3) {
            valueLabel.text = @"环市东路废旧塑料的放假了了电费三四点水电费sdds水电费水电费水电费环市东路废旧塑料的放假了了电费三四点水电费sdds水电费水电费水电费";
        }else{
            valueLabel.text = @"dsjlfjsdljflsdjflDJ善良劫匪粮食店街佛粮食店街林凤娇l";
        }
        valueLabel.numberOfLines = 0 ;
        [self.view addSubview:valueLabel];
        
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(margin);
            make.width.equalTo(80);
            make.height.lessThanOrEqualTo(30);
            if (lastView) {
                make.top.equalTo(lastView.bottom).offset(spacing);
            }else{
                make.top.equalTo(self.view).offset(64+spacing);
            }
        }];
        [valueLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.right).offset(spacing);
            make.height.greaterThanOrEqualTo(nameLabel.height);
            make.right.offset(-margin);
            make.top.equalTo(nameLabel);
        }];
        lastView = valueLabel ;
    }


}


/// 测试抗拉伸 和 抗压缩
- (void)testHugAndCompressionResistance
{
    CGFloat margin = 8 ;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.backgroundColor = [UIColor greenColor];
    nameLabel.text = @"我撒旦富 撒";
    nameLabel.tag = 100 ;
    [self.view addSubview:nameLabel];
    
    UILabel *valueLabel = [UILabel new];
    valueLabel.backgroundColor = [UIColor redColor];
    valueLabel.text = @"环市";
    valueLabel.tag = 101 ;
    [self.view addSubview:valueLabel];
    
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        
        make.top.equalTo(self.view.top).offset(100);
        
    }];
    
    [valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.right).offset(margin);
        
        make.right.offset(-margin);
        
        make.centerY.equalTo(nameLabel) ;
    }];
    
    
//    [valueLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal] ;
//    [nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal] ;

    ////
    /// UILabel这种控件，随着内容的提供有一个contentSize作为默认的添加约束的size。 设置超过了contentSize的情况，就是被拉伸。少于则是被压缩。
    /// 通过分别设置抗拉伸 和 抗压缩 的优先级， 可以得到想要的效果。
    ///
}


- (void)touchesBegan1:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UILabel * nameLabel = [self.view viewWithTag:100] ;
    UILabel * valueLabel = [self.view viewWithTag:101] ;
    
    [nameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal] ;
    [valueLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal] ;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded] ;
    }] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIImageView * purpleView = [self.view viewWithTag:103] ;
    asyn_global(^{
        UIImage * image = [ [UIImage imageNamed:@"ali"] scaleToSize:CGSizeMake(300, 600)] ;     /// 可以异步执行
        sleep(3) ;
        asyn_main(^{
            purpleView.image = image ;
        });
    });
}


- (void)testCropImage
{
    UIImage * image = [UIImage imageNamed:@"ali"] ;
//    image = [image fillToSize:CGSizeMake(200, 300)] ;
//    image = [image fillToSize:CGSizeMake(300, 300)] ;
    
//    image = [image fitToSize:CGSizeMake(200, 300)] ;
    image = [image fitToSize:CGSizeMake(300, 300)] ;
    
//    image = [image scaleToSize:CGSizeMake(300, 600)] ;
//     image = [image scaleToSize:CGSizeMake(300, 300)] ;
    
    
    UIImageView * purpleView = [[UIImageView alloc] initWithImage:image] ;
    purpleView.center = self.view.center ;
    purpleView.backgroundColor = [UIColor purpleColor] ;
    purpleView.tag = 103 ;
    [self.view addSubview:purpleView] ;
    purpleView.image = image ;
}
@end
