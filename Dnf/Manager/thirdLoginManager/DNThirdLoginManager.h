//
//  DNThirdLoginManager.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/28.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "XLSlideMenu.h"
@interface DNThirdLoginManager : NSObject
@property(nonatomic, weak)UIViewController *viewController;

@property(strong,nonatomic)XLSlideMenu *slideMenu;

+(instancetype)shareInstance;

//登录平台
-(void)threeLoginWithPlatform:(SSDKPlatformType)platformType;
@end
