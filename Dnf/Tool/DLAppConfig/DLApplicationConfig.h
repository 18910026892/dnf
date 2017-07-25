//
//  DLApplicationConfig.h
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/21.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLJSONObject.h"
#import "DLJSONArray.h"
@interface DLApplicationConfig : NSObject

+ (void)load;

/**
 * 获取服务器地址列表，内容为 config 文件中的 ServerAddress 节点内容。
 * @return 获取服务器地址列表
 */
+(DLJSONObject* _Nullable)getServerAddressList;


/**
 获取shareSDK列表

 @return JsonObject
 */
+(DLJSONObject* _Nullable)getShareSDKKeys;


/**
 我的页面cell列表

 @return jsonArr
 */
+ (DLJSONArray* _Nullable)getMyProfileCellList;

/**
 设置页面cell列表
 
 @return jsonArr
 */
+ (DLJSONArray* _Nullable)getSetUpCellList;

/**
 腾讯buglyappkey

 @return appkey
 */
+(NSString * _Nullable)getTencentBuglyAppkey;

/**
 *  得到当前版本号
 *
 *  @return 版本号
 */
+(int)getCurrentVersion;

/**
 *  得到需要显示当前版本号
 *
 *  @return 版本号
 */
+(NSString *_Nullable)getCurrentVersionDisplay;

/**
 获取ClientName
 @return clientName
 */
+(NSString *_Nullable)getCurrentClientName;

@end
