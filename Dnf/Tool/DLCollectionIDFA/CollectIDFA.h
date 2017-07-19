//
//  CollectIDFA.h
//  Dreamer
//
//  Created by Ant on 16/10/31.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectIDFA : NSObject

/**
 收集广告标示符
 */
+ (void)collectIdfa;

+ (NSString *)getADid;

+(NSString *)getIDFV;
@end
