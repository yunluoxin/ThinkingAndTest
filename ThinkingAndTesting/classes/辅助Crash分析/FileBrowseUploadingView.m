//
//  FileBrowseUploadingView.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/29.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "FileBrowseUploadingView.h"

@interface FileBrowseUploadingView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *btnExit;        /**< 按钮--退出上传模式 */
@end

@implementation FileBrowseUploadingView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = [UIScreen mainScreen].bounds;
    if (self = [super initWithFrame:rect]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.btnExit];
    }
    return self;
}

/**
 退出上传模式
 */
- (void)actionExitUploadingMode:(id)sender {
    if (self.exitUploadingMode) {
        self.exitUploadingMode();
    }
}

- (void)setAddress:(NSString *)address {
    _address = address.copy;
    self.contentLabel.text = address;
}


#pragma mark - lazy load

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat margin = 8.0;
        CGFloat y = self.bounds.size.height / 3;
        CGFloat w = self.bounds.size.width - margin * 2;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, y, w, 49.0)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"请用💻浏览器打开（手机和电脑必须在同一个局域网）\n 文件传输中时，请不要让app进入后台！会中断哈";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat y = CGRectGetMaxY(self.titleLabel.frame) + 8.0;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, 49.0)];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }
    return _contentLabel;
}

- (UIButton *)btnExit {
    if (!_btnExit) {
        CGFloat h = 49.0;
        CGFloat y = self.frame.size.height - h;
        CGFloat w = self.frame.size.width;
        _btnExit = [[UIButton alloc] initWithFrame:CGRectMake(0, y, w, h)];
        [_btnExit setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [_btnExit setTitle:@"退出上传模式" forState:UIControlStateNormal];
        [_btnExit addTarget:self action:@selector(actionExitUploadingMode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnExit;
}
@end
