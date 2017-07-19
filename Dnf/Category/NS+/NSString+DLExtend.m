//
//  NSString+DLExtend.m
//  Dreamer
//
//  Created by 景中杰 on 16/8/30.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "NSString+DLExtend.h"

@implementation NSString (DLExtend)

+(BOOL)isEmpty:(NSString*)string
{
    if (!string || string.length == 0) {
        return YES;
    }
    else{
        return NO;
    }
}

+(NSString *)transformCharacter:(NSString*)sourceStr
{
    //先将原字符串转换为可变字符串
    NSMutableString *ms = [NSMutableString stringWithString:sourceStr];
    
    if (ms.length) {
        //将汉字转换为拼音
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformToLatin, NO);
        //将拼音的声调去掉
        CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics,NO);
        //将字符串所有字母大写
        NSString *upStr = [ms uppercaseString];
        //截取首字母
        NSString *firstStr = [upStr substringToIndex:1];
        return firstStr;
    }
    return nil;
}


+(NSUInteger)textLength: (NSString *) text{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}

+(NSString *)substr:(NSString *)text andLength:(NSInteger)length{
    
    NSString *str = @"";
    NSUInteger asciiLength = 0;
    
    unichar uc;
    for (NSUInteger i = 0; i < text.length; i++) {
        
        uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
        
        if (asciiLength<=length) {
            NSString* str1 = [NSString stringWithFormat:@"%C",uc];
            str = [NSString stringWithFormat:@"%@%@",str,str1];
        }
    }
    
    return str;
    
}

- (NSString *)safeString
{
    if ([NSString isEmpty:self] || [self isEqualToString:@"null"]) {
        return @"";
    }
    return self;
}

@end
