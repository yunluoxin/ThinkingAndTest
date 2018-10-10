//
//  HomeBanner.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
     {
     "device_level":0,
     "end_time":1538236800,
     "id":40239,
     "link":"thinking://zipai?mode:arDIY&item=1000005",
     "link_target":1,
     "max_version":0,
     "min_version":0,
     "picture":"https://album3.zone-apse1.meitudata.com/image/19a296238b9c272501d9de588e81923e.jpg",
     "picture_b":"https://album3.zone-apse1.meitudata.com/image/20c04dc4941b974be588d19563c20a0a.jpg",
     "picture_c":"https://album3.zone-apse1.meitudata.com/image/20c04dc4941b974be588d19563c20a0a.jpg",
     "test_b":{
     "content":"contentb",
     "title_1":"testb1",
     "title_2":"testb2",
     "typesetting":1
     },
     "test_c":{
     "color_value":"ffffff",
     "content":"contentc",
     "title_1":"testc1",
     "title_2":"testc2"
     }
 */

@class HomeBannerTitle;

@interface HomeBanner : NSObject

@property(copy, nonatomic) NSString *deviceLevel;
@property(assign, nonatomic) long end_time;
@property(assign, nonatomic) long id;
@property(copy, nonatomic) NSString *link;
@property(assign, nonatomic) long link_target;

@property(assign, nonatomic) long max_version;
@property(assign, nonatomic) long min_version;

@property(copy, nonatomic) NSString *picture;
@property(copy, nonatomic) NSString *picture_b;
@property(copy, nonatomic) NSString *picture_c;
@property(strong, nonatomic) HomeBannerTitle *test_b;
@property(strong, nonatomic) HomeBannerTitle *test_c;

@end


/*
 "content":"contentb",
 "title_1":"testb1",
 "title_2":"testb2",
 "typesetting":1,
 "color_value":"ffffff",
 */
@interface HomeBannerTitle: NSObject

@property(copy, nonatomic) NSString *content;
@property(copy, nonatomic) NSString *title_1;
@property(copy, nonatomic) NSString *title_2;
@property(copy, nonatomic) NSString *typesetting;
@property(copy, nonatomic) NSString *color_value;

@end
