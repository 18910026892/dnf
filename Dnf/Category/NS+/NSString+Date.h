//
//  NSString+Date.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/14.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

-(long long)dateStringWithFormateStyle:(NSString *)style;

+(NSInteger)getNowTimestamp;
//时间转化时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
//时间戳转化时间
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;


@end
