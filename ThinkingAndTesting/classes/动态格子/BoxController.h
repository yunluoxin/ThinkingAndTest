//
//  BoxController.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//


/**
        —————————————————————————————————————————————————————————————————————————————————————————————
    ||                                                                                                ||
    ||  本例子就是为了说明，把要做的动作也放在model中，从而使得，所有的cell，可以随便调。打印都是不变的。            ||
    ||  同理，也可以存储一个SEL， 里面表明动作，然后可以直接执行，适用于序列化存储的model，恢复后还可以继续调用方法！  ||
    ||                                                                                                ||
        —————————————————————————————————————————————————————————————————————————————————————————————
 */



#import <UIKit/UIKit.h>

@interface BoxController : UIViewController

@end
