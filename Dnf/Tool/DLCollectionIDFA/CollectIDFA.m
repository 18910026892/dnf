//
//  CollectIDFA.m
//  Dreamer
//
//  Created by Ant on 16/10/31.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "CollectIDFA.h"
#import <AdSupport/ASIdentifierManager.h>
#import "NSString+MD5.h"

static int collectCount =0;

@implementation CollectIDFA

/**
 收集广告标示符
 */

+ (void)collectIdfa
{
    
}

+(NSString *)createMD5:(NSDictionary *)parameter time:(int64_t)time
{
//    NSArray *oldArray = [parameter allKeys];
//    NSArray *newArray = [oldArray sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *sign = @"";
    sign = [sign stringByAppendingFormat:@"&r=%lld",time];
    sign = [sign stringByAppendingFormat:@"&registerKey=%@",HTTP_KEY];
    
    // NSLog(@"sign = %@",sign);
    
    return [NSString stringToMD5:sign];
}


/**
 活取广告标示符

 @return 返回广告标示符的字符串
 */
+ (NSString *)getADid
{
    NSString *idfa = nil;
    
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        return idfa;
    }
    
    return idfa;
}

+(NSString *)getIDFV {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
@end
