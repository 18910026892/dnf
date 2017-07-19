//
//  DLJSONArray.m
//  DreamerFoundation
//
//  Created by Ant on 16/12/20.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import "DLJSONArray.h"
#import "NSString+DLExtend.h"
#import "DLDataConvertionUtil.h"

@implementation DLJSONArray

-(void) dealloc
{
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

-(instancetype) init
{
    return [self initWithMutableArray:nil];
}

-(instancetype) initWithString:(NSString*)string
{
    NSError *error;
    id json;
    
    if (![NSString isEmpty:string]) {
        json = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableContainers
                                                 error:&error];
    }
    else{
        json = [NSJSONSerialization JSONObjectWithData:[@"[]" dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableContainers
                                                 error:&error];
    }
    
    if ([json isKindOfClass:[NSMutableArray class]])
        return [self initWithMutableArray:json];
    else
        return nil;
}

-(instancetype) initWithMutableArray:(NSMutableArray*)array
{
    self = [super init];
    
    if (self){
        if (array)
            _array = array;
        else
            _array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(instancetype) initWithArray:(NSArray*)array
{
    self = [super init];
    
    if (self){
        if (array)
            _array = [[NSMutableArray alloc] initWithArray:array];
        else
            _array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - 判断是否有这个index
-(BOOL)hasIndex:(NSUInteger) index
{
    if (index < self.count)
    {
        return YES;
    }
    return NO;
}
#pragma mark - 获得bool值
-(BOOL)getBoolean:(NSUInteger) index
{
    return [self optBoolean:index defaultValue:NO];
}

#pragma mark - 获得bool值，失败返回缺省
-(BOOL)optBoolean:(NSUInteger) index defaultValue:(BOOL) defaultValue
{
    BOOL result = defaultValue;
    
    if ([self hasIndex:index])
    {
        id value = [_array objectAtIndex:index];
        [DLDataConvertionUtil valueToBool:value result:&result];
    }
    
    return result;
}

#pragma mark - 获得整型值
-(int)getInteger:(NSUInteger) index
{
    return [self optInteger:index defaultValue:0];
}

#pragma mark - 获得整型值，失败返回缺省
-(int)optInteger:(NSUInteger) index defaultValue:(int) defaultValue
{
    int result = defaultValue;
    
    if ([self hasIndex:index])
    {
        id value = [_array objectAtIndex:index];
        [DLDataConvertionUtil valueToInt:value result:&result];
    }
    
    return result;
}

#pragma mark - 获取 LongLong 型值
- (long long)getLongLong:(NSUInteger) index
{
    return [self optLong:index defaultValue:0];
}

#pragma mark - 获取 LongLong 型带默认值
- (long long)optLong:(NSUInteger) index defaultValue:(long long)defaultValue
{
    long long result = defaultValue;
    
    if ([self hasIndex:index]) {
        id value = [_array objectAtIndex:index];
        [DLDataConvertionUtil valueToLongLong:value result:&result];
    }
    
    return result;
}

#pragma mark - 获取无符号 LongLong 型值
- (unsigned long long)getULongLong:(NSUInteger) index
{
    return [self optULongLong:index defaultValue:0];
}

#pragma mark - 获取无符号 LongLong 型带默认值
- (unsigned long long)optULongLong:(NSUInteger) index defaultValue:(unsigned long long)defaultValue
{
    unsigned long long result = defaultValue;
    
    if ([self hasIndex:index]) {
        id value = [_array objectAtIndex:index];
        [DLDataConvertionUtil valueToULongLong:value result:&result];
    }
    
    return result;
}

#pragma mark - 获得浮点型值
-(double)getDouble:(NSUInteger) index
{
    return [self optDouble:index defaultValue:0.0f];
}

#pragma mark - 获得浮点型值，失败返回缺省
-(double)optDouble:(NSUInteger) index defaultValue:(double) defaultValue
{
    double result = defaultValue;
    
    if ([self hasIndex:index])
    {
        id value = [_array objectAtIndex:index];
        [DLDataConvertionUtil valueToDouble:value result:&result];
    }
    
    return result;
}

#pragma mark - 获得字符串值
-(NSString *)getString:(NSUInteger) index
{
    return [self optString:index defaultValue:nil];
}

#pragma mark - 获得字符串，失败返回缺省
-(NSString*)optString:(NSUInteger) index defaultValue:(NSString*) defaultValue
{
    
    if ([self hasIndex:index])
    {
        id obj = [_array objectAtIndex:index];
        if ([obj isKindOfClass:[NSString class]]){
            return obj;
        }
        else if ([obj isKindOfClass:[NSNumber class]]){
            return  [obj description];
        }
    }
    return defaultValue;
}

#pragma mark - 获得JSONArr，失败返回nil
-(DLJSONArray*) getJSONArray:(NSUInteger)index
{
    if ([self hasIndex:index])
    {
        id obj = [_array objectAtIndex:index];
        if([obj isKindOfClass:[NSMutableArray class]]){
            return [[DLJSONArray alloc]initWithMutableArray:obj];
        }
    }
    return nil;
}

#pragma mark - 获得JSONObj，失败返回nil
-(DLJSONObject*)getJSONObject:(NSUInteger)index
{
    if ([self hasIndex:index])
    {
        id obj = [_array objectAtIndex:index];
        if ([obj isKindOfClass:[NSMutableDictionary class]]){
            return [[DLJSONObject alloc]initWithMutableDictionary:obj];
        }else if([obj isKindOfClass:[NSDictionary class]])
        {
            return [[DLJSONObject alloc]initWithDictionary:obj];
        }
    }
    return nil;
}

-(NSObject*)getObject:(NSUInteger) index
{
    if ([self hasIndex:index])
    {
        return [_array objectAtIndex:index];
    }
    
    return nil;
}

#pragma mark - 往数组中添加bool值
-(void) putWithBoolean:(Boolean)value
{
    NSNumber * obj = [NSNumber numberWithBool:value];
    [_array addObject:obj];
}

#pragma mark - 往数组中添加int值
-(void) putWithInt:(int)value
{
    NSNumber * obj = [NSNumber numberWithInt:value];
    [_array addObject:obj];
}

#pragma mark - 往数组中添加 longlong 值
-(void) putWithLongLong:(long long)value
{
    NSNumber * obj = [NSNumber numberWithLongLong:value];
    [_array addObject:obj];
}

#pragma mark - 往数组中添加 unsigned longlong 值
-(void) putWithULongLong:(unsigned long long)value
{
    NSNumber * obj = [NSNumber numberWithUnsignedLongLong:value];
    [_array addObject:obj];
}

#pragma mark - 往数组中添加double值
-(void) putWithDouble: (double)value
{
    NSNumber * obj = [NSNumber numberWithDouble:value];
    [_array addObject:obj];
}

#pragma mark - 往数组中添加NSString
-(void) putWithString: (NSString*)value
{
    if (!value) value = @"";
    [_array addObject:value];
}

-(void) putWithJSONArray:(DLJSONArray*) value
{
    [_array addObject:value.array];
}

-(void) putWithJSONObject:(DLJSONObject*) value
{
    [_array addObject:value.dictionary];
}

-(void) putWithObject:(NSObject*)value
{
    [_array addObject:value];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [_array countByEnumeratingWithState:state objects:buffer count:len];
}

-(NSUInteger)count
{
    return [_array count];
}

-(NSString *)description
{
    NSError *error;
    NSData  *data  = [NSJSONSerialization dataWithJSONObject: _array
                                                     options: NSJSONWritingPrettyPrinted
                                                       error: &error];
    if (!error){
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return @"{}";
}


@end
