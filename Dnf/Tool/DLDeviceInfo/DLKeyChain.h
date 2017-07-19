//
//  DLKeyChain.h
//  DreamerFoundation
//
//  Created by Ant on 16/12/20.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLKeyChain : NSObject

/**
 *  添加数据到系统KeyChain
 *
 *  @param value 数值
 *
 *  @param key 键
 *
 *  @return 成功返回 YES，否则返回 NO
 */
+(BOOL)addValue:(NSString*)value withKey:(NSString*)key;

/**
 *  更新系统KeyChain数据
 *
 *  @param value 数值
 *
 *  @param key 键
 *
 *  @return 成功返回 YES，否则返回 NO
 */
+(BOOL)updateValue:(NSString*)value withKey:(NSString*)key;

/**
 *  删除系统KeyChain数据
 *
 *  @param key 键
 *
 *  @return 成功返回 YES，否则返回 NO
 */
+(BOOL)delValueInKeyChain:(NSString*)key;

/**
 *  查询系统KeyChain数据
 *
 *  @param key 键
 *
 *  @return 键对应的数值
 */
+(NSString*)getValueWithKey:(NSString*)key;


@end
