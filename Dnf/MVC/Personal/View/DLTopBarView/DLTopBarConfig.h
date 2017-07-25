//
//  DLTopBarConfig.h
//  Dreamer-ios-client
//
//  Created by Ant on 2017/6/2.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DLTopBarUderlineType)
{
    DLTopBarUderlineType_equBtnWidth = 0,
    DLTopBarUderlineType_equTitleWidth
};

@interface DLTopBarConfig : NSObject

@property (nonatomic, strong) UIColor *underLineColor;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectColor;

@property (nonatomic, assign) CGFloat uderLineHeight;

@property (nonatomic, assign) DLTopBarUderlineType lineType;

@end
