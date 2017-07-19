//
//  DLServerError.h
//  Dreamer-ios-client
//
//  Created by Ant on 17/1/7.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLServerError : NSError


/**
 初始化方法

 @param domain       错误域
 @param code         code
 @param errorMessage 错误消息

 @return error
 */
- (instancetype)initWithDomain:(NSErrorDomain)domain
                          code:(NSInteger)code
                  errorMessage:(NSString *)errorMessage;
@end
