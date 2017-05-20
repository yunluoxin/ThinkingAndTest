//
//  PageIndicatorView.m
//  kachemama
//
//  Created by dadong on 2017/5/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "PageIndicatorView.h"

// make sure PageIndicatorViewTitleWidth < PageIndicatorViewWidth
#define PageIndicatorViewWidth  64.0f
#define PageIndicatorViewTitleWidth 40.0f

// changable
#define PageIndicatorViewCurrentNumFontSize     14.0f   /// 当前数量的字体大小
#define PageIndicatorViewTotalNumFontSize       18.0f   /// 总共数量的字体大小

@interface PageIndicatorView ()


/**
 *  遮罩层
 */
@property (strong, nonatomic)UIView * maskView ;
/**
 *  计数的真正Label
 */
@property (strong, nonatomic)UILabel * countLabel ;

@end

@implementation PageIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews] ;
    }
    return self ;
}

+ (instancetype)pageIndicatorView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, PageIndicatorViewWidth, PageIndicatorViewWidth)] ;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor] ;
    
    // 遮罩
    [self addSubview:self.maskView] ;
    
    // 计数
    [self.maskView addSubview:self.countLabel] ;
}

- (void)setCurrentNum:(NSUInteger)currentNum
{
    _currentNum = currentNum ;
    
    [self relayout] ;
}

- (void)setTotalNum:(NSUInteger)totalNum
{
    _totalNum = totalNum ;
    
    [self relayout] ;
}

- (void)setHideForSinglePage:(BOOL)hideForSinglePage
{
    _hideForSinglePage = hideForSinglePage ;
    
    [self relayout] ; 
}

- (void)relayout
{    
    if (self.hideForSinglePage && _totalNum == 1)
    {
        self.hidden = YES ;
    }
    else
    {
        self.hidden = NO ;
        
        NSAttributedString * currentNumStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",_currentNum] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PageIndicatorViewTotalNumFontSize]}] ;
        NSMutableAttributedString * attrM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld",_totalNum]] ;
        [attrM insertAttributedString:currentNumStr atIndex:0] ;
        self.countLabel.attributedText = attrM ;
        
        // 为了防止超过限制的大小。判断目标大小，如果超过就进行调整
        CGFloat targetW = [attrM boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, PageIndicatorViewTitleWidth) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:NULL].size.width ;
        self.countLabel.adjustsFontSizeToFitWidth = (targetW + 3 > PageIndicatorViewTitleWidth) ;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    self.maskView.center = self.center ;
    self.countLabel.frame = self.maskView.bounds ;
    
//    [self relayout] ;
}

#pragma mark - getter

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:self.maskView.bounds] ;
        _countLabel.textColor = [UIColor whiteColor] ;
        _countLabel.textAlignment = NSTextAlignmentCenter ;
        _countLabel.font = [UIFont systemFontOfSize:PageIndicatorViewCurrentNumFontSize] ;
        _countLabel.backgroundColor = [UIColor clearColor] ;
    }
    return _countLabel ;
}


- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PageIndicatorViewTitleWidth, PageIndicatorViewTitleWidth)] ;
        _maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3] ;
        _maskView.layer.cornerRadius = _maskView.dd_width / 2 ;
    }
    return _maskView ;
}
@end
