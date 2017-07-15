//
//  DNHttpRequest.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
@interface DNHttpRequest : NSObject

typedef void(^successGetData)(id response);
typedef void(^failureData)(id error);
typedef void(^failureGetData)(id error);

@property(nonatomic,strong) successGetData successBlock;
@property(nonatomic,strong) failureData failureDataBlock;
@property(nonatomic,strong) failureGetData failureBlock;

@property(nonatomic,copy)void(^FiledownloadedTo)(NSURL*);
@property(nonatomic,copy)void(^FileuploadedTo)(id);


//get请求
-(void)requestDataWithUrl:(NSString*)urlString;
//post请求
-(void)requestDataWithUrl:(NSString*)urlString pragma:(NSDictionary*)pragmaDict;
//post请求 带图片
-(void)requestDataWithUrl:(NSString*)urlString pragma:(NSDictionary*)pragmaDict ImageDatas:(id)data imageName:(id)imageName;
//下载
-(void)startDownloadTaskWithUrl:(NSString*)urlString;
//上传
-(void)startUploadTaskTaskWithUrl:(NSString*)urlString;

-(void)getResultWithSuccess:(successGetData)success DataFaiure:(failureData)datafailure Failure:(failureGetData)failure;



@end
