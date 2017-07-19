//
//  DLDataConvertionUtil.h
//  DreamerFoundation
//
//  Created by Ant on 16/12/20.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLDataConvertionUtil : NSObject

+(void)initDataConvertionUtil;

/**
 *  将十六进制字符串转换成NSData，如果转换失败返回一个空的 NSData。
 *
 *  @param hexString 十六进制字符串，长度必须是偶数，如果是奇数则后面补一个0。
 *
 *  @return NSData 实例
 */
+(NSData* _Nonnull) hexStringToNSData:(NSString* _Nonnull)hexString;

/**
 *  将NSData 转换成十六进制字符串，如果转换失败则返回一个空串。
 *
 *  @param nsdata NSData
 *
 *  @return 十六进制字符串
 */
+(NSString* _Nonnull) nsdataToHexString:(NSData* _Nonnull)nsdata;

/**
 *  将 id 类型数据转换成布尔值，如果以可转换则输出转换后的值。
 *  如果原值是 NSNumber 或是字符串“true”、“false”、"yes"、“no”，则可以转换成功。
 *  @param value   原值
 *  @param result  用于保存转换后值变量的地址，如查不能转换则不改变地址内容。
 *                 如果该参数传空则不返回转换结果值，只给出是否转换成功。
 *
 *  @return 是否转换成功
 */
+(BOOL) valueToBool:(id _Nonnull)value result:(BOOL* _Nullable)result;

/**
 *  将 id 类型数据转换成 int 值，如果以可转换则输出转换后的值。
 *  如果原值是 NSNumber 或是数字字符串，则可以转换成功。
 *  @param value   原值
 *  @param result  用于保存转换后值变量的地址，如查不能转换则不改变地址内容。
 *                 如果该参数传空则不返回转换结果值，只给出是否转换成功。
 *
 *  @return 是否转换成功
 */
+(BOOL) valueToInt:(id _Nonnull)value result:(int* _Nullable)result;

/**
 *  将 id 类型数据转换成 long long 值，如果以可转换则输出转换后的值。
 *  如果原值是 NSNumber 或是数字字符串，则可以转换成功。
 *  @param value   原值
 *  @param result  用于保存转换后值变量的地址，如查不能转换则不改变地址内容。
 *                 如果该参数传空则不返回转换结果值，只给出是否转换成功。
 *
 *  @return 是否转换成功
 */
+(BOOL) valueToLongLong:(id _Nonnull)value result:(long long* _Nullable)result;

/**
 *  将 id 类型数据转换成 unsigned long long 值，如果以可转换则输出转换后的值。
 *  如果原值是 NSNumber 或是数字字符串，则可以转换成功。
 *  @param value   原值
 *  @param result  用于保存转换后值变量的地址，如查不能转换则不改变地址内容。
 *                 如果该参数传空则不返回转换结果值，只给出是否转换成功。
 *
 *  @return 是否转换成功
 */
+(BOOL) valueToULongLong:(id _Nonnull)value result:(unsigned long long* _Nullable)result;

/**
 *  将 id 类型数据转换成 float 值，如果以可转换则输出转换后的值。
 *  如果原值是 NSNumber 或是数字字符串，则可以转换成功。
 *  @param value   原值
 *  @param result  用于保存转换后值变量的地址，如查不能转换则不改变地址内容。
 *                 如果该参数传空则不返回转换结果值，只给出是否转换成功。
 *
 *  @return 是否转换成功
 */
+(BOOL) valueToFloat:(id _Nonnull)value result:(float* _Nullable)result;

/**
 *  将 id 类型数据转换成 double 值，如果以可转换则输出转换后的值。
 *  如果原值是 NSNumber 或是数字字符串，则可以转换成功。
 *  @param value   原值
 *  @param result  用于保存转换后值变量的地址，如查不能转换则不改变地址内容。
 *                 如果该参数传空则不返回转换结果值，只给出是否转换成功。
 *
 *  @return 是否转换成功
 */
+(BOOL) valueToDouble:(id _Nonnull)value result:(double* _Nullable)result;


@end
