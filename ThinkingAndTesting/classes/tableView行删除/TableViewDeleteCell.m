//
//  TableViewDeleteCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/8/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TableViewDeleteCell.h"

static NSString * ID = @"TableViewDeleteCell" ;

@interface TableViewDeleteCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end


@implementation TableViewDeleteCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    TableViewDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil]firstObject];
    }
    return cell ;
}

- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (IBAction)didDeleteBtnClicked:(UIButton *)sender {
    if (self.whenDeleteBtnClicked) {
        self.whenDeleteBtnClicked() ;
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
        
        for (UIView * view in self.subviews) {
            if ([view.description hasPrefix:@"<UITableViewCellDeleteConfirmationView"]) {
                
                for (UIView * obj in view.subviews) {
                    if ([obj isKindOfClass:[UIButton class]]) {
                        [obj removeFromSuperview] ;
                    }
                }
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom] ;
                [button setTitle:@"1111" forState:UIControlStateNormal] ;
                button.backgroundColor = [UIColor greenColor] ;
                [view addSubview:button] ;
                button.frame = CGRectMake(0, 0, 100, self.dd_height) ;
                
                
                UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom] ;
                [button2 setTitle:@"2222" forState:UIControlStateNormal] ;
                button2.backgroundColor = [UIColor purpleColor] ;
                [view addSubview:button2] ;
                button2.frame = CGRectMake(100, 0, 100, self.dd_height) ;
                break ;
                
            }
        }
    }
}

@end
