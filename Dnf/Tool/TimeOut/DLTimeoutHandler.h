//
//  DLTimeoutHandler.h
//
//  Created by Allen on 15/12/23.
//  Copyright © 2015年 Beijing MaiXiu Interaction Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DLTimeoutHandlerBlock)(void);

@interface DLTimeoutHandler : NSObject

/**
 *  添加一个超时处理器，当超时发生时执行 block，超时回调将在主线程中执行。
 *
 *  @param tag   处理器标识，不能为 nil 或 空串，否则添加失败，返回 nil。
 *  @param time  超时时间，必须大于 0 ，则否添加失败。
 *  @param handler 要执行的block，不能为 nil 否则添加失败。
 *
 *  @return 添加成功返加 YES，否则返回 NO。
 */
-(BOOL)addHandler:(NSString* _Nonnull)tag
             time:(NSTimeInterval)time
            block:(DLTimeoutHandlerBlock _Nonnull)handler;

/**
 *  移除一个超时处理器，如果一个处理已经触发则不会对其有任何影响。
 *
 *  @param tag 处理器标识
 */
-(void)removeHandler:(NSString* _Nonnull)tag;

/**
 *  移除所有超时处理器，如果一个处理已经触发则不会对其有任何影响。
 */
-(void)removeAllHandler;
@end
