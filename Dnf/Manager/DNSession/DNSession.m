//
//  DNSession.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSession.h"

static NSString *const kSessionAccount        = @"kSessionAccount";
static NSString *const kSessionPassWord       = @"kSessionPassWord";
static NSString *const kSessionEmail          = @"kSessionEmail";
static NSString *const kSessionPhone          = @"kSessionPhone";
static NSString *const kSessionToken          = @"kSessionToken";
static NSString *const kSessionUid            = @"kSessionUid";
static NSString *const kSessionNickName       = @"kSessionNickName";
static NSString *const kSessionAvatar         = @"kSessionAvatar";
static NSString *const kSessionSex            = @"kSessionSex";
static NSString *const kSessionBirthday       = @"kSessionBirthday";
static NSString *const kSessionRegon          = @"kSessionRegon";
static NSString *const kSessionLatitude       = @"kSessionLatitude";
static NSString *const kSessionLongitude      = @"kSessionLongitude";
static NSString *const kSessionCountryCode    = @"kSessionCountryCode";
static NSString *const kSessionCity           = @"kSessionCity";
static NSString *const kSessionChannel        = @"kSessionChannel";
static NSString *const kSessionTimeDifference = @"kSessionTimeDifference";
static NSString *const kSeesionVip            = @"kSeesionVip";


static DNSession *sharedManager=nil;
@implementation DNSession
+ (DNSession *)sharedSession{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DNSession alloc] init];
    
    });
    
    return sharedManager;
}

#pragma mark set
-(void)setUserAccount:(NSString *)userAccount
{
    [self setValue:userAccount forKey:kSessionAccount];
}

-(void)setPassWord:(NSString *)passWord
{
    [self setValue:passWord forKey:kSessionPassWord];
}

-(void)setEmail:(NSString *)email
{
    [self setValue:email forKey:kSessionEmail];
}

-(void)setPhone:(NSString *)phone
{
    [self setValue:phone forKey:kSessionPhone];
}

-(void)setToken:(NSString *)token
{
    [self setValue:token forKey:kSessionToken];
}
-(void)setUid:(NSString *)uid
{
    [self setValue:uid forKey:kSessionUid];
    
}
-(void)setAvatar:(NSString *)avatar
{
    [self setValue:avatar forKey:kSessionAvatar];
}

-(void)setSex:(NSString *)sex
{
    [self setValue:sex forKey:kSessionSex];
}
-(void)setNickname:(NSString *)nickname
{
    [self setValue:nickname forKey:kSessionNickName];
}

-(void)setBirthday:(NSString *)birthday
{
    [self setValue:birthday forKey:kSessionBirthday];
}

-(void)setRegon:(NSString *)regon
{
    [self setValue:regon forKey:kSessionRegon];
}

-(void)setLatitude:(NSString *)latitude
{
    [self setValue:latitude forKey:kSessionLatitude];
}

-(void)setLongitude:(NSString *)longitude
{
    [self setValue:longitude forKey:kSessionLongitude];
}

-(void)setCountryCode:(NSString *)countryCode
{
    [self setValue:countryCode forKey:kSessionCountryCode];
}

-(void)setCity:(NSString *)city
{
    [self setValue:city forKey:kSessionCity];
}

-(void)setChannel:(NSString *)channel
{
    [self setValue:channel forKey:kSessionChannel];
}

-(void)setTimeDifference:(NSInteger)timeDifference
{
    [self setIntegerValue:timeDifference forkey:kSessionTimeDifference];
}



-(void)setVip:(BOOL)vip
{
    [self setBoolValue:vip forkey:kSeesionVip];
}


#pragma mark get
-(NSString*)userAccount
{
    return [self getValueForKey:kSessionAccount];
}

-(NSString*)passWord
{
    return [self getValueForKey:kSessionPassWord];
}

-(NSString*)email
{
    return [self getValueForKey:kSessionEmail];
}

-(NSString*)phone
{
    return [self getValueForKey:kSessionPhone];
}

-(NSString*)token
{

    return [self getValueForKey:kSessionToken];
}

-(NSString*)uid
{
    return [self getValueForKey:kSessionUid];
}

-(NSString*)nickname
{
    return [self getValueForKey:kSessionNickName];
}

-(NSString*)avatar
{
    return [self getValueForKey:kSessionAvatar];
}
-(NSString*)birthday
{
    return [self getValueForKey:kSessionBirthday];
}
-(NSString*)sex
{
    return [self getValueForKey:kSessionSex];
}

-(NSString*)regon
{
    return [self getValueForKey:kSessionRegon];
}

-(NSString*)latitude
{
    return [self getValueForKey:kSessionLatitude];
}

-(NSString*)longitude
{
    return [self getValueForKey:kSessionLongitude];
}

-(NSString*)countryCode
{
    return [self getValueForKey:kSessionCountryCode];
}

-(NSString*)city
{
    return [self getValueForKey:kSessionCity];
}


-(NSString*)channel
{
    return [self getValueForKey:kSessionChannel];
}



-(NSInteger)timeDifference
{
    return [self getIntegerValue:kSessionTimeDifference];
}



-(BOOL)vip
{
    return [self getBoolValueForKey:kSeesionVip];
}

#pragma mark - islogin
- (BOOL)isLogin{
    
    if(IsStrEmpty(self.token)){
 
        return NO;
    }
    return YES;
}

#pragma mark -
- (void)setValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

-(void)setIntegerValue:(NSInteger)value forkey:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)getIntegerValue:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

-(void)setFloatValue:(float)value forkey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (float)getFloatValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}
-(void)setBoolValue:(BOOL)value forkey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)getBoolValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)removeObjectForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)removeUserInfo
{

    [self removeObjectForKey:kSessionUid];
    [self removeObjectForKey:kSessionToken];
    [self removeObjectForKey:kSessionAvatar];
    [self removeObjectForKey:kSessionNickName];
    [self removeObjectForKey:kSessionSex];
    
}


@end
