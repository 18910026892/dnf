//
//  NSString+Date.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/14.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
-(long long)dateStringWithFormateStyle:(NSString *)style{
    NSDateFormatter * formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:style];
    NSDate * date=[formate dateFromString:self];
    NSTimeInterval interval=[date timeIntervalSince1970];
    
    return interval*1000;
}
@end
