//
//  TableViewRowDeleteViewController.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewRowDeleteViewController : UIViewController

@end


/**

由于用局部删除后，之前显示的cell没有被重新加载！cell里面引用的包括block引用的，都是之前的indexPath,如果直接用此indexPath进行删除，第一次删除会正常，第二次删除就会出错了！
 两种想法：
    1. 删除一行后，刷新整个表。就会恢复索引，每次就是第一次删除了。
    2. 用entity求出在数组的索引，然后进行删除。
 实际情况：
    1. 删除后刷新整个表，由于连续进行，发现动画没了。此方案不好。虽然可以考虑，删除后过1s刷新表。
    2. ok。就是要注意，当前列表是否是分组的，如果是分组的，删除里面的row，找entity时候和删除时候要注意！分清楚section(组）。

**/


/*
    --- 2016.12.6
    昨晚坑了一晚上，一直研究上面的方案2为什么删除速度太快了就崩溃了，一直以为是block问题，各种尝试都不行。一旦 用了deleteRows就不行！只有用reloadData就可以快速删除，但是就消失了动画！
    猜想是不是用deleteRows动画设置为UITableViewCellAnimatationNone就可以！还是快速删除就崩溃。
    
    今天终于知道，苹果本身的问题，想要动画，必须把deleteRows包在beginUpate和endUpdate之间，才可以防止快速删除，并且有动画！！！！
    ```今晚尝试发现，begin和update对组合，类似reloadData，会把所有的heightForRow都重新执行一遍，几千个cell就执行几千遍！就是多了动画！！！
 
 --12.8 尝试。 没加begin和update，只用deleteRow或者reloadRow也是 一样的。加载heightForRow几千遍
 
*/