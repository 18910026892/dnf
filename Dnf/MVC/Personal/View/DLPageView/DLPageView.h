//
//  DLPageView.h
//  Dreamer-ios-client
//
//  Created by Ant on 17/2/21.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLPageViewDelegate <NSObject>

/**
 *  滑动时的回调函数
 *
 *  @param index 子视图的索引
 */
- (void)pageViewDidMoveToIndex:(NSInteger)index;

/**
 *  滑动时的回调函数
 *
 *  @param percentage 滑动层的偏移量
 */
- (void)pageViewDidScroll:(CGFloat)percentage;

@end

@interface DLPageView : UIView


/**
 *  添加是否可以滑动属性
 */
@property (nonatomic, assign) BOOL isNeedScroll;

/**
 *  视图的代理
 */
@property(nonatomic, strong) id<DLPageViewDelegate> delegate;

/**
 *  视图初始化函数
 *
 *  @param frame 视图的frame
 *
 *  @return 返回一个视图实例
 */
-(id)initWithFrame:(CGRect)frame;

/**
 *  向视图中添加子视图
 *
 *  @param viewArray 子视图的集合
 */
-(void)addSubviews:(NSArray *)viewArray;

/**
 *  切换子试图
 *
 *  @param index 子视图的索引
 */
-(void)moveToPageWithIndex:(NSInteger)index;


@end
