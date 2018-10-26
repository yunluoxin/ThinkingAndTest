
//
//  AnimationCostViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/25.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "AnimationCostViewController.h"
#import "CameraContainerView.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDCameraRatio) {
    DDCameraRatio1v1 = 0,
    DDCameraRatio4v3,
    DDCameraRatio16v9,
    DDCameraRatioFullScreen,
    DDCameraRatioTypeCount,     ///< 所有比例类型个数
};

@interface AnimationCostViewController () {
    DDCameraRatio _currentCameraRatio;  ///< 当前界面比例
}

@property (strong, nonatomic) UIView *testView;
@property (strong, nonatomic) CameraContainerView *cameraView;

@end

@implementation AnimationCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.cameraView];
    self.cameraView.layer.contents = (id)[UIImage imageNamed:@"4"].CGImage;
//    self.cameraView.layer.masksToBounds = YES;  // 没有作用！在动画过程中，子视图超出父视图，无法裁剪
    
    _currentCameraRatio = 0;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TIK(1);
    TIK(0);

    __block CGFloat marginTop = 0;
    
    [self.cameraView showMaskWithAnimation:NO andDuration:0 complete:nil];
    
    [UIView animateWithDuration:.25 animations:^{
        switch (_currentCameraRatio) {
            case DDCameraRatio1v1:
                marginTop = (DD_SCREEN_HEIGHT - DD_SCREEN_WIDTH) / 2;
                break;
            case DDCameraRatio4v3: {
                CGFloat height = DD_SCREEN_WIDTH / 3 * 4;
                height = MIN(DD_SCREEN_HEIGHT, height);
                marginTop = (DD_SCREEN_HEIGHT - height) / 2;
                break;
            }
            case DDCameraRatio16v9: {
                CGFloat height = DD_SCREEN_WIDTH / 9 * 16;
                height = MIN(DD_SCREEN_HEIGHT, height);
                marginTop = (DD_SCREEN_HEIGHT - height) / 2;
                break;
            }
            case DDCameraRatioFullScreen:
                marginTop = 0;
                break;
            default:
                break;
        }
//        DDLog(@"%f", marginTop);
        self.cameraView.frame = CGRectMake(0, marginTop, self.view.dd_width, self.view.dd_height - marginTop * 2);
    } completion:^(BOOL finished) {
        TOCK(0);
        _currentCameraRatio = (_currentCameraRatio + 1) % DDCameraRatioTypeCount;
        
        [self.cameraView hideMaskWithAnimation:YES andDuration:.25 complete:^{
            
        }];
    }];
    
    asyn_main(^{
        [self simulateBigCostWork:0.5]; ///< 模拟耗时操作
        TOCK(1);
    });
}

- (void)test {
    TIK(1);
    TIK(0);
    [UIView animateWithDuration:1.2 animations:^{
        self.testView.alpha = 1.0;
    } completion:^(BOOL finished) {
        TOCK(0);
        [UIView animateWithDuration:2 animations:^{
            self.testView.alpha = 0.0;
        }];
    }];
    
    asyn_main(^{
        [self simulateBigCostWork:2];
        TOCK(1);
    });
}

- (void)simulateBigCostWork:(double)timeInterval {
    DDLog(@"enter sleep...");
    [NSThread sleepForTimeInterval:timeInterval];
    DDLog(@"awake from sleep...");
}

- (UIView *)testView {
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:self.view.bounds];
        _testView.backgroundColor = [UIColor purpleColor];
        _testView.alpha = 0.0;
    }
    return _testView;
}

- (UIView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraContainerView alloc] initWithFrame:CGRectMake(0, 120, self.view.dd_width, self.view.dd_height - 120 * 2)];
        _cameraView.backgroundColor = [UIColor blackColor];
    }
    return _cameraView;
}

@end
