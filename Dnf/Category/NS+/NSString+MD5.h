//
//  NSString+MD5.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/19.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+ (NSString *)stringToMD5:(NSString *)str;

// MD5小写
+ (NSString *)MD5a:(NSString *)str;

- (NSString *)URLEncodedString;

-(NSString *)URLEncodedString2;


/**
 获取文件的MD5
 
 @param path 文件路径
 
 @return MD5 字符串
 */
+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
