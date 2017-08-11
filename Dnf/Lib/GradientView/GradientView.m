//
//  GradientView.m
//  Dreamer
//
//  Created by 井泉 on 16/8/17.
//  Copyright © 2016年 飞. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()
{    
    GradientOrientationType gradientOrientation;
    NSArray *colors;
    UIColor *startColor;
    UIColor *endColor;
    NSArray<NSNumber *> *locations;
    CGPoint startPoint;
    CGPoint endPoint;
}
@end

@implementation GradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        /*
         *默认渐变色: 上部白色，下部黑色,透明度都为1
         *默认渐变方向: 垂直
         */
        gradientOrientation = GradientOrientationTypeVertical;
        
        startColor = [UIColor whiteColor];
        endColor = [UIColor blackColor];
        locations = @[@0, @1];
        startPoint = CGPointMake(0, 0);
        endPoint = CGPointMake(0, 1);
        
        _gradiedtLayer = [[CAGradientLayer alloc] init];
        _gradiedtLayer.frame = frame;
        [self.layer addSublayer:_gradiedtLayer];
        [self GenerateGradient];
    }
    return self;
}


- (void)setGradientOrientation:(GradientOrientationType)oritation
{
    switch (oritation) {
        case GradientOrientationTypeVertical:{
            startPoint = CGPointZero;
            endPoint = CGPointMake(0, 1);
            _gradiedtLayer.startPoint = startPoint;
            _gradiedtLayer.endPoint = endPoint;
        }
            break;
            
        case GradientOrientationTypeHorizontal:{
            startPoint = CGPointZero;
            endPoint = CGPointMake(1, 0);
            _gradiedtLayer.startPoint = startPoint;
            _gradiedtLayer.endPoint = endPoint;
        }
            break;
            
        default:
            break;
    };
}

- (void)GenerateGradient
{
    [self setColor];
    _gradiedtLayer.locations = locations;
    _gradiedtLayer.startPoint = startPoint;
    _gradiedtLayer.endPoint = endPoint;
}

- (void)setColors:(NSArray *)colorsArray
{
    _gradiedtLayer.colors = colorsArray;
}

- (void)setColor{
    _gradiedtLayer.colors = [NSArray arrayWithObjects:(id)startColor.CGColor,
                            (id)endColor.CGColor,
                            nil];
}

- (void)setLocations:(float)start end:(float)end
{
    _gradiedtLayer.locations = @[[NSNumber numberWithFloat:start], [NSNumber numberWithFloat:end]];
}

- (void)setStartColor:(UIColor*)color alpha:(CGFloat)alpha
{
    startColor = [color colorWithAlphaComponent:alpha];
    _gradiedtLayer.colors = [NSArray arrayWithObjects:(id)startColor.CGColor,
                            (id)endColor.CGColor,
                            nil];
}

- (void)setEndColor:(UIColor*)color alpha:(CGFloat)alpha
{
    endColor = [color colorWithAlphaComponent:alpha];
    _gradiedtLayer.colors = [NSArray arrayWithObjects:(id)startColor.CGColor,
                            (id)endColor.CGColor,
                            nil];
}

- (void)setStartLocation:(CGPoint)point
{
    _gradiedtLayer.startPoint = point;
}

- (void)setEndLocation:(CGPoint)point
{
    _gradiedtLayer.endPoint = point;
}



@end
