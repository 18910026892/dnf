//
//  DLShareModel.h
//  Dreamer-ios-client
//
//  Created by Ant on 2017/5/6.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLShareModel : NSObject

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareImageUrl;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *anchorID;
@property (nonatomic, copy) NSString *shareId;
/**
 （开播前，直播中，个人等） */
@property (nonatomic, copy) NSString *shareType;
@property (nonatomic, copy) NSString *shareTarget;   //分享平台
@property (nonatomic, copy) NSString *resourcesType; //资源类型 图片， 回放，视频...
@property (nonatomic, copy) NSString *liveId;

/**
 资源ID */
@property (nonatomic, copy) NSString *relateid;


/**
 bannerID 根据此 ID 判断是否为banner活动 */
@property (nonatomic, copy) NSString *bannerID;

@end
