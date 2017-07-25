//
//  DLShareContentManager.m
//  Dreamer
//
//  Created by Ant on 16/9/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "DLShareContentManager.h"
//#import "UrlConstantKey.h"

@implementation DLShareContentManager

/**
 *  单例
 *
 *  @return 单例
 */

+ (instancetype)shareInstance
{
    static DLShareContentManager *shareInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareInstance = [[self alloc]init];
    });
    
    return shareInstance;
}
- (void)getShareParamWithType:(NSString*)type
                       author:(NSString*)authorid
                     relateid:(NSString*)relateid
                       target:(NSString*)target
                        title:(NSString*)title
                      Success:(void (^)(NSDictionary *))successBlaock
                        faile:(void (^)())faileBlock
{
    

    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory shareLiveWithType:type
                                                                      author:authorid
                                                                    relateid:relateid
                                                                      target:target title:title];
    request.requestSuccess = ^(id response){ // 成功回调
        
        DLJSONObject * object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        if (successBlaock) {
            successBlaock(dataObject.dictionary);
        }
     
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];

    
}

@end
