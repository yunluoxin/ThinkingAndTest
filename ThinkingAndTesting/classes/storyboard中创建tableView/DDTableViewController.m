//
//  DDTableViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDTableViewController.h"
#import "CellOne.h"
#import "CellTwo.h"
@interface DDTableViewController ()

@end

@implementation DDTableViewController
//- (instancetype)init
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"test" bundle:nil] ;
//    DDTableViewController *a = [storyboard instantiateInitialViewController] ;
//    return a ;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44 ;
    NSUInteger row = indexPath.row  ;
    if (row == 0) {
        CellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOne"];
        cell.imageV.backgroundColor = [UIColor yellowColor] ;
        cell.nameLabel.text = @"我决定了啊家乐福拉大锯法拉盛简单风流教师啊砥砺风节萨拉丁放假拉萨简单发牢骚金大福连接" ;
        CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize] ;
        return size.height ;
    }else if (row == 1){
        CellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwo"];
        cell.nameLabel.text = @"交大龙山法拉盛姐东方丽景撒两地分居啦圣诞节弗利萨就看到林凤娇撒代理费记录锁定法拉盛姐啊点就死定了放假奥丝蓝黛法拉盛姐啊大发牢骚爱的精灵放假撒砥砺风节萨拉丁放假拉萨地方家里撒大家疯了撒旦疯了了连接了家里" ;
        cell.nameLabel.preferredMaxLayoutWidth = self.view.bounds.size.width ;      //  没写就出错高度！！！说明cell中只有一个label时候，或者说label左右没其他控件时候，也需要设置！
        CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize] ;
        return size.height ;
    }
    return height ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row  ;
    if (row == 0) {
        CellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOne"];
        cell.imageV.backgroundColor = [UIColor yellowColor] ;
        cell.nameLabel.text = @"我决定了啊家乐福拉大锯法拉盛简单风流教师啊砥砺风节萨拉丁放假拉萨简单发牢骚金大福连接" ;
        return cell ;
    }else if (row == 1){
        CellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwo"];
        cell.nameLabel.text = @"交大龙山法拉盛姐东方丽景撒两地分居啦圣诞节弗利萨就看到林凤娇撒代理费记录锁定法拉盛姐啊点就死定了放假奥丝蓝黛法拉盛姐啊大发牢骚爱的精灵放假撒砥砺风节萨拉丁放假拉萨地方家里撒大家疯了撒旦疯了了连接了家里" ;
        return cell ;
        
    }

    
    
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
