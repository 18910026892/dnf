//
//  AppDelegate.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "DLThirdShareManager.h"
#import "DNMainTabBarViewController.h"
#import "DNPersonalViewController.h"
#import "XLSlideMenu.h"
#import "RNCachingURLProtocol.h"
#import "DLApplicationConfig.h"
#import "DLLocationManager.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic)XLSlideMenu *slideMenu;

@end

