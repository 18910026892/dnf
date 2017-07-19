//
//  DLProgressView.h
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "MBProgressHUD.h"

typedef void(^DLProgressViewCancelCallBack)(void);

@interface DLProgressView : MBProgressHUD

/** 是否可以取消 */
@property(nonatomic,assign) BOOL cancelable;
/** 取消回调 */
@property(nonatomic,copy,nullable) DLProgressViewCancelCallBack cancelCallback;

/**
 *  创建一个不可取消的 ProgressView 并显示。
 *
 *  @param message 消息文本
 */
+(void)show:(NSString* _Nonnull)message;


/**
 *  创建一个可以取消的 ProgressView 并显示。
 *
 *  @param message  消息文本
 *  @param callback 取消回调
 */
+(void)show:(NSString* _Nonnull)message cancelback:(DLProgressViewCancelCallBack _Nullable)callback;

/**
 *  关闭 ProgressView
 *  如果当前没有显示 ProgressView 则该方法没有任何效果。
 *  如果使用 show 方法显示了多个 ProgressView，则该方法关闭最后显示的那个 ProgressView
 */
+(void)hide;

/**
 *  设置 ProgressView 上的文本
 *  如果当前没有显示 ProgressView 则该方法没有任何效果。
 *  如果使用 show 方法显示了多个 ProgressView，则该方法设置最后显示的那个 ProgressView
 *
 *  @param message 消息文本
 */
+(void)setMessage:(NSString* _Nonnull)message;

/**
 *  显示 ProgressView
 */
-(void)show;

/**
 *  关闭 ProgressView
 */
-(void)close;


@end
