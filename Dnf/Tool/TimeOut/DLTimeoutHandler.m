//
//  DLTimeoutHandler.m
//
//  Copyright © 2015年 Beijing MaiXiu Interaction Technology Co., Ltd. All rights reserved.
//

#import "DLTimeoutHandler.h"
#import "NSString+DLExtend.h"

@interface TimeoutTimerInfo : NSObject
@property(strong,nonatomic) DLTimeoutHandlerBlock handler;
@property(copy,nonatomic) NSString *tag;
@property(weak,nonatomic) NSMutableDictionary<NSString*,NSTimer*> *timers;
@end
@implementation TimeoutTimerInfo
@end

@implementation DLTimeoutHandler
{
    NSMutableDictionary<NSString*,NSTimer*> *timers;
}

-(instancetype)init
{
    self = [super init];
    timers = [[NSMutableDictionary<NSString*,NSTimer*> alloc] init];
    return self;
}

-(void)dealloc
{
    [self removeAllHandler];
}

-(BOOL)addHandler:(NSString* _Nonnull)tag
             time:(NSTimeInterval)time
            block:(DLTimeoutHandlerBlock _Nonnull)handler
{
    if (time <= 0.0){
        return NO;
    }
    
    if ([NSString isEmpty:tag]){
        return NO;
    }
    
    if (!handler){
        return NO;
    }
    
    TimeoutTimerInfo *info = [[TimeoutTimerInfo alloc]init];
    info.handler = handler;
    info.tag = tag;
    info.timers = timers;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:time
                                             target:DLTimeoutHandler.class
                                           selector:@selector(executeTimeoutHandler:)
                                           userInfo:info
                                            repeats:NO];
    @synchronized(timers) {
        NSTimer *temTimer = [timers objectForKey:tag];
        if (temTimer) {
            [temTimer invalidate];
        }
        
        [timers setObject:timer forKey:[tag copy]];
    }
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    return YES;
}

-(void)removeHandler:(NSString* _Nonnull)tag
{
    
    if ([NSString isEmpty:tag]){
        return;
    }
    
    NSTimer *timer;
    
    @synchronized(timers) {
        timer = [timers objectForKey:tag];
        if (timer){
            [timers removeObjectForKey:tag];
        }
    }
    
    if (timer){
        [timer invalidate];
    }
}

-(void)removeAllHandler
{
    @synchronized(timers) {
        NSEnumerator<NSTimer*> *enumerator = [timers objectEnumerator];
     
        for (NSTimer* timer in enumerator){
            [timer invalidate];
        }
        
        [timers removeAllObjects];
    }
}

+(void)executeTimeoutHandler:(NSTimer*)timer
{
    TimeoutTimerInfo *info = timer.userInfo;
    if (!info) {
        return;
    }
    
    [info.timers removeObjectForKey:info.tag];
    
    info.handler();
}
@end
