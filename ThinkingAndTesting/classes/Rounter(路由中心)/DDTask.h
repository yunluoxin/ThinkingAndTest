//
//  DDTask.h
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    DDTaskNewPageType
}DDTaskType;

@interface DDTask : NSObject

@property (nonatomic, assign) DDTaskType type ;
@property (nonatomic,   copy) NSString * pageUrl ;

@property (nonatomic,   weak) id target ;
@property (nonatomic, assign) SEL action ;

@end
