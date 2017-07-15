//
//  Define.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#ifndef Define_h
#define Define_h

#pragma mark -
#pragma mark 打印日志
#define GTDEBUG 1
#if GTDEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
#define ISNIL(variable) (variable==nil)
//是不是NULL类型
#define IS_NULL_CLASS(variable)    ((!ISNIL(variable))&&([variable  isKindOfClass:[NSNull class]])
//字典数据是否有效
#define IS_DICTIONARY_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSDictionary class]])&&([((NSDictionary *)variable) count]>0))
//数组数据是否有效
#define IS_ARRAY_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSArray class]]))
//数字类型是否有效
#define IS_NUMBER_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSNumber class]]))
//字符串是否有效
#define IS_EXIST_STR(str) ((nil != (str)) &&([(str) isKindOfClass:[NSString class]]) && (((NSString *)(str)).length > 0))

//color
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define kThemeColor  HexRGBAlpha(0xFF6BB7, 1)

#define DNRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

//屏幕宽高
#define KScreenHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define KScreenWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度

#define TextFontName_Light  @"PingFangSC-Light"
#define TextFontName_Bold   @"PingFangSC-Semibold"
#define TextFontName        @"PingFangSC-Regular"
#define TextFontName_Italic @"Verdana-Italic"
#define TextFontName_Medium @"PingFangSC-Medium"

#endif /* Define_h */
