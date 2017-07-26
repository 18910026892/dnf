//
//  DNBaseViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLNoDataView.h"
#import "DLNoNetView.h"
#import <AFNetworking.h>
@class DNMainTabBarViewController;
@interface DNBaseViewController : UIViewController<NoDataViewDelegate,NoNetWorkViewDelegate>

{
    /**无数据视图**/
    DLNoDataView*         _noDataView;
    /**无网视图**/
    DLNoNetView*      _noNetWorkView;
}

/**
 *  自定义NavigationBar
 */
@property(nonatomic,strong)UIImageView * customNavigationBar;
/**
 *  Navigation标题
 */
@property(nonatomic,strong)UIView      * lineView;

/**
 * 标题Label
 */
@property(nonatomic,strong)UILabel     * titleLabel;

/**
 * 导航栏左边的按钮
 */
@property(nonatomic,strong)UIButton    * leftButton;

/**
 * 导航栏右边的按钮
 */
@property(nonatomic,strong)UIButton    * rightButton;

/**
 * 页面背景图片
 */
@property(nonatomic,strong)UIImageView * backGroundImageView;

/**
 *  标签切换控制器
 */
@property(nonatomic,strong)DNMainTabBarViewController* tabBar;

/**
 *  是否Present 进
 */
@property(nonatomic,assign)BOOL isPresent;

/**
 *  是否返回根视图控制器
 */
@property(nonatomic,assign)BOOL isPopToRoot;
/**
 * @brief 设置标题
 */
-(void)setNavTitle:(NSString *)title;

/**
 * @brief 是否显示返回按钮
 */
-(void)showBackButton:(BOOL)show;
/**
 *@brief 使用alloc创建的控制器
 */
+ (instancetype)viewController;
/**
 * @brief 设置导航栏是否隐藏 默认显示
 */
- (void)setNavigationBarHide:(BOOL)isHide;

/**
 * @brief 设置Tabbar 是否隐藏 默认显示
 
 */
-(void)setTabBarHide:(BOOL)isHide;


/**
 * @brief 设置背景图片
 */
-(void)setBackImageViewWithName:(NSString *)imgName;

/**
 *  @brief 初始化View
 */
-(void)creatUserInterface;
/**
 *  @brief 操作Data
 */
-(void)operationData;

#pragma mark - 无数据的显示方法
/*
 *  @param superView 无数据
 */
-(void)showNoDataView:(UIView*)superView
         noDataString:(NSString *)noDataString
          noDataImage:(NSString*)imageName
       imageViewFrame:(CGRect)rect;

- (void)hideNoDataView;

@property NSInteger nodataViewTpye;

#pragma mark - 无网络的显示方法

-(void)hideNoNetWorkView;
-(void)retryToGetData;
-(void)showNoNetWorkViewWithimageName:(NSString*)imageName;
//网络小菊花停止转动，可以再次发起网络请求
-(void)stopAiv;

@end
