//
//  DLThirdShareSDKInitiingizer.h
//  Dreamer-ios-client
//
//  Created by Ant on 2017/6/3.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DLThirdShareSDKInitiingizer : NSObject

/**
 设置appkey列表
 */
+ (void)setShareSDKKeys:(DLJSONObject *)SDKKeys;

+ (void)registerApp;


@end
