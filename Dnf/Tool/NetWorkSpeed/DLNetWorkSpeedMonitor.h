//
//  DLNetWorkSpeedMonitor.h
//  Dreamer-ios-client
//
//  Created by Ant on 17/1/4.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLNetWorkSpeedMonitor : NSObject

/**
 开启网速监测
 */
+ (void)startNetMonitor;
/**
 获取当前网速，最长是 五分钟内的平均网速
 */
+ (int64_t)getCurrentNetSpeed;
@end
