//
//  DLServerError.m
//  Dreamer-ios-client
//
//  Created by Ant on 17/1/7.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import "DLServerError.h"

@implementation DLServerError

- (instancetype)initWithDomain:(NSErrorDomain)domain
                          code:(NSInteger)code
                  errorMessage:(NSString *)errorMessage
{
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    if (errorMessage)
    {
       [userInfo setValue:errorMessage forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    return [self initWithDomain:domain code:code userInfo:userInfo];
    
}
@end
