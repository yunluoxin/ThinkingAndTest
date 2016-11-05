//
//  DDUtils+Security.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/5.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDUtils+Security.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DDUtils (Security)

+ (NSString *)encrypt_MD5:(NSString *)input
{
    const char * cStr = input.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (u_int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    return  output;
}

+ (NSString *)decrypt_RSA:(NSString *)input privateKey:(NSString * ) privateKey
{
    return nil ;
}

+ (NSString *)encrypt_RSA:(NSString * )input publicKey:(NSString *) publicKey
{
    
    return nil ;
}

+ (NSString *)encode_base64:(NSString *)input
{
    NSData * data = [input dataUsingEncoding:NSUTF8StringEncoding] ;
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ] ;
}

+ (NSString *)decode_base64:(NSString * )input
{
    NSData * data = [[NSData alloc] initWithBase64EncodedString:input options:NSDataBase64DecodingIgnoreUnknownCharacters] ;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
}
@end
