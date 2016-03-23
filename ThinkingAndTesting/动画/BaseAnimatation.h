//
//  BaseAnimatation.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/23.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    AnimatationTypeAppear ,     //画面出现
    
    AnimatationTypeDisappear    //画面消失
}AnimatationType;


@interface BaseAnimatation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimatationType type ;

@end
