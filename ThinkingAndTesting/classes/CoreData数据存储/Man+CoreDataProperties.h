//
//  Man+CoreDataProperties.h
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/17.
//  Copyright © 2017年 dadong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Man.h"

NS_ASSUME_NONNULL_BEGIN

@interface Man (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *sex;

@end

NS_ASSUME_NONNULL_END
