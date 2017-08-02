//
//  DLHttpRequestFactory.m
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "DLHttpRequestFactory.h"
#import <AdSupport/ASIdentifierManager.h>
#import "CollectIDFA.h"
#import "NSString+MD5.h"
#import "DLLocationManager.h"
#include <CoreFoundation/CFBase.h>

@implementation DLHttpRequestFactory


+(nonnull DLHttpsBusinesRequest*)thirdLogInWithParamer:(nonnull  NSDictionary*)Paramer
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/active"
                                                                     parameter:Paramer
                                                                        method:DLHttpRequestMethodGet];
    
    request.isShowLoading    = YES;
    request.isShowErrorToast = YES;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)getQQUnionidAccessTocken:(nonnull NSString *)accessTocken
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"https://graph.qq.com/oauth2.0/me"
                                                                        method:DLHttpRequestMethodGet];
    
    request.isNeedAddcommonParameter = NO; // 不添加公共参数
    
    request.responseType             = DLResponseTypeData;
    
    request.isShowErrorToast = NO;
    
    [request addParameter:accessTocken key:@"access_token"];
    [request addParameter:[NSString stringWithFormat:@"%d",1] key:@"unionid"];
    
    return request;
    
}



+(nonnull DLHttpsBusinesRequest*)getCodeWithMobileNum:(nonnull NSString *)mobileNum
                                                 type:(nonnull NSString *)type
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/getCode"
                                                                        method:DLHttpRequestMethodGet];

    request.isShowLoading = NO;
    request.isShowErrorToast = YES;
    
    [request addParameter:mobileNum key:@"mobile"];
    [request addParameter:type key:@"type"];
    
    return request;
    
}

+(nonnull DLHttpsBusinesRequest*)userRegisterMobile:(nonnull NSString *)mobileNum
                                           password:(nonnull NSString *)password
                                               code:(nonnull NSString *)code
                                           nickName:(nonnull NSString *)nickName
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/register"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:mobileNum key:@"mobile"];
    [request addParameter:[NSString stringToMD5:password] key:@"password"];
    [request addParameter:code key:@"code"];
    [request addParameter:nickName key:@"nickname"];
    request.isShowLoading = YES;
    request.isShowErrorToast = YES;
    
    
    return request;
    
}



+(nonnull DLHttpsBusinesRequest*)userLoginUserName:(nonnull NSString *)userName
                                          passwoed:(nonnull NSString *)password
                                           captcha:(nonnull NSString *)captchCode
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/login"
                                                                        method:DLHttpRequestMethodGet];
    [request addParameter:userName key:@"username"];
    [request addParameter:[NSString stringToMD5:password] key:@"password"];
    request.isShowErrorToast = NO;
    
    if (captchCode) {
        [request addParameter:captchCode key:@"captcha"];
    }
    
    request.isShowLoading = YES;
    return request;
    
}


+(nonnull DLHttpsBusinesRequest*)getEmailCodeWithEmail:(nonnull NSString *)email
                                                  type:(NSString *)type
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/getEmailCode"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:email key:@"email"];
    [request addParameter:type key:@"type"];
    request.isShowLoading = YES;
    request.isShowErrorToast = YES;
    
    return request;
    
}

+(nonnull DLHttpsBusinesRequest*)registerEmailWithEmail:(nonnull NSString *)email
                                               password:(nonnull NSString *)password
                                                   code:(nonnull NSString *)code
                                               nickName:(nonnull NSString *)name
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/registerEmail"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:email key:@"email"];
    [request addParameter:code key:@"code"];
    [request addParameter:[NSString stringToMD5:password] key:@"password"];
    [request addParameter:name key:@"nickname"];
    request.isShowLoading = YES;
    request.isShowErrorToast = YES;
    
    return request;
    
}

+(nonnull DLHttpsBusinesRequest*)resetPassWordUserName:(nonnull NSString *)userName
                                              passWord:(nonnull NSString *)passWord
                                                  code:(nonnull NSString *)code
                                                  weak:(NSString *)weak
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/resetPassword"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:userName key:@"username"];
    [request addParameter:[NSString stringToMD5:passWord] key:@"password"];
    [request addParameter:code key:@"code"];
    
    if (weak) {
        [request addParameter:weak key:@"weak"];
    }
    
    request.isShowLoading = YES;
    request.isShowErrorToast = YES;
    
    return request;
    
}



+(nonnull DLHttpsBusinesRequest*)fastLogin:(nonnull NSString *)token
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/fastLogin"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:token key:@"token"];
    
    //上报idfa
    [request addParameter:[CollectIDFA getADid] key:@"idfa"];
    request.isShowErrorToast = NO;
    
    
    return request;
    
}

