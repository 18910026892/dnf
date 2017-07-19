//
//  DLJSONArray.h
//  DreamerFoundation
//
//  Created by Ant on 16/12/20.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLJSONObject.h"
@class DLJSONObject;

@interface DLJSONArray : NSObject<NSFastEnumeration>

@property (strong,nonatomic,readonly) NSMutableArray* array;

/**
 *  使用Array 对象实例化 MSJSONArray。
 *
 *  @param array JSONArray 字符串
 *
 *  @return return MSJSONArray 对象
 */
-(instancetype) initWithMutableArray:(NSMutableArray*)array;

/**
 *  使用Array 对象实例化 MSJSONArray。
 *
 *  @param array JSONArray 字符串
 *
 *  @return return MSJSONArray 对象
 */
-(instancetype) initWithArray:(NSArray*)array;

/**
 *  解析JSON字符串，并实例化 MSJSONArray。
 *
 *  @param string JSONArray 字符串
 *
 *  @return return MSJSONArray 对象，如果字符串不是一个 JSONArray 则实例化失败，返回nil。
 */
-(instancetype) initWithString:(NSString*)string;


/**
 *  获取布尔值
 *
 *  @param index 索引
 *
 *  @return 如果值不存在或类型不正确返回 false，如果存在返回值内容。
 */
-(BOOL)getBoolean:(NSUInteger) index;
/**
 *  获取布尔值
 *
 *  @param index 索引
 *
 *  @return 如果值不存在或类型不正确返回 defaultValue，如果存在返回值内容。
 */
-(BOOL)optBoolean:(NSUInteger) index defaultValue:(BOOL) defaultValue;

-(int)getInteger:(NSUInteger) index;
-(int)optInteger:(NSUInteger) index defaultValue:(int) defaultValue;

- (long long)getLongLong:(NSUInteger) index;
- (long long)optLong:(NSUInteger) index defaultValue:(long long)defaultValue;

- (unsigned long long)getULongLong:(NSUInteger) index;
- (unsigned long long)optULongLong:(NSUInteger) index defaultValue:(unsigned long long)defaultValue;

-(double)getDouble:(NSUInteger) index;
-(double)optDouble:(NSUInteger) index defaultValue:(double) defaultValue;

-(NSString*)getString:(NSUInteger) index;
-(NSString*)optString:(NSUInteger) index defaultValue:(NSString*) defaultValue;

-(DLJSONArray*) getJSONArray: (NSUInteger) index;
-(DLJSONObject*)getJSONObject:(NSUInteger) index;
-(NSObject*)getObject:(NSUInteger) index;

-(void) putWithBoolean: (Boolean)  value;
-(void) putWithInt:     (int)value;
-(void) putWithLongLong:(long long)value;
-(void) putWithULongLong:(unsigned long long)value;
-(void) putWithDouble:  (double)   value;
-(void) putWithString:  (NSString*)value;
-(void) putWithJSONArray:(DLJSONArray*) value;
-(void) putWithJSONObject:(DLJSONObject*) value;
-(void) putWithObject:(NSObject*)value;

-(BOOL)hasIndex:(NSUInteger) index;
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
-(NSUInteger)count;
-(NSString *)description;


@end
