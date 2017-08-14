//
//  DLNoDataView.h
//  DreamLive
//
//  Created by GongXin on 16/11/30.
//  Copyright © 2016年 com.dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoDataViewDelegate;

@interface DLNoDataView : UIView

@property (nonatomic,strong) id<NoDataViewDelegate> delegate;


-(void)showNoDataView:(UIView*)superView noDataString:(NSString *)noDataString noDataImage:(NSString*)imageName imageViewFrame:(CGRect)rect;


/**
 * 隐藏方法
 */
-(void)hide;

/**
 * 坐标
 */
-(void)setContentViewFrame:(CGRect)rect;

/**
 * 颜色
 */
-(void)setColor:(UIColor*)color;

@end

@protocol NoDataViewDelegate <NSObject>

-(void)didClickedNoDataButton;

@end
