//
//  DLLocationManager.h
//  Dreamer-ios-client
//
//  Created by GongXin on 17/1/9.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLLocationManager : NSObject

+(instancetype)shareManager;

//开始定位
-(void)startLocation;

//为开启定位或者定位错误
-(void)locationManagerError;

//获取定位信息
-(NSDictionary*)getLocationInfo;

//获取纬度
-(NSString*)getLatitude;

//获取经度
-(NSString*)getLongitude;

@end
