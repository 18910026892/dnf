//
//  DLApplicationConfig.m
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/21.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "DLApplicationConfig.h"
#import "DLFile.h"
#import "DLPath.h"
/**
 * 应用参数配置类，此类中的参数是从 config.json 中读取出来的。
 * 如果 config.json 读取失败则应作会退出。
 */

@implementation DLApplicationConfig

static DLJSONObject *ServerAddressList;
static DLJSONObject *ThirdShareSDKKeys;
static DLJSONArray  *myProfileCellList;
static DLJSONArray  *setUpCellList;
static NSString     *tencentBuglyKey;


static int currentVersion;
static NSString *currentVersionDisplay;
static NSString *currentClientName;
 

+ (void)load
{
    //读取 config.plist 中的配置信息
    //加载ViewController 
    
    NSString *plistPath = [DLPath fullPathFromAssetsInMainBundle:@"config.plist"];
    DLJSONObject *config = [[DLJSONObject alloc] initWithMutableDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:plistPath]];
    
    
    ServerAddressList   = [config getJSONObject:@"ServerAddress"];
    ThirdShareSDKKeys   = [config getJSONObject:@"ShareSDKAppKeys"];
    myProfileCellList   = [config getJSONArray:@"MyProfileCell"];
    setUpCellList       = [config getJSONArray:@"SetUpCell"];
    
    tencentBuglyKey     = [config getString:@"tencent_bugly_appkey"];
    currentVersion      = [config getInteger:@"InternalVersion"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    currentVersionDisplay = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    

}

+(DLJSONObject* _Nullable)getServerAddressList
{
    return ServerAddressList;
}

+(DLJSONObject* _Nullable)getShareSDKKeys
{
    return ThirdShareSDKKeys;
}

+ (DLJSONArray* _Nullable)getMyProfileCellList
{
    return myProfileCellList;
}

+ (DLJSONArray* _Nullable)getSetUpCellList
{
    return setUpCellList;
}

+(NSString *)getTencentBuglyAppkey
{
    return tencentBuglyKey;
}

+(int)getCurrentVersion
{
    return currentVersion;
}

+(NSString *_Nullable)getCurrentVersionDisplay
{
    return currentVersionDisplay;
}

+(NSString *_Nullable)getCurrentClientName{
    
    return currentClientName;
}

@end
