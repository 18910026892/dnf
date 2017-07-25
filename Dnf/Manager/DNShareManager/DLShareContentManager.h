//
//  DLShareContentManager.h
//  Dreamer
//
//  Created by Ant on 16/9/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLShareContentManager : NSObject

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (instancetype)shareInstance;

/**
 *  从服务器获取分享内容
 *
 (1)	type:分享类型 开播前(before_live),直播(live),回放(replay),图片(image),视频(video),用户(user)
 (2)	author:资源作者
 (3)	relateid:资源id,直播sn，用户userid等
 (4)	target:分享目的地，wx|weibo|qq|qzone|circle 中文意思 微信好友，微博,QQ,qq空间，微信朋友圈
 (5)	title:标题

 *  @param successBlaock 成功的回调
 *  @param faileBlock    失败回调
 */
- (void)getShareParamWithType:(NSString*)type
                       author:(NSString*)authorid
                     relateid:(NSString*)relateid
                       target:(NSString*)target
                        title:(NSString*)title
                      Success:(void (^)(NSDictionary *))successBlaock
                        faile:(void (^)())faileBlock;

@end
