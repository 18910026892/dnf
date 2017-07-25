//
//  DLBaseUserModel.h
//  Dreamer-ios-client
//
//  Created by Ant on 17/1/8.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLBaseUserModel : NSObject
/** 用户id */
@property (copy, nonatomic) NSString * uid;
/** 靓号 */
@property (copy, nonatomic) NSString * vid;

/**校园名称*/
@property (nonatomic, copy) NSString *vs_school;

/** 用户头像地址 */
@property (copy, nonatomic) NSString * avatar;

/** 用户昵称 */
@property (copy, nonatomic) NSString * nickName;

/** 用户签名 */
@property (nonatomic, copy) NSString * signature;

/** 性别，F:女 M:男 N:未知 */
@property (copy, nonatomic) NSString *gender;

/** 生日 */
@property (copy, nonatomic) NSString * birth;

/** 用户星座 */
@property (nonatomic, copy) NSString *astro;

/** 位置 例: 北京朝阳区 */
@property (copy, nonatomic) NSString * location;

/** 地区 例: china */
@property (copy, nonatomic) NSString * region;

/**是否是认证用户*/
@property (nonatomic, assign) BOOL isVerified;

/**用户认证信息， 例: 认证程序员*/
@property (nonatomic, copy) NSString * credentials;

/**用户认证类型， 例: 1:个人 2:团体、机构*/
@property (nonatomic, assign) NSInteger credentialType;

/** 真实姓名 */
@property (copy, nonatomic) NSString * realName;

/** 用户经验值 */
@property (nonatomic, assign) long long exp;

/** 用户等级 */
@property (assign, nonatomic) int level;

/** 勋章的 json 字典 数组 {kind:’tuhao’, medal:’xx’}  */
@property (nonatomic, strong) DLJSONArray *medals;

/**点赞数*/
@property (nonatomic, assign) long praises;

/**关注的人*/
@property (nonatomic, assign) NSInteger followings;
/**粉丝数量*/
@property (nonatomic, assign) NSInteger followers;
/*上一次刷新的粉丝数量*/
@property(nonatomic,assign)NSInteger preFollowers;

@end
