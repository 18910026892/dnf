//
//  DNConfig.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/8.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNConfig.h"

static NSString *const kConfigAudit            = @"kConfigAudit";
static NSString *const kConfigStore            = @"kConfigStore";

static DNConfig *sharedConfig=nil;

@implementation DNConfig

+ (DNConfig *)sharedConfig{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[DNConfig alloc] init];
        
    });
    
    return sharedConfig;
}

-(void)setStore:(BOOL)store
{
     [self setBoolValue:store forkey:kConfigStore];
}

-(void)setAudit:(BOOL)audit
{
    [self setBoolValue:audit forkey:kConfigAudit];
}
-(BOOL)audit
{
    return [self getBoolValueForKey:kConfigAudit];
}

-(BOOL)store
{
    return [self getBoolValueForKey:kConfigStore];
}


-(void)setBoolValue:(BOOL)value forkey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)getBoolValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
