//
//  DLNoNetView.h
//  DreamLive
//
//  Created by GongXin on 16/11/30.
//  Copyright © 2016年 com.dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NoNetWorkViewStyle_No_NetWork=0,
    NoNetWorkViewStyle_Load_Fail
}NoNetWorkViewStyle;
@protocol NoNetWorkViewDelegate ;
@interface DLNoNetView : UIView

@property (weak,nonatomic) id<NoNetWorkViewDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t reloadDataBlock;
/**
 * 出现方法
 */
-(void)showInView:(UIView*)superView style:(NoNetWorkViewStyle)style imageName:(NSString*)imageName;
/**
 * 隐藏方法
 */
-(void)hide;

//连网小菊花停止转动
-(void)stopAiv;

@end

@protocol NoNetWorkViewDelegate <NSObject>
/**
 * 重新加载
 */
-(void)retryToGetData;

@end

