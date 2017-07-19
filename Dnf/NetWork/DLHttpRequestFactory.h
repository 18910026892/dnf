//
//  DLHttpRequestFactory.h
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLHttpsBusinesRequest.h"

@interface DLHttpRequestFactory : NSObject

/**
 获取验证码
 
 @param mobileNum 手机号
 @param type      参数类型  type: login/reg/bind/forgot不传默认login
 
 @return request
 */
+(nonnull DLHttpsBusinesRequest*)getCodeWithMobileNum:(nonnull NSString *)mobileNum
                                                 type:(nonnull NSString *)type;


/**
 快速登录 刷新token
 
 @param token token 必穿
 
 @return request
 */
+(nonnull DLHttpsBusinesRequest*)fastLogin:(nonnull NSString *)token;



/**
 用户登录
 
 @param userName 用户名 手机号
 @param password 密码
 @param captchCode 图片验证码 可选参数 没有传 nil
 
 @return request
 */
+(nonnull DLHttpsBusinesRequest*)userLoginUserName:(nonnull NSString *)userName
                                          passwoed:(nonnull NSString *)password
                                           captcha:(nonnull NSString *)captchCode;


/**
 同步个人信息
 
 @param token    token
 @param profiles 待修改项
 
 @return request
 */
+(nonnull DLHttpsBusinesRequest*)synchUserInfoWithToken:(nonnull NSString *)token
                                                profile:(nonnull NSString *)profiles;


@end

