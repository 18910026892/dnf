//
//  DLThirdShareManager.h
//  Dreamer
//
//  Created by Ant on 16/9/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLJSONObject.h"
@class DLShareModel;

@interface DLThirdShareManager : NSObject


/**
 *  第三方分享 管理器
 *
 *  @return 返回一个管理器单例实例
 */
+ (instancetype)shareInstance;


/**
 设置appkey列表
 */
+ (void)setShareSDKKeys:(DLJSONObject *)SDKKeys;

/**
 *  初始化
 *
 *  @return 返回一个初始化的实例
 */
- (instancetype)init;
/**
 *  分享平台注册APP
 */
- (void)registerApp;

/**
 *  分享到QQ空间
 *
 *  @param model 分享的参数
 */
- (void)shareToQQZoneWithParams:(DLShareModel *)model;

/**
 *  分享到QQ
 *
 *  @param model 分享的参数
 */
- (void)shareToQQWithParams:(DLShareModel *)model;

/**
 *  分享到新浪微博
 *
 *  @param model 分享内容参数
 */
- (void)shareToSinaWeiboWith:(DLShareModel *)model;
/**
 *  分享到微信盆友圈
 *
 *  @param model 分享内容参数
 */
- (void)shareToWechatQuan:(DLShareModel *)model;
/**
 *  分享到微信朋友
 *
 *  @param model 分享的内容参数
 */
- (void)shareToWechat:(DLShareModel *)model;


/**
 分享到FaceBook

 @param model 分享的内容参数
 */
-(void)shareToFaceBook:(DLShareModel *)model;

/**
 分享到Twitter

 @param model 分享的内容参数
 */
-(void)shareToTwitter:(DLShareModel *)model;


/**
 分享到Instragram

 @param model 分享的内容参数
 */
-(void)shareToInstragram:(DLShareModel *)model;
@end
