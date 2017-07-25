//
//  AppDelegate.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];

    
    // 加载本地配置
    [DLApplicationConfig load];
    
    // 获取服务器地址
    [DLHttpsBusinesRequest setServerAddress:[DLApplicationConfig getServerAddressList]]; // 设置服务器地址列表，所有的服务器地址都在配置文件中
    
    // 注册shareSDK
    [DLThirdShareManager setShareSDKKeys:[DLApplicationConfig getShareSDKKeys]];
    [[DLThirdShareManager shareInstance] registerApp];

    //开启定位
    [[DLLocationManager shareManager] startLocation];
    

    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:80];
    
    //主界面
    DNMainTabBarViewController * tabbarVc = [DNMainTabBarViewController shareTabBarController];
    //配置NavigationBar
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:tabbarVc];
    
    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:rootNav];
    
    DNPersonalViewController * personalViewController = [DNPersonalViewController viewController];
    //设置左侧菜单
    slideMenu.leftViewController = personalViewController;
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = slideMenu;
    [_window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
