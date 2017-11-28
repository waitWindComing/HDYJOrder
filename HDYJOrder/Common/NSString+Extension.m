//
//  NSString+Extension.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/16.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
+ (NSString *)md5:(NSString *)string{
    // OC 字符串转换位C字符串
    const char *cStr = [string UTF8String];
    // 16位加密
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    // 1: 需要加密的C字符串
    // 2: 加密的字符串的长度
    // 3: 加密长度
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2]; // 32位
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    // 返回一个32位长度的加密后的字符串
    return [result lowercaseString];
}
@end
