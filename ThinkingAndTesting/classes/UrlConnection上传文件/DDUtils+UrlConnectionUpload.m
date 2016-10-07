//
//  DDUtils+UrlConnectionUpload.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/22.
//  Copyright © 2016年 dadong. All rights reserved.
//

/*
 
    POST/mobile/dc/upload HTTP/1.1
 
 　 Accept: text/plain
　　Accept-Language: zh-cn
　　Host: 192.168.24.56
　　Content-Type:multipart/form-data;boundary=7db372eb000e2
　　User-Agent: WinHttpClient
　　Content-Length: 3693
　　Connection: Keep-Alive                (上面是Headers,下面才是正文)

　　--7d33a816d302b6

　　Content-Disposition: form-data; name="file"; filename="kn.jpg"

　　Content-Type: image/jpeg

　　(此处省略jpeg文件二进制数据...）
   
    --7d33a816d302b6
    Content-Disposition: form-data; name="userfile1"; filename="E:\s"
    Content-Type: application/octet-stream
    a
    bb
    XXX
    ccc
 
    --7d33a816d302b6
    Content-Disposition: form-data; name="text1"
    foo
 
    --7d33a816d302b6
    Content-Disposition: form-data; name="password1"
 
    --7d33a816d302b6--  (结束的标记，必须是boundary后面--两个-不可省略！！！)
 
 */

#import "DDUtils+UrlConnectionUpload.h"

NSString * const BOUNDARY = @"--71b372eb000e2" ;

@implementation DDUtils (UrlConnectionUpload)

+ (void)constructNewData:(NSData *)newData name:(NSString *)name fileName:(NSString *)fileName type:(DDUploadType)type toData:(NSMutableData *)dataM
{
    if (dataM == nil) {
        dataM = [NSMutableData data] ;
    }
    
    [dataM appendData:[[NSString stringWithFormat:@"--%@\r\n",BOUNDARY]dataUsingEncoding:NSUTF8StringEncoding ]] ;
    
    switch (type) {
        case DDUploadTypeString:
        {
            [dataM appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",name] dataUsingEncoding:NSUTF8StringEncoding ]] ;
            break;
        }
        case DDUploadTypeImage:
        {
            [dataM appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; fileName=\"%@\"\r\n",name,fileName]dataUsingEncoding:NSUTF8StringEncoding ]] ;
            [dataM appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding ]] ;
            break;
        }
        case DDUploadTypeAudio:
        {
            
            break;
        }
        default:
            break;
    }
    
    [dataM appendData:newData] ;
    [dataM appendData:[[NSString stringWithFormat:@"\r\n"]dataUsingEncoding:NSUTF8StringEncoding ]] ;

}

+ (void)uploadUrl:(NSString *)urlStr parameters:(NSDictionary<NSString *,NSString *> *)params multipartDatas:(NSDictionary<NSString *, id> *)dataDic success:(void (^)(NSData * _Nullable data))success error:(void (^)(NSData * _Nullable data, NSError * _Nullable connectionError))failure

{
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]] ;
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@",BOUNDARY] forHTTPHeaderField:@"Content-Type" ] ;
    request.HTTPMethod = @"POST" ;

    NSMutableData *postData = [NSMutableData data] ;
    
    //遍历所有的文本串
    for (NSString *key in params) {
        [self constructNewData:[params[key] dataUsingEncoding:NSUTF8StringEncoding ]  name:key fileName:nil type:DDUploadTypeString toData:postData] ;
    }
    
    for (NSString *name in dataDic){
        id value = dataDic[name] ;
        if ([value isKindOfClass:[NSData class]]) {
            [self constructNewData:dataDic[name] name:name fileName:[NSString stringWithFormat:@"%@.jpg",[DDUtils randomStringOfAmount:10]] type:DDUploadTypeImage toData:postData] ;
        }else if([value isKindOfClass:[NSArray class]]){
            NSArray *value1 = (NSArray *)value ;
            for (int i = 0; i < value1.count ; i ++) {
                [self constructNewData:value1[i] name:name fileName:[NSString stringWithFormat:@"%@.jpg",[DDUtils randomStringOfAmount:10]] type:DDUploadTypeImage toData:postData] ;
            }
        }else{
            @throw [[NSException alloc]initWithName:@"NSInvaildParamException" reason:@"参数不合法" userInfo:dataDic] ;
        }
    }
    

    
    //加上结尾部分
    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n",BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding ]] ;
    
    //设置body
    request.HTTPBody = postData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            //成功
            if (success) {
                success(data) ;
            }
            return  ;
        }
        if (failure) {
            //失败
            failure(data,connectionError) ;
        }
        
    }];
}

+ (NSString *)randomStringOfAmount:(NSUInteger)amount
{
    static NSString * const serialStr = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" ;
    NSMutableString *strM = [NSMutableString string] ;
    for (int i = 0 ; i < amount; i ++) {
        int i = arc4random() % 62 ;
        unichar s = [serialStr characterAtIndex:i] ;
        [strM appendFormat:@"%c",s] ;
    }
    return [strM copy] ;
}
@end
