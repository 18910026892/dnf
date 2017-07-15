//
//  DNSession.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSession.h"

static NSString *const kSessionUid         = @"kSessionUid";
static NSString *const kSessionNickName    = @"kSessionNickName";
static NSString *const kSessionAvatar         = @"kSessionAvatar";
static NSString *const kSessionSex    = @"kSessionSex";
static NSString *const kSessionBirthday     = @"kSessionBirthday";

static DNSession *sharedManager=nil;
@implementation DNSession
+ (DNSession *)sharedSession{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DNSession alloc] init];
    
    });
    
    return sharedManager;
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
        return YES;
    }
    return NO;
}

#pragma mark -
//设置value+key
- (void)setValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString *)getValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}


@end
