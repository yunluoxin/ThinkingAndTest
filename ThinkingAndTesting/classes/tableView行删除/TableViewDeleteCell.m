//
//  TableViewDeleteCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/8/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TableViewDeleteCell.h"

@interface TableViewDeleteCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end


@implementation TableViewDeleteCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * ID = @"TableViewDeleteCell" ;
    TableViewDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil]firstObject];
        cell.clipsToBounds = YES ;
        
//        cell.indentationLevel = 2 ;
//        cell.indentationWidth = 50 ;  /// 定义cell的缩进值，只有在用系统的cell的时候，才可以用。如果是自己想使用这些值，则可以layoutSubView里面，进行处理（对contentView.x）
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    }
    return cell ;
}

- (void)setModel:(DeleteModel *)model
{
    _model = model ;
    
    self.label.text = model.name ;
    
//    model.cellHeight = 200 ;
}

- (IBAction)didDeleteBtnClicked:(UIButton *)sender {
    if (self.whenDeleteBtnClicked) {
        self.whenDeleteBtnClicked(self.model) ;
    }
}

///
/// 这里为什么必须在willTransitionToState操作，而不是在didTransitionToState操作，是因为，did之后操作，用户已经可以看到出现的是文字的红色删除按钮了。然后瞬间又改变成我们自己设计的，很不好
/// 在will里面操作后，为什么还要加上dispatch_asyn 或者dispatch_after 是因为， will的时候，系统还没在cell里面构造出`UITableViewCellDeleteConfirmationView`,我们无法操作，无法要延迟
/// 到下一次RunLoop进行动作。
///
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    DDLog(@"%ld" ,state) ;
    if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
        dispatch_async(dispatch_get_main_queue(), ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        });
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    /// 在5s上面，箭头宽度是8，marginRight = 8, marginLeft这里，我再指定为8
    self.contentView.dd_width = self.dd_width - (15 + 8 + 8) ;    ///   对contentView进行偏移，可以显示出底下系统原来的UITableViewAccessaryType指定的view。
}

@end
