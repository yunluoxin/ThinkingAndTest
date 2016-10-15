//
//  FormItem.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FormItem ;
@class FormGroup ;

@protocol DDFormProtocol <NSObject>
@optional
@property (nonatomic, strong) FormItem * item ;
/**
 *  sender: 消息发送者
 *  eventName  : 标志位，一个对象如果有多重事件外传时候使用
 *  item  : 当前cell包含的对象
 */
@property (nonatomic, copy ) void (^whenOpearte)(UIView * sender, NSString *eventName, FormItem * item) ;
@end


@interface FormItem : NSObject
/**
 *  属性名
 */
@property(nonatomic,copy)NSString *propertyName;
/**
 *  value
 */
@property(nonatomic,strong)id obj;
/**
 *  图片名，如果没有图片，请置空(nil)
 */
@property (nonatomic, strong)NSString *imageName ;
/**
 *  cell显示名
 */
@property(nonatomic,copy)NSString *title;
/**
 *  二级页title
 */
@property(nonatomic,copy)NSString *pageTitle;
/**
 *  cellType
 */
@property(nonatomic,copy)NSString *cellType;

/**
 *  二级页数据
 */
@property(nonatomic,strong)id pageContent;

/**
 *  是否必填项目
 */
@property(nonatomic,assign,getter=isNeed)BOOL need;

/**
 *  额外的内容（选填）
 */
@property (nonatomic, strong)id extra ;


/**
 *  便利初始化方法
 */
- (instancetype)initWithDictionary:(NSDictionary *)dic ;

/**
 *  工具方法
 *           把一个对象分解成要求的数组
 *  @param obj    对象
 *  @param groups 数据
 */
+ (void)convertObjectData:(id)obj IntoArrays:(NSArray <FormGroup *> *) groups ;
/**
 *  工具方法
 *           把数组中的数据重新回填到对象中
 *  @param groups 数组
 *  @param obj    对象
 */
+ (void)collectDataFromArrays:(NSArray <FormGroup *> *) groups toObject:(id)obj ;

@end



@interface FormItemExtra : NSObject

@property (nonatomic, copy) NSString * placeholder ;
@property (nonatomic, copy) NSString * tip ;
@property (nonatomic, copy) NSString * pattern ;

/**
 *  便利初始化方法
 */
- (instancetype)initWithDictionary:(NSDictionary *)dic ;
@end


@interface FormGroup : NSObject

@property (nonatomic, copy) NSString * title ;
@property (nonatomic, strong) NSArray<FormItem *> *items ;

- (instancetype)initWithDictionary:(NSDictionary *)dic ;
@end

