//
//  DLDeviceInfo.h
//  DreamerFoundation
//
//  Created by Ant on 16/12/20.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLDeviceInfo : NSObject

/**
 *  获取机器时间
 *
 *  @return 自开机以后经过的纳秒数（10负9次方秒）
 */
+(uint64_t)getMachAbsoluteTime;
/**
 *  获取GUID
 *
 *  @return GUID字符串
 */
+ (NSString *)GUID;

/**
 *  获取UDID
 *
 *  @return UDID字符串
 */
+ (NSString*)UDID;

/**
 *  获取设备类型
 *
 *  @return 设备类型名称
 */
+ (NSString *)getDeviceType;


/**
 获取设备类型

 @return 设备类型字符串
 */
+ (NSString *)getPhoneType;

/**
 获取系统版本号
 @return 手机系统版本号
 */
+ (NSString *)getPhoneOSVersion;

/**
 获取当前流量统计

 @return 当前流量
 */
+ (long long)getCurrentNetBytes;


/**
 获取bundleID

 @return bundleID
 */
+ (NSString *)getBundlID;

@end
