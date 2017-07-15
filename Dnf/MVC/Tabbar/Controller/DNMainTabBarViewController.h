//
//  DNMainTabBarViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNTabBarItem.h"
#import "DNBaseViewController.h"
#import "DNHomePageViewController.h"
#import "DNPhotoViewController.h"
#import "DNVideoViewController.h"
#import "DNVRViewController.h"
#import "DNPartyViewController.h"
@interface DNMainTabBarViewController : UITabBarController<UITabBarControllerDelegate>
{
    //标签元素
    DNTabBarItem *tempSelectItem;
}


/**
 *  Controller 的个数
 */
@property (nonatomic,assign)NSInteger viewControllerCount;

/**
 *  标签栏视图
 */
@property(nonatomic,strong)UIView * tabBariew;
/**
 *  标签栏那个线条
 */
@property(nonatomic,strong)UIView * lineView;




/**
 *  初始化方法
 */
+(DNMainTabBarViewController*)shareTabBarController;

/**
 *  TabBar选中
 */
-(void)setTabBarSelectedIndex:(NSUInteger)selectedIndex;
/**
 *  隐藏TabBar方法
 */
-(void)hiddenTabBar:(BOOL)hidden;



@end
