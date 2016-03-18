//
//  DDProgressHUD.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDProgressHUD.h"

#define DDProgressHUDWidth      100.0f
#define DDProgressHUDHeight     DDProgressHUDWidth

@interface DDProgressHUD()
{
    BOOL _isLoading ;
    BOOL _needStop ;
    BOOL _isUserInteracted ;
    
    CGFloat _keyboradHeight ;
}
@property (nonatomic, weak) UIImageView *backgroundImageV ;

@property (nonatomic, weak) UIImageView *loadingImageInner;

@property (nonatomic, weak) UIImageView *loadingImageInter ;

@property (nonatomic, weak) UILabel *label ;
@property (nonatomic, strong)NSTimer *timer ;
@end

@implementation DDProgressHUD
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _isUserInteracted = NO ;
        [self initView];
    }
    return self ;
}

- (void)initView
{
    //自身做掩板
    self.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:0.5];
    
    //居中的view
    UIImageView *backgroundImageV = [[UIImageView alloc]init];
    backgroundImageV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _backgroundImageV = backgroundImageV ;
    [self addSubview:backgroundImageV ];
    
    //里面的图片
    UIImageView *loadingImageInner = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadingImage"]];
    _loadingImageInner = loadingImageInner ;
    [self.backgroundImageV addSubview:loadingImageInner];
    
    //外面的图片
    UIImageView *loadingImageInter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadingImage2"]];
    _loadingImageInter = loadingImageInter ;
    [self.backgroundImageV addSubview:loadingImageInter];
    
    
    UILabel *label = [[UILabel alloc]init];
    _label = label ;
    _label.font = [UIFont systemFontOfSize:16];
    _label.textAlignment = NSTextAlignmentCenter ;
    [self addSubview:label];
    
    [self setupFrame];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupFrame
{
    
    
    CGFloat w = DDProgressHUDWidth ;
    CGFloat h = DDProgressHUDHeight ;
    CGFloat x = (DD_SCREEN_WIDTH - w)  /  2 ;
    CGFloat y = (DD_SCREEN_HEIGHT - h - _keyboradHeight) /  2 ;
    
    
    if (_isUserInteracted) {
        self.frame = CGRectMake(x, y, w, h);
        self.backgroundImageV.frame = CGRectMake(0, 0, w, h) ;
    }else{
        self.frame = CGRectMake(0, 0, DD_SCREEN_WIDTH, DD_SCREEN_HEIGHT);
        self.backgroundImageV.frame = CGRectMake(x, y, w, h);
    }
}

- (void)UIKeyboardWillShowNotification:(NSNotification *)note
{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboradHeight = frame.size.height ;
    [self setupFrame];
}

- (void)UIKeyboardWillHideNotification:(NSNotification *)note
{
    _keyboradHeight = 0 ;
    [self setupFrame];
}


- (void)showStatus:(NSString *)status onlyInView:(__weak UIView *)view
{
    _isUserInteracted = YES ;
    if (view) {
        [self beginAnimatation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (YES) {
                [NSThread sleepForTimeInterval:0.5];
                if (!view || _needStop) {
                    [self stopAnimatation];
                    return ;
                }
            };
        });
    }
}

- (void)showSuccess:(NSString *)status onlyInView:(__weak UIView *)view
{
    CGSize size = [status sizeOfFont:[UIFont systemFontOfSize:16] maxWidth:DD_SCREEN_WIDTH*2/3 maxHeight:100];
    CGFloat lx = (DD_SCREEN_WIDTH - size.width)/2 ;
    CGFloat lh = size.height ;
    CGFloat ly ;
    if (self.backgroundImageV.hidden) {
        ly = 0 ;
    }else{
        ly = _backgroundImageV.dd_bottom + 8 ;
    }
    _label.frame = CGRectMake(lx, ly, size.width, lh);
    
}

- (void)beginAnimatation
{
    if (_isLoading) {
        return ;
    }
    
    [self setupFrame];
    
    if (!self.superview) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow ;
        [window addSubview:self];
    }

    self.hidden = NO ;
    _isLoading = YES ;
    _needStop = NO ;
    [self loadAnimatation];
}


- (void)loadAnimatation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.loadingImageInter.transform  = CGAffineTransformMakeRotation(M_PI);
        self.loadingImageInner.alpha = 0.1 ;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.loadingImageInter.transform = CGAffineTransformIdentity ;
            self.loadingImageInner.alpha = 1 ;
        } completion:^(BOOL finished) {
            if (_isLoading) {
                [self loadAnimatation];
            }else{
                [self removeFromSuperview];
                
            }
        }];
    }];
}
- (void)stopAnimatation
{
    _isLoading = NO ;
    self.hidden = YES ;
    _needStop = YES ;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}
@end
