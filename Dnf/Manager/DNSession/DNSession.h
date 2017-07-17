//
//  DNSession.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNSession : NSObject

+ (DNSession *)sharedSession;

//用户账号
@property(nonatomic,copy)NSString * userAccount;

//用户密码
@property(nonatomic,copy)NSString * passWord;

//用户手机号
@property(nonatomic,copy)NSString * phone;

//用户email
@property(nonatomic,copy)NSString * email;

//用户token
@property(nonatomic,copy)NSString * token;

//用户id
@property(nonatomic,copy)NSString * uid;

//用户昵称
@property(nonatomic,copy)NSString * nickname;

//用户头像
@property(nonatomic,copy)NSString * avatar;

//用户昵称
@property(nonatomic,copy)NSString * sex;

//用户生日
@property(nonatomic,copy)NSString * birthday;


-(void)removeUserInfo;
-(BOOL)isLogin;
@end
