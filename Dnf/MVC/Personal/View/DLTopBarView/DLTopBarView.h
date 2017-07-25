//
//  DLTopBarView.h
//  Dreamer-ios-client
//
//  Created by Ant on 17/2/21.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLTopBarViewDelegate <NSObject>

/**
 *  视图的item被选中时的回调函数
 *
 *  @param index 视图item的索引
 */
-(void)topTabBarDidSelectedWithIndex:(NSInteger)index;

@end


@class DLTopBarConfig;

@interface DLTopBarView : UIView

/**
 *  视图的当前索引
 */
@property(nonatomic, assign) NSInteger selectIndex;

/**
 *  视图的代理
 */
@property(nonatomic, weak) id<DLTopBarViewDelegate> delegate;


/**
 *  视图初始化函数
 *
 *  @param frame 视图的frame
 *
 *  @return 返回一个视图实例
 */
-(id)initWithFrame:(CGRect)frame config:(DLTopBarConfig *)config;

/**
 *  向视图中TabBaritem
 *
 *  @param titles TabBaritem的标题集合
 */
-(void)addTabBarItemWithTitles:(NSArray *)titles;

/**
 *  移动下划线
 *
 *  @param percentage 移动的百分比
 */
-(void)moveUnderlineWithPercent:(CGFloat)percentage;

@end
