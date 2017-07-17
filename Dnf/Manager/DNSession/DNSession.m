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

static DNSession *sharedManager=nil;
@implementation DNSession
+ (DNSession *)sharedSession{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DNSession alloc] init];
    
    });
    
    return sharedManager;
}

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

#pragma mark - islogin
- (BOOL)isLogin{
    if(self.uid){
        
        NSLog(@" 用户ID 是 %@",self.uid);
        return YES;
    }
    return NO;
}

#pragma mark -
- (void)setValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getValueForKey:(NSString *)key{
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
