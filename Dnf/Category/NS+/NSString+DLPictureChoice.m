//
//  NSString+DLPictureChoice.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/28.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "NSString+DLPictureChoice.h"

@implementation NSString (DLPictureChoice)

- (NSString *)stringWithSizeString:(NSString *)str
{
    if (!str) return self;
    
    
    if (!self) {
        return nil;
    }
    
    if ([self containsString:@"http"]==NO||[self containsString:@"https"]==NO) {
        return self;
    }
    
    NSArray *array = [self componentsSeparatedByString:@"."];
    
    if (!array) return nil;
    
    NSString *subUrl = [array lastObject];
    
    if ([subUrl isEqualToString:@""]||[subUrl isEqualToString:@"<null>"]|| !subUrl || [subUrl isEqualToString:@"(null)"] || [subUrl isKindOfClass:NSNull.class]) { // 没有后缀 或者 地址为空
        return nil;
    }
    
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@".%@",subUrl]];
    return [self stringByReplacingCharactersInRange:range
                                         withString:[NSString stringWithFormat:@"_%@.%@",str,subUrl]];
    
}

@end
