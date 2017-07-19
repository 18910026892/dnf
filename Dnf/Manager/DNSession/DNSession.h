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

/**
 登陆成功时的服务器时间 */
@property (nonatomic,assign) int64_t loginServerTime;

/** 客户端确认的位置信息 例: china */
@property (nonatomic, copy, nullable) NSString *regon;

/** 当前纬度，注意 NaN 表示没有获取到*/
@property (atomic, copy) NSString * _Nullable latitude;
/** 当前经度，注意 NaN 表示没有获取到*/
@property (atomic, copy) NSString * _Nullable longitude;

/** 国家编码 */
@property (nonatomic, copy) NSString * _Nullable countryCode;
/** 前城市名称*/
@property (atomic,copy,nullable) NSString* city;
/** /最后登录的用户帐号(仅平台帐号) */
@property (atomic,copy,nullable) NSString* lastLoginUserAccount;

@property (nonatomic, copy, nullable) NSString *lastLoginEmailAdress;

@property (nonatomic, copy) NSString * _Nullable lastLoginUserId;

/** 渠道号 */
@property(nonatomic,copy)NSString * _Nullable channel;

/** 当前时间与本地时间的时间差 */
@property(nonatomic, assign)NSInteger timeDifference;

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