+(nonnull DLHttpsBusinesRequest*)synchUserInfoWithToken:(nonnull NSString *)token
                                                profile:(nonnull NSString *)profiles
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://profile/sync"
                                                                        method:DLHttpRequestMethodGet];
    
    request.isShowLoading    = YES;
    request.isShowErrorToast = YES;
    
    [request addParameter:token key:@"token"];
    [request addParameter:profiles key:@"profiles"];
    
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)checkIsVip
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://bag/getVip"
                                      
                                                                        method:DLHttpRequestMethodGet];
    
    
    
    [request addParameter:@"vip" key:@"type"];
    request.isShowLoading = NO;
    request.isShowErrorToast = NO;

    return request;
}



+(nonnull DLHttpsBusinesRequest*)uplodImage:(nonnull UIImage *)image
                                       kind:(NSString *)kind
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"http://bed.dnfe.tv/photo/upload"
                                                                        method:DLHttpRequestMethodUplodeImage];
    [request addParameter:kind key:@"kind"];
    
    [request addUploadImage:image filename:[NSString stringWithFormat:@"%@.jpg",kind] name:@"file" mimeType:@"multipart/form-data"];
    
    request.isShowLoading    = YES;
    request.isShowErrorToast = YES;
    
    return request;
    
}

#pragma mark -- 个人中心图片上传

+(nonnull DLHttpsBusinesRequest*)uplodProfileImageURL:(nonnull NSString *)imageURL imageSize:(CGSize)imageSize
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://image/add"
                                                                        method:DLHttpRequestMethodPost];
    
    NSString *longitudeString = [DNSession sharedSession].longitude;
    if (longitudeString.length == 0 || [longitudeString isEqualToString:@"0"]) {
        longitudeString = @"1";
    }
    
    NSString *latitudeString = [DNSession sharedSession].latitude;
    if (latitudeString.length == 0 || [latitudeString isEqualToString:@"0"]) {
        latitudeString = @"1";
    }
    
    NSString *pointString = [NSString stringWithFormat:@"%@,%@", longitudeString, latitudeString];
    NSString *city = [DNSession sharedSession
                      ].city;
    NSString *regon = [DNSession sharedSession].regon;
    NSString *width = [NSString stringWithFormat:@"%f", imageSize.width];
    NSString *height = [NSString stringWithFormat:@"%f", imageSize.height];
    
    [request addParameter:imageURL key:@"url"];
    [request addParameter:pointString key:@"point"];
    [request addParameter:width key:@"width"];
    [request addParameter:height key:@"height"];
    [request addParameter:@"" key:@"content"];
    [request addParameter:@"" key:@"province"];
    [request addParameter:city key:@"city"];
    [request addParameter:regon key:@"district"];
    [request addParameter:@"" key:@"location"];
    
    
    request.isShowLoading    = YES;
    request.isShowErrorToast = YES;
    
    return request;
    
}


+(nonnull DLHttpsBusinesRequest*)getProduct
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://product/getProduct"
                                      
                                                                        method:DLHttpRequestMethodGet];
    
    
  
    [request addParameter:@"vip" key:@"type"];

    request.isShowLoading = NO;
    request.isShowErrorToast = NO;
    
    return request;
}


+(nonnull DLHttpsBusinesRequest*)shareLiveWithType:(nonnull NSString*)type
                                            author:(nonnull NSString*)authorid
                                          relateid:(nonnull NSString*)relateid
                                            target:(nonnull NSString*)target
                                             title:(nonnull NSString*)title;
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://share/index"
                                      
                                                                        method:DLHttpRequestMethodGet];
    
    
    [request addParameter:type key:@"type"];
    
    [request addParameter:authorid key:@"author"];
    
    [request addParameter:relateid key:@"relateid"];
    
    [request addParameter:target key:@"target"];
    
    [request addParameter:title key:@"title"];
    
    request.isShowLoading = YES;
    request.isShowErrorToast = NO;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)shareCallBackWithType:(nonnull NSString*)type
                                                   uid:(nonnull NSString*)uid
                                              relateid:(nonnull NSString*)relateid
                                                target:(nonnull NSString*)target
                                               shareid:(nonnull NSString*)shareid

{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://share/callback"
                                      
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:type key:@"type"];
    
    [request addParameter:uid key:@"uid"];
    
    [request addParameter:relateid key:@"relateid"];
    
    [request addParameter:target key:@"target"];
    
    [request addParameter:shareid key:@"shareid"];
    
    
    request.isShowErrorToast = YES;
    
    
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)getMyUserInfo
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://user/getMyUserInfo"
                                                                        method:DLHttpRequestMethodGet];
    
     [request addParameter:[DNSession sharedSession].token key:@"token"];
    request.isShowErrorToast = NO;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)checkHasNewMessage
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://message/getNoRead"
                                                                        method:DLHttpRequestMethodGet];
 
    request.isShowErrorToast = NO;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)getMessageListWithMessageid:(nonnull NSString*)messageid

