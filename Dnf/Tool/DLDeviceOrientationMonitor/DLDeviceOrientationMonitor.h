//
//  DLDeviceOrientationMonitor.h
//  Dreamer-ios-client
//
//  Created by Ant on 17/4/26.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLDeviceOrientationMonitorDelegate<NSObject>

- (void)deviceOrientationDidchange:(UIInterfaceOrientation)orientation;

@end

@interface DLDeviceOrientationMonitor : NSObject

@property (nonatomic, weak) id<DLDeviceOrientationMonitorDelegate>delegate;


- (void)startMonitor;

- (void)stopMonitor;
@end
