//
//  NSString+DLExtend.h
//  Dreamer
//
//  Created by 景中杰 on 16/8/30.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DLExtend)

/**
 *  测试字符串是否为 nil 或空内容，如果是则返回 YES，否则返回 NO。
 *
 *  @param string 一个字符串
 *
 *  @return 测试字符串是否为 nil 或空内容，如果是则返回 YES，否则返回 NO。
 */
+(BOOL)isEmpty:(NSString*)string;

/**
 *  汉子转换拼音并截取首字母为大写
 *
 *  @param sourceStr 原文
 *
 *  @return 大写首字母
 */
+(NSString *)transformCharacter:(NSString*)sourceStr;

/**
 判断“字符”串的字符长度，一个汉子两个字符
 
 @param text 要判断的字符串
 @return 字符长度
 */
+(NSUInteger)textLength:(NSString *) text;


/**
 字符串按字符长度截取，一个汉子两个字符
 
 @param text 要截取的字符串
 @param length 截取的长度
 @return 截取后的字符串
 */
+(NSString *)substr:(NSString *)text andLength:(NSInteger)length;

/**
 不会返回显示(null)的字符串
 @return 检查后的字符串
 */

- (NSString *)safeString;

@end
