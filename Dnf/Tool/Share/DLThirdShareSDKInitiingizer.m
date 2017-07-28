//
//  DLThirdShareSDKInitiingizer.m
//  Dreamer-ios-client
//
//  Created by Ant on 2017/6/3.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import "DLThirdShareSDKInitiingizer.h"

//********* ShareSDK头文件 *********//
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//********* 腾讯平台头文件 *********//

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//********* 微信头文件 *********//

#import "WXApi.h"

//********* 新浪微博头文件  *********//
#import "WeiboSDK.h"


#import <ShareSDK/ShareSDK.h>

static DLJSONObject *ShareSDKKeys; //地址列表

@implementation DLThirdShareSDKInitiingizer

/**
 设置appkey列表
 */
+ (void)setShareSDKKeys:(DLJSONObject *)SDKKeys
{
    ShareSDKKeys = SDKKeys;
}

+ (void)registerApp
{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeWechat),
                                        ]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                                 switch (platformType) {
                                     case SSDKPlatformTypeWechat:
                                         
                                         [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                         
                                         break;
                                         
                                     case SSDKPlatformTypeQQ:
                                         
                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                         
                                         break;
                                         
                                     case SSDKPlatformTypeSinaWeibo:
                                         
                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                         
                                         break;
                                
                                         
                                     default:
                                         break;
                                 }
                                 
                                 
                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                 
                                 switch (platformType) {
                                         
                                     case SSDKPlatformTypeSinaWeibo:
                                         
                                         [appInfo SSDKSetupSinaWeiboByAppKey:[ShareSDKKeys optString:@"k_appKey_sinaAppKey" defaultValue:nil]
                                                                   appSecret:[ShareSDKKeys optString:@"k_appKey_sinaAppSecret" defaultValue:nil]
                                                                 redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                                                    authType:SSDKAuthTypeBoth];
                                         
                                         break;
                                         
                                     case SSDKPlatformTypeQQ:
                                         
                                         [appInfo SSDKSetupQQByAppId:[ShareSDKKeys optString:@"k_appKey_QQAppID" defaultValue:nil]
                                                              appKey:[ShareSDKKeys optString:@"k_appKey_QQAppKey" defaultValue:nil]
                                                            authType:SSDKAuthTypeBoth];
                                         
                                         break;
                                         
                                     case SSDKPlatformTypeWechat:
                                     {
                                     
                                         
                                         if ( [[DNSession sharedSession]isLogin] == YES)
                                         {
                                             [appInfo SSDKSetupWeChatByAppId:@"wxd6e4cd2feff4a7ed"
                                                                   appSecret:@"a3f51154e37c0f85f10988fc402b965e"];
                                             
                                         }else
                                         {
                                             [appInfo SSDKSetupWeChatByAppId:[ShareSDKKeys optString:@"k_appKey_weixinAppID" defaultValue:nil]
                                                                   appSecret:[ShareSDKKeys optString:@"k_appKey_weixinAppSecret" defaultValue:nil]];
                                             
                                         }
                                         
                                     }
                                         break;
                                     case SSDKPlatformTypeTwitter:
                                         
                                         
                                         [appInfo SSDKSetupTwitterByConsumerKey:[ShareSDKKeys optString:@"k_appKey_twitterAppID"
                                                                                           defaultValue:nil]
                                                                 consumerSecret:[ShareSDKKeys
                                                                                 optString:@"k_appKey_twitterAppSecret" defaultValue:nil]
                                                                    redirectUri:@"http://weiyingonline.com"];
                                         
                                         break;
                                         
                                     case SSDKPlatformTypeInstagram:
                                         
                                         
                                         [appInfo SSDKSetupInstagramByClientID:[ShareSDKKeys
                                                                                optString:@"k_appKey_instagramAppID" defaultValue:nil]
                                                                  clientSecret:[ShareSDKKeys
                                                                                optString:@"k_appKey_instagramAppSecret" defaultValue:nil]
                                                                   redirectUri:@"http://weiyingonline.com"];
                                         
                                         break;
                                     case SSDKPlatformTypeFacebook:
                                         
                                         [appInfo SSDKSetupFacebookByApiKey:[ShareSDKKeys optString:@"k_appKey_faceBookAppID"
                                                                                       defaultValue:nil]
                                                                  appSecret:[ShareSDKKeys
                                                                             optString:@"k_appKey_faceBookAppSecret"
                                                                             defaultValue:nil]
                                                                   authType:SSDKAuthTypeBoth];
                                         
                                         
                                         break;
                                     default:
                                         break;
                                 }
                                 
                             }];
}

@end
