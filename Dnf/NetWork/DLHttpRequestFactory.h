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

//云控
+(nonnull DLHttpsBusinesRequest*)getConfigs:(nonnull NSString *)names;

//vr列表
+(nonnull DLHttpsBusinesRequest*)getVrNumber:(nonnull NSString*)number offset:(nonnull NSString*)offset;

//party列表
+(nonnull DLHttpsBusinesRequest*)getPartyNumber:(nonnull NSString*)number offset:(nonnull NSString*)offset;

//免费相册
+(nonnull DLHttpsBusinesRequest*)getFreePhotoList:(nonnull NSString*)number offset:(nonnull NSString*)offset;

//付费相册
+(nonnull DLHttpsBusinesRequest*)getPayPhotoList:(nonnull NSString*)number offset:(nonnull NSString*)offset;

//推荐相册
+(nonnull DLHttpsBusinesRequest*)recommendAlbum;

//免费视频
+(nonnull DLHttpsBusinesRequest*)getFreeVideoList:(nonnull NSString*)number offset:(nonnull NSString*)offset;

//付费视频
+(nonnull DLHttpsBusinesRequest*)getPayVideoList:(nonnull NSString*)number offset:(nonnull NSString*)offset;


//增加观看数
+(nonnull DLHttpsBusinesRequest*)increaseCount:(nonnull NSString*)type relateid:(nonnull NSString*)relateid;


//三方登录
+(nonnull DLHttpsBusinesRequest*)thirdLogInWithParamer:(nonnull  NSDictionary*)Paramer;
+(nonnull DLHttpsBusinesRequest*)getQQUnionidAccessTocken:(nonnull NSString *)accessTocken;

+(nonnull DLHttpsBusinesRequest*)getCodeWithMobileNum:(nonnull NSString *)mobileNum
                                                 type:(nonnull NSString *)type;

+(nonnull DLHttpsBusinesRequest*)fastLogin:(nonnull NSString *)token;

+(nonnull DLHttpsBusinesRequest*)userLoginUserName:(nonnull NSString *)userName
                                          passwoed:(nonnull NSString *)password
                                           captcha:(nonnull NSString *)captchCode;

+(nonnull DLHttpsBusinesRequest*)synchUserInfoWithToken:(nonnull NSString *)token
                                                profile:(nonnull NSString *)profiles;


+(nonnull DLHttpsBusinesRequest*)getMyUserInfo;

+(nonnull DLHttpsBusinesRequest*)getUserInfo:(nonnull NSString*)userId;

+(nonnull DLHttpsBusinesRequest*)userRegisterMobile:(nonnull NSString *)mobileNum
                                           password:(nonnull NSString *)password
                                               code:(nonnull NSString *)code
                                           nickName:(nonnull NSString *)nickName;

+(nonnull DLHttpsBusinesRequest*)getEmailCodeWithEmail:(nonnull NSString *)email
                                                  type:(nonnull NSString *)type;

+(nonnull DLHttpsBusinesRequest*)registerEmailWithEmail:(nonnull NSString *)email
                                               password:(nonnull NSString *)password
                                                   code:(nonnull NSString *)code
                                               nickName:(nonnull NSString *)name;


//邮箱密码修改
+(nonnull DLHttpsBusinesRequest*)resetPassWordUserName:(nonnull NSString *)userName
                                              passWord:(nonnull NSString *)passWord
                                                  code:(nonnull NSString *)code
                                                  weak:(NSString *)weak;


+(nonnull DLHttpsBusinesRequest*)checkIsVip;


+(nonnull DLHttpsBusinesRequest*)uplodImage:(nonnull UIImage *)image
                                       kind:(nonnull NSString *)kind;



+(nonnull DLHttpsBusinesRequest*)getProduct;


+(nonnull DLHttpsBusinesRequest*)shareLiveWithType:(nonnull NSString*)type
                                            author:(nonnull NSString*)authorid
                                          relateid:(nonnull NSString*)relateid
                                            target:(nonnull NSString*)target
                                             title:(nonnull NSString*)title;


+(nonnull DLHttpsBusinesRequest*)shareCallBackWithType:(nonnull NSString*)type
                                                   uid:(nonnull NSString*)uid
                                              relateid:(nonnull NSString*)relateid
                                                target:(nonnull NSString*)target
                                               shareid:(nonnull NSString*)shareid;


+(nonnull DLHttpsBusinesRequest*)checkHasNewMessage;

+(nonnull DLHttpsBusinesRequest*)getMessageListWithMessageid:(nonnull NSString*)messageid;



+(nonnull DLHttpsBusinesRequest*)getRecordListWithNumber:(nonnull NSString*)number
                                                  offset:(nonnull NSString*)offset;
+(nonnull DLHttpsBusinesRequest*)getCollectionListWithNumber:(nonnull NSString*)number
                                                  offset:(nonnull NSString*)offset;
+(nonnull DLHttpsBusinesRequest*)deleteCollectionWithFavoriteid:(nonnull NSString*)favoriteid;
+(nonnull DLHttpsBusinesRequest*)deleteRecordWithAccessidid:(nonnull NSString*)accessidid;

+(nonnull DLHttpsBusinesRequest*)addRecordResource:(nonnull NSString*)resource
                                  relationid:(nonnull NSString*)relationid;

+(nonnull DLHttpsBusinesRequest*)addCollecionResource:(nonnull NSString*)resource
                                        relationid:(nonnull NSString*)relationid;

+(nonnull DLHttpsBusinesRequest*)recommendVideoResource:(nonnull NSString*)resource
                                        relationid:(nonnull NSString*)relationid;

+(nonnull DLHttpsBusinesRequest*)getPhoto:(nonnull NSString*)albumid;


//充值相关
+(nonnull DLHttpsBusinesRequest*)topUpWithSource:(nonnull NSString*)source
                                          amount:(nonnull NSString*)amount
                                          userid:(nonnull NSString*)userToken
                                        currency:(nonnull NSString*)currency
                                       productid:(nonnull NSString*)productid;


+(nonnull DLHttpsBusinesRequest*)alipayPayWithOrderId:(nonnull NSString *)orderId
                                            andStatus:(nonnull NSString *)status;
@end

