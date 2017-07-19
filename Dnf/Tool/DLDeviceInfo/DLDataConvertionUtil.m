//
//  DLDataConvertionUtil.m
//  DreamerFoundation
//
//  Created by Ant on 16/12/20.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import "DLDataConvertionUtil.h"
#define MS_ASCII_TABLE_SIZE  256
#define MS_HEX_TABLE_SIZE  16
#define MS_STACK_BUFFER_SIZE 1024;

unsigned char  MSHexToBinaryTable[MS_ASCII_TABLE_SIZE]={0};
char  MSHexStrTable[] = "0123456789ABCDEF0123456789abcdef";

@implementation DLDataConvertionUtil

+(void)initDataConvertionUtil
{
    //初始化十六进制字符串解码表
    memset(MSHexToBinaryTable,0,MS_ASCII_TABLE_SIZE);
    
    for (int i=0;i<32;i++)
        MSHexToBinaryTable[MSHexStrTable[i]] = (i & 0x0F);
}

+(NSData*) hexStringToNSData:(NSString*)hexString
{
    if (!hexString){
        return [NSData data];
    }
    
    //栈缓冲区
    Byte stackBuffer[512];
    Byte *buffer;
    uint bufferLength = (uint)hexString.length / 2 + hexString.length % 2 ;
    
    if (bufferLength > sizeof(stackBuffer)) {
        //当字符串长度大于栈缓冲区时，使用堆内存
        buffer = (Byte*)malloc(bufferLength);
    }
    else{
        buffer = stackBuffer;
    }
    
    NSUInteger length = hexString.length;
    
    for (NSUInteger i = 0; i<length; i++) {
        unichar c = [hexString characterAtIndex:i];
        if (i & 0x1){
            //低四位（后处理）
            buffer[i >> 1] |= MSHexToBinaryTable[(Byte)c] & 0x0F;
        }
        else{
            //高四位（先处理）
            buffer[i >> 1] = MSHexToBinaryTable[(Byte)c] << 4;
        }
    }
    
    NSData *result = [NSData dataWithBytes:buffer length:bufferLength];
    
    if (buffer != stackBuffer) {
        //当字符串长度大于栈缓冲区时使用的是堆内存，在这里释放
        free(buffer);
    }
    
    return result;
}

+(NSString*) nsdataToHexString:(NSData*)nsdata;
{
    if (!nsdata || nsdata.length == 0) {
        return @"";
    }
    
    //栈缓冲区
    Byte stackBuffer[256];
    char stackChars[sizeof(stackBuffer) * 2 + 1];
    
    Byte *buffer;
    char *hexChars;
    
    uint bufferLength = (uint)nsdata.length;
    
    if (bufferLength > sizeof(stackBuffer)) {
        //当data长度大于栈缓冲区时，使用堆内存
        buffer = (Byte*)malloc(bufferLength);
        hexChars = (char*)malloc(bufferLength * 2 + 1);
    }
    else{
        buffer = stackBuffer;
        hexChars = stackChars;
    }
    
    [nsdata getBytes:buffer length:bufferLength];
    
    for (uint i=0; i<bufferLength; i++) {
        hexChars[i * 2] = MSHexStrTable[(buffer[i] & 0xF0) >> 4];
        hexChars[i * 2 + 1] = MSHexStrTable[(buffer[i] & 0x0F)];
    }
    
    hexChars[bufferLength * 2] = 0;
    
    NSString *string = [NSString stringWithCString:hexChars encoding:NSASCIIStringEncoding];
    
    if (buffer != stackBuffer) {
        //当data长度大于栈缓冲区时使用的是堆内存，在这里释放堆内存
        free(buffer);
        free(hexChars);
    }
    
    return string;
}

+(BOOL) valueToBool:(id _Nonnull)value result:(BOOL* _Nullable)result
{
    if ([value isKindOfClass:[NSString class]]){
        if ([@"true" compare:value options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [@"yes" compare:value options:NSCaseInsensitiveSearch] == NSOrderedSame){
            *result = YES;
        }
        else if ([@"false" compare:value options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                 [@"no" compare:value options:NSCaseInsensitiveSearch] == NSOrderedSame){
            *result = NO;
        }
        
    }
    else if([value isKindOfClass:[NSNumber class]]){
        NSNumber *valueNum = (NSNumber *)value;
        *result = [valueNum boolValue];
    }
    else{
        return NO;
    }
    
    return YES;
}

+(BOOL) valueToInt:(id _Nonnull)value result:(int* _Nullable)result
{
    int original = *result;
    if ([value isKindOfClass:[NSString class]]){
        NSScanner *scanner = [[NSScanner alloc]initWithString:value];
        if (![scanner scanInt:result]){
            *result = original;
        }
    }
    else if([value isKindOfClass:[NSNumber class]]){
        NSNumber *valueNum = (NSNumber *)value;
        *result = [valueNum intValue];
    }
    else{
        return NO;
    }
    
    return YES;
}

+(BOOL) valueToLongLong:(id _Nonnull)value result:(long long* _Nullable)result
{
    long long original = *result;
    if ([value isKindOfClass:[NSString class]]){
        NSScanner *scanner = [[NSScanner alloc]initWithString:value];
        if (![scanner scanLongLong:result]){
            *result = original;
        }
    }
    else if([value isKindOfClass:[NSNumber class]]){
        NSNumber *valueNum = (NSNumber *)value;
        *result = [valueNum longLongValue];
    }
    else{
        return NO;
    }
    
    return YES;
}

+(BOOL) valueToULongLong:(id _Nonnull)value result:(unsigned long long* _Nullable)result
{
    unsigned long long original = *result;
    if ([value isKindOfClass:[NSString class]]){
        NSScanner *scanner = [[NSScanner alloc]initWithString:value];
        if (![scanner scanUnsignedLongLong:result]){
            *result = original;
        }
    }
    else if([value isKindOfClass:[NSNumber class]]){
        NSNumber *valueNum = (NSNumber *)value;
        *result = [valueNum unsignedLongLongValue];
    }
    else{
        return NO;
    }
    
    return YES;
}

+(BOOL) valueToFloat:(id _Nonnull)value result:(float* _Nullable)result
{
    float original = *result;
    if ([value isKindOfClass:[NSString class]]){
        NSScanner *scanner = [[NSScanner alloc]initWithString:value];
        if (![scanner scanFloat:result]){
            *result = original;
        }
    }
    else if([value isKindOfClass:[NSNumber class]]){
        NSNumber *valueNum = (NSNumber *)value;
        *result = [valueNum floatValue];
    }
    else{
        return NO;
    }
    
    return YES;
}

+(BOOL) valueToDouble:(id _Nonnull)value result:(double* _Nullable)result
{
    double original = *result;
    if ([value isKindOfClass:[NSString class]]){
        NSScanner *scanner = [[NSScanner alloc]initWithString:value];
        if (![scanner scanDouble:result]){
            *result = original;
        }
    }
    else if([value isKindOfClass:[NSNumber class]]){
        NSNumber *valueNum = (NSNumber *)value;
        *result = [valueNum doubleValue];
    }
    else{
        return NO;
    }
    
    return YES;
}


@end
