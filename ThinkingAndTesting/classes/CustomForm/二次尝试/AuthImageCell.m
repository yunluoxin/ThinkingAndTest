//
//  AuthImageCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "AuthImageCell.h"

@interface AuthImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteView;

@end

@implementation AuthImageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self beautify] ;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)] ;
    [self.placeholderImageView addGestureRecognizer:gesture] ;
    
    UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullShowImage:)] ;
    [self.selectedImageView addGestureRecognizer:gesture2] ;
    
    UITapGestureRecognizer * gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)] ;
    [self.deleteView addGestureRecognizer:gesture3] ;
}

- (void)beautify
{
    self.deleteView.image = [UIImage imageWithColor:[UIColor redColor]] ;
    self.deleteView.layer.cornerRadius = self.deleteView.dd_width / 2 ;
    self.deleteView.layer.masksToBounds = YES ;
    
    self.selectedImageView.layer.cornerRadius = 3 ;
    self.selectedImageView.layer.borderColor = [UIColor lightGrayColor].CGColor ;
    self.selectedImageView.layer.borderWidth = 1 / IOS_SCALE ;
}

- (void)setConfig:(AuthCellImageItemConfig *)config
{
    _config = config ;
    
    if (config.isTemlate) {
        self.selectedImageView.image = config.templatedImage ;
        
        self.selectedImageView.hidden = NO ;
        self.placeholderImageView.hidden = YES ;
        self.deleteView.hidden = YES ;
    }else{
        
        if (config.selectedImage) {
            self.selectedImageView.image = config.selectedImage ;
            
            self.selectedImageView.hidden = NO ;
            self.placeholderImageView.hidden = YES ;
            self.deleteView.hidden = NO ;
        }else{
            self.placeholderImageView.image = config.placeholderImage ;
            
            self.selectedImageView.hidden = YES ;
            self.placeholderImageView.hidden = NO ;
            self.deleteView.hidden = YES ;
        }
    }
}

- (void)addImage:(id)sender
{
    DDLog(@"click 增加图片") ;
    if (self.whenTapAddImage) {
        self.whenTapAddImage(self) ;
    }
}

- (void)fullShowImage:(id)sender
{
    DDLog(@"全屏显示图片") ;
    if (self.whenTapFullScreen) {
        self.whenTapFullScreen(self) ;
    }
}

- (void)deleteImage:(id)sender
{
    DDLog(@"删除图片") ;
    
    if (self.whenTapDeleteImage) {
        
        self.config.selectedImage = nil ;
        self.config.imageUrl = nil ;
        
        self.whenTapDeleteImage(self) ;
    }
}


@end