{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://message/getMessage"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:messageid key:@"messageid"];
    [request addParameter:@"vip" key:@"type"];
    request.isShowErrorToast = NO;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)getRecordListWithNumber:(nonnull NSString*)number
                                                    offset:(nonnull NSString*)offset
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://access/getAccess"
                                                                        method:DLHttpRequestMethodGet];
    
    
    [request addParameter:@"video|vr" key:@"resource"];
    [request addParameter:number key:@"num"];
    [request addParameter:offset key:@"offset"];
    request.isShowErrorToast = NO;
    request.isShowLoading = NO;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)getCollectionListWithNumber:(nonnull NSString*)number
                                                      offset:(nonnull NSString*)offset
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://favorite/getFavorite"
                                                                        method:DLHttpRequestMethodGet];
    
    
    [request addParameter:@"video|vr" key:@"resource"];
    [request addParameter:number key:@"num"];
    [request addParameter:offset key:@"offset"];
    request.isShowErrorToast = NO;
    request.isShowLoading = NO;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)deleteCollectionWithFavoriteid:(nonnull NSString*)favoriteid
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://favorite/cancel"
                                                                        method:DLHttpRequestMethodGet];
    
    
    [request addParameter:favoriteid key:@"favoriteid"];
    request.isShowLoading = YES;
     request.isShowErrorToast = YES;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)deleteRecordWithAccessidid:(nonnull NSString*)accessidid;
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://access/cancel"
                                                                        method:DLHttpRequestMethodGet];
    
    
    [request addParameter:accessidid key:@"accessid"];
 
    request.isShowLoading = YES;
    request.isShowErrorToast = YES;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)addRecordResource:(nonnull NSString*)resource
                                        relationid:(nonnull NSString*)relationid
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://access/add"
                                                                        method:DLHttpRequestMethodGet];
    
    
    [request addParameter:resource key:@"resource"];
    [request addParameter:relationid key:@"relationid"];
    
    request.isShowLoading = NO;
    request.isShowErrorToast = NO;
    
    return request;
}

+(nonnull DLHttpsBusinesRequest*)addCollecionResource:(nonnull NSString*)resource
                                           relationid:(nonnull NSString*)relationid
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://favorite/add"
                                                                        method:DLHttpRequestMethodGet];
    
    
    [request addParameter:resource key:@"resource"];
    [request addParameter:relationid key:@"relationid"];
    
    request.isShowLoading = YES;
    request.isShowErrorToast = YES;
    
    return request; 
}

+(nonnull DLHttpsBusinesRequest*)recommendVideoResource:(nonnull NSString*)resource
                                             relationid:(nonnull NSString*)relationid;
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://recommend/next"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:resource key:@"resource"];
    [request addParameter:relationid key:@"relationid"];
    
    [request addParameter:@"20" key:@"num"];
    request.isShowErrorToast = NO;

    return request;
}
+(nonnull DLHttpsBusinesRequest*)getPhoto:(nonnull NSString*)albumid
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://photo/getPhoto"
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:albumid key:@"albumid"];
    [request addParameter:@"100" key:@"num"];
    request.isShowLoading = YES;
    
    return request;
}




+(nonnull DLHttpsBusinesRequest*)topUpWithSource:(nonnull NSString*)source
                                          amount:(nonnull NSString*)amount
                                          userid:(nonnull NSString*)userToken
                                        currency:(nonnull NSString*)currency
                                       productid:(nonnull NSString*)productid


{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"msvr://deposit/prepare"
                                      
                                                                        method:DLHttpRequestMethodGet];
    
    [request addParameter:source key:@"source"];
    [request addParameter:amount key:@"amount"];
    [request addParameter:userToken key:@"userid"];
    [request addParameter:currency key:@"currency"];
    [request addParameter:productid key:@"productid"];
    request.isShowErrorToast = YES;
    request.isShowLoading = YES;
    
    return request;
}


+(nonnull DLHttpsBusinesRequest*)alipayPayWithOrderId:(nonnull NSString *)orderId
                                            andStatus:(nonnull NSString *)status
{
    DLHttpsBusinesRequest *request = [[DLHttpsBusinesRequest alloc]initWithUrl:@"http://api.dreamlive.tv/deposit/notify_alipay"
                                      
                                                                        method:DLHttpRequestMethodGet];
    [request addParameter:orderId key:@"orderid"];
    [request addParameter:status key:@"status"];
    
    return request;
}




@end
