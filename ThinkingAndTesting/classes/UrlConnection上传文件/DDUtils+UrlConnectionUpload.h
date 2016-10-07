//
//  DDUtils+UrlConnectionUpload.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/22.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDUtils.h"

typedef enum {
    DDUploadTypeImage ,
    DDUploadTypeString  ,
    DDUploadTypeAudio ,
    DDUploadTypeFile
}DDUploadType;

@interface DDUtils (UrlConnectionUpload)

/**
 *  上传文件
 *
 *  @param urlStr  上传的地址
 *  @param params  文本参数{name,value} 其中，name是上传的form域的name值，value就是form域的value值
 *  @param dataDic 多媒体数据，{name,id} name是上传的form域的name值，id就是文件的NSData对象,如果有只有多个数据要上传，则id可是data数组
 *  @param success 成功时候的回调
 *  @param failure 失败时候的回调
 */
+ (void)uploadUrl:(NSString *)urlStr parameters:(NSDictionary<NSString *,NSString *> *)params multipartDatas:(NSDictionary<NSString *, id> *)dataDic success:(void (^)(NSData * data) ) success error:(void (^)(NSData * _Nullable data, NSError * _Nullable connectionError))failure ;

/**
 *  得到指定个数的字符串
 *
 *  @param amount 指定的个数
 *
 *  @return 随机字符串
 */
+ (NSString *)randomStringOfAmount:(NSUInteger)amount ;
@end
