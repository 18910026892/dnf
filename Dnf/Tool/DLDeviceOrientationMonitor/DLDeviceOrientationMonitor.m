//
//  DLDeviceOrientationMonitor.m
//  Dreamer-ios-client
//
//  Created by Ant on 17/4/26.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#define UPDATEINTERVAL 1.0

#import "DLDeviceOrientationMonitor.h"

@interface DLDeviceOrientationMonitor ()<UIAccelerometerDelegate>

@property (nonatomic) UIInterfaceOrientation deviceOrientation;

@end

@implementation DLDeviceOrientationMonitor

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    
     return self;
}

-(void)startMonitor
{
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = UPDATEINTERVAL;
}

- (void)stopMonitor
{
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = nil;
    accelerometer.updateInterval = UPDATEINTERVAL;
}

#pragma deleage

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    // Get the current device angle
    float xx = -[acceleration x];
    float yy = [acceleration y];
    float angle = atan2(yy, xx);
    // Read my blog for more details on the angles. It should be obvious that you
    // could fire a custom shouldAutorotateToInterfaceOrientation-event here.
    if(angle >= -2.25 && angle <= -0.25)
    {
        if(_deviceOrientation != UIInterfaceOrientationPortrait)
        {
            _deviceOrientation = UIInterfaceOrientationPortrait;
            [self updateOrientation:_deviceOrientation];
        }
    }
    else if(angle >= -1.75 && angle <= 0.75)
    {
        if(_deviceOrientation != UIInterfaceOrientationLandscapeRight)
        {
            _deviceOrientation = UIInterfaceOrientationLandscapeRight;
            [self updateOrientation:_deviceOrientation];
        }
    }
    else if(angle >= 0.75 && angle <= 2.25)
    {
        if(_deviceOrientation != UIInterfaceOrientationPortraitUpsideDown)
        {
            _deviceOrientation = UIInterfaceOrientationPortraitUpsideDown;
            [self updateOrientation:_deviceOrientation];
        }
    }
    else if(angle <= -2.25 || angle >= 2.25)
    {
        if(_deviceOrientation != UIInterfaceOrientationLandscapeLeft)
        {
            _deviceOrientation = UIInterfaceOrientationLandscapeLeft;
            
            [self updateOrientation:_deviceOrientation];
        }
    }

}

- (void)updateOrientation:(UIInterfaceOrientation)Orientation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deviceOrientationDidchange:)]) {
        
        [self.delegate deviceOrientationDidchange:Orientation];
    }
}


@end
