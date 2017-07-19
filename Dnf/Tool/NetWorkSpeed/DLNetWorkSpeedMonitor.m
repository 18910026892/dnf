//
//  DLNetWorkSpeedMonitor.m
//  Dreamer-ios-client
//
//  Created by Ant on 17/1/4.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import "DLNetWorkSpeedMonitor.h"
#import "DLTimeoutHandler.h"
#import <math.h>

static int64_t startTime;  // 开始时间
static int64_t startBytes; // 开始的bytes
static int64_t netSpeed;   // 网络速度

static DLTimeoutHandler *timeoutHandler;

@implementation DLNetWorkSpeedMonitor

/**
 开启网速监测
 */
+ (void)startNetMonitor
{
    startTime  = [DLDeviceInfo getMachAbsoluteTime];
    startBytes = [DLDeviceInfo getCurrentNetBytes];
    
    timeoutHandler =  [[DLTimeoutHandler alloc] init];
                     
    [timeoutHandler addHandler:@"netspeed" time:300 block:^{
        
        startTime  = [DLDeviceInfo getMachAbsoluteTime];
        startBytes = [DLDeviceInfo getCurrentNetBytes];
        
    }];
    
    
}
/**
 获取当前网速，五分钟内的平均网速
 */
+ (int64_t)getCurrentNetSpeed
{
    int64_t nowTime     = [DLDeviceInfo getMachAbsoluteTime];
    int64_t nowNetBytes = [DLDeviceInfo getCurrentNetBytes];
    
    if (nowTime <= startTime) return 0;
    if (nowNetBytes <= startBytes) return 0;
    
    int64_t timeTravel = nowTime - startTime;
    
    int64_t bytesTravel = nowNetBytes - startBytes;

    // 把时间转换成秒
    
    int64_t s = timeTravel / pow(10, 9);
    
    // 计算网速 bytes/s
    netSpeed = bytesTravel/s;
    
    return netSpeed;
}

@end
