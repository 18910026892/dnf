//
//  GradientView.h
//  Dreamer
//
//  Created by 井泉 on 16/8/17.
//  Copyright © 2016年 飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientOrientationType) {
    GradientOrientationTypeVertical,//垂直
    GradientOrientationTypeHorizontal,//水平
};

@interface GradientView : UIView

@property(nonatomic, strong) CAGradientLayer *gradiedtLayer;;

- (void)setStartColor:(UIColor*)color alpha:(CGFloat)alpha;
- (void)setEndColor:(UIColor*)color alpha:(CGFloat)alpha;

- (void)setStartLocation:(CGPoint)point;//值范围0-1
- (void)setEndLocation:(CGPoint)point;//值范围0-1

- (void)setGradientOrientation:(GradientOrientationType)oritation;
- (void)setLocations:(float)start end:(float)end;//一般值范围0-1
@end
