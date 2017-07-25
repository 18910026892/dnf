//
//  DLHttpsBusinesRequest.m
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/25.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "DLHttpsBusinesRequest.h"
#import "DLNetWorkSpeedMonitor.h"
#import "DLApplicationConfig.h"
#import "DLHttpServerError.h"
#import "DLServerError.h"
#import "DLProgressView.h"
#import "NSString+MD5.h"
#import "MSNetworkStatusObserver.h"
static DLJSONObject *ServerAddressList; //地址列表
static NSString     *DLMainServerAddress = @"";

@interface DLHttpsBusinesRequest ()

//@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, copy) NSString *url;                // 请求地址

@property (nonatomic, assign) DLHttpRequestMethod method; // 请求方法类型 //缺省为GET 请求


@end

@implementation DLHttpsBusinesRequest
{
    UIImage    *mImage;      // 图片对象
    NSString   *mImageName;  // 图片命名
    NSString   *mName;       //
    NSString   *mMimeType;   // 图片格式
    
    NSString   *mUploadingFile; // 待上传文件的路径
    NSString   *mSaveTopath;    // 下载文件要保存的文件路径
    
    DLProgressView *mProgressView; // loading
    
}

+ (void)load // 配置http 只配置一次
{
    static dispatch_once_t configHttp;
    dispatch_once(&configHttp, ^{
        
        // https://cdn.kernel.org/pub/linux/kernel/v4.x/testing/linux-4.10-rc1.tar.xz
        // 通常放在appdelegate就可以了
//        [DLHttpsClient updateBaseUrl:@"https://apistore.baidu.com"];
        
        //
        [DLHttpsClient enableInterfaceDebug:YES];
        
        // 设置GET、POST请求都缓存
        [DLHttpsClient cacheGetRequest:YES shoulCachePost:NO];
    
        [DLHttpsClient setTimeout:30];
        
        // 添加请求头
    });
}

+(void)setServerAddress:(DLJSONObject*)address
{
    DLMainServerAddress = [address optString:@"msvr://" defaultValue:@""];
    
    ServerAddressList   = address;
    // 如果结尾有 /
    if (![DLMainServerAddress isEmpty] && [DLMainServerAddress hasSuffix:@"/"]){
        DLMainServerAddress = [DLMainServerAddress substringToIndex:DLMainServerAddress.length - 1];
    }
}

- (instancetype)initWithUrl:(NSString *)url method:(DLHttpRequestMethod)method
{
    
    
    return [self initWithUrl:url parameter:nil method:method];
    
}

- (instancetype)initWithUrl:(NSString *)url
                  parameter:(NSDictionary *)prameter
                     method:(DLHttpRequestMethod)method
{
    self = [super init];
    
    if (self) {
        
        self.url    = url;
        self.method = method;
        
        _isShowLoading = NO;
        _isShowErrorToast = YES;
        _isProcessCommonError = YES;
        _parameter = [[NSMutableDictionary  alloc] init];
        
        if (prameter) [_parameter addEntriesFromDictionary:prameter];
        
        
        mImage       = nil;      // 图片对象
        mImageName   = nil;// 图片命名
        mName        = nil;       //
        mMimeType    = nil; // 图片格式
        
        mUploadingFile = nil; // 待上传文件的路径
        mSaveTopath    = nil;    // 下载文件要保存的文件路径
        
        _isNeedAddcommonParameter = YES;
        _requestType              = DLRequestTypePlainText;
        _responseType             = DLResponseTypeJSON;
        
        [self configconfigRequestResposeType];
        
    }
    
    return self;

}

- (void)configconfigRequestResposeType
{
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [DLHttpsClient configRequestType:_requestType
                        responseType:_responseType
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];

}

- (void)setRequestType:(DLRequestType)requestType
{
    self.requestType = requestType;
    [self configconfigRequestResposeType];
}

- (void)setResponseType:(DLResponseType)responseType
{
    _responseType = responseType;
    
    [self configconfigRequestResposeType];
}



- (void)addParameter:(id)value key:(NSString *)key
{
    [self.parameter setValue:value forKey:key];

}

- (void)addUploadImage:(UIImage *)image
              filename:(NSString *)imageName
                  name:(NSString *)name
              mimeType:(NSString *)mimeType
{
    mImage = image;
    mImageName = imageName;
    mName      = name;
    mMimeType  = mimeType;
}


/**
 添加hader
 */
- (void)creatHeader
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    
    NSString *tocken = [NSString stringWithFormat:@"token=%@",[DNSession sharedSession].token];
    
    [mDic setValue:tocken forKey:@"Cookie"];
    
    
    [DLHttpsClient configCommonHttpHeaders:mDic];
}

/**
 添加上传文件的请求参数  如果请求方法是 DLHttpRequestMethodUplodeFile 要调用这个方法
 
 @param uploadingFile 待上传文件的路径
 */
- (void)addUplodeFileFile:(NSString *)uploadingFile
{
    mUploadingFile = uploadingFile;
}
/**
 添加下载的请求参数    如果请求方法是 DLHttpRequestMethodDownlodeFile 要调用这个方法
 
 @param saveTopath 保存路径
 */
- (void)addDownloadeFillePath:(NSString *)saveTopath
{
    mSaveTopath = saveTopath;
}

/**
 *  添加公用参数信息 签名
 */
- (void)addCommonParameter
{
    int64_t speed = [DLNetWorkSpeedMonitor getCurrentNetSpeed];
    NSString *netSpeedStr = [NSString stringWithFormat:@"%lld",speed];
//
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    NSMutableDictionary *CommonParameter = [[NSMutableDictionary alloc]init];

    if (IsStrEmpty([DNSession sharedSession].uid)) { // 如果第一次登陆，或者没有本地信息

        [DNSession sharedSession].uid = @"0";
    }
   
    [CommonParameter setValue:[DNSession sharedSession].uid forKey:@"userid"];
    [CommonParameter setValue:[NSString stringToMD5:[DLDeviceInfo UDID]] forKey:@"deviceid"];
    [CommonParameter setValue:@"ios" forKey:@"platform"];
    [CommonParameter setValue:[MSNetworkStatusObserver currentNetWorkStatusString] forKey:@"network"];
    [CommonParameter setValue:[DLApplicationConfig getCurrentVersionDisplay] forKey:@"version"];
    [CommonParameter setValue:[self generateFradomCharacter] forKey:@"rand"];
    [CommonParameter setValue:netSpeedStr forKey:@"netspeed"];
    [CommonParameter setValue:timeSp forKey:@"time"];
    /*
     
     生产鉴权的公共参数
     */

    NSString *signStr = [self creatSignStr:CommonParameter];
    
    [CommonParameter setValue:signStr forKey:@"guid"];
    
    [self.parameter addEntriesFromDictionary:CommonParameter];
    
    
    /*
     不需要鉴权的公共参数
     */
    [self.parameter setValue:[DNSession sharedSession].regon forKey:@"region"];
    
    //"model","brand"
    
    [self.parameter setValue:[DLDeviceInfo getPhoneType] forKey:@"model"];
    [self.parameter setValue:[DLDeviceInfo getPhoneOSVersion] forKey:@"brand"];
    
    //经纬度
    NSString *longitudeString = [DNSession sharedSession].longitude;
    if (longitudeString == nil || longitudeString.length == 0) {
        longitudeString = @"0";
    }
    
    NSString *latitudeString = [DNSession sharedSession].latitude;
    if (latitudeString == nil || latitudeString.length == 0) {
        latitudeString = @"0";
    }
    
    [self.parameter setValue:longitudeString forKey:@"lng"];
    [self.parameter setValue:latitudeString forKey:@"lat"];
    
    // channel
     NSString *channel =@"0";
    [self.parameter setValue:channel forKey:@"channel"];
    

}

- (NSString *)creatSignStr:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    
    //按字母顺序排序
    
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                            
    {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString *returnStr = @"";
    
    //拼接字符串
    
    for (int i=0;i<sortedArray.count;i++){
        
        NSString *category = sortedArray[i];
        
        if (0 == i) {
            
            returnStr = [NSString stringWithFormat:@"%@=%@",category,dic[category]];
        }
        else{
                
            returnStr = [NSString stringWithFormat:@"%@%@=%@",returnStr,category,dic[category]];
        }
        
     }
    /*拼接上key得到stringSignTemp*/
    
    returnStr = [NSString stringWithFormat:@"%@z20b323cdff1910523f24a31217e8116",returnStr];

    
    /*md5加密*/
    returnStr = [NSString stringToMD5:returnStr];

    
    return returnStr;
}

// 生成16位随机数
- (NSString *)generateFradomCharacter{
    static int kNumber = 16;
    
    NSString *sourceStr = @"abcdefghijklmnopqrstuvwxyz0123456789";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < kNumber; i++){
        
        unsigned index = arc4random() % [sourceStr length];
        
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
        
    }
    
    return resultStr;
}

- (void)excute
{

    [self onBeforeExecute];
    
    switch (self.method) { // get
        default:
        case DLHttpRequestMethodGet:   //默认是GET请求
            if (self.parameter && self.parameter.count > 0) {
                
                [DLHttpsClient getWithUrl:self.url
                             refreshCache:self.isNeedRefreshCatch
                                   params:self.parameter
                                 progress:^(int64_t bytesRead, int64_t totalBytesRead) {
                    
                                
                    
                    if (_getProgress)
                    {
                        self.getProgress (bytesRead, totalBytesRead);
                    }
                    
                } success:^(id response) {
                   
         
                    
                   [self dealResponse:response];
                    
                } fail:^(NSError *error) {
   
                    [self onRequestFailed:error];
                    
                }];
            }else
            {
                [DLHttpsClient getWithUrl:self.url
                             refreshCache:self.isNeedRefreshCatch
                                  success:^(id response) {
                    
                    if (_requestSuccess) {
                        
                      [self dealResponse:response];
                    }
                    
                } fail:^(NSError *error) {
                   
                    if (_requestFaile) {
                        
                       [self onRequestFailed:error];
                    }
                }];
            }

            break;
        case DLHttpRequestMethodPost:  // post
           
        {
            [DLHttpsClient postWithUrl:self.url
                          refreshCache:self.isNeedRefreshCatch
                                params:self.parameter progress:^(int64_t bytesRead,
                                                                 int64_t totalBytesRead)
            {
                
                if (self.getProgress) {
                
                    self.getProgress (bytesRead, totalBytesRead);
                }
                
            } success:^(id response) {
                
                if (_requestSuccess) {
                    
                   [self dealResponse:response];
                }
                
            } fail:^(NSError *error) {
                
                if (_requestFaile) {
                    
                    [self onRequestFailed:error];
                }
                
            }];
        }
            
            break;
            
        case DLHttpRequestMethodUplodeImage: // 上传文件
        {
            if (!mImage) {
                
                NSLog(@"图片不能为空");
                
                return;
            }
            
            [DLHttpsClient uploadWithImage:mImage
                                       url:self.url
                                  filename:mImageName
                                      name:mName
                                  mimeType:mMimeType
                                parameters:self.parameter
                                  progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
                if (_uplodeProgress) self.uplodeProgress(bytesProgress,totalBytesProgress);
                
                
            } success:^(id response) {
                
                if (_requestSuccess) {
                    
                   [self dealResponse:response];
                }

                
            } fail:^(NSError *error) {
                
                if (_requestFaile) {
                    
                    [self onRequestFailed:error];
                }
            }];
            
        }
            
            break;
        case DLHttpRequestMethodUplodeFile: // 上传文件
        {
            [DLHttpsClient uploadFileWithUrl:self.url
                               uploadingFile:mUploadingFile parameters:self.parameter progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
                if (_uplodeProgress) self.uplodeProgress(bytesProgress,totalBytesProgress);
                
            } success:^(id response) {
                
                if (_requestSuccess) {
                    
                    [self dealResponse:response];
                }
                
            } fail:^(NSError *error) {
                
                if (_requestFaile) {
                    
                    [self onRequestFailed:error];
                }
                
            }];
        }
            
            break;
            
        case DLhttpRequestmethodUploadeFile_wansuAdapt:  // Ant +++ Adapt wangsu
        {
            [DLHttpsClient uploadFileWithUrl:self.url
                               uploadingFile:mUploadingFile parameters:self.parameter progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                                   
                                   if (_uplodeProgress) self.uplodeProgress(bytesProgress,totalBytesProgress);
                                   
                               } success:^(id response) {
                                   
                                   if (_requestSuccess) {
                                       
                                       [self dealWangsuResponse:response];
                                   }
                                   
                               } fail:^(NSError *error) {
                                   
                                   if (_requestFaile) {
                                       
                                       [self onRequestFailed:error];
                                   }
                                   
                               }];


        }
            
            break;
            
        case DLHttpRequestMethodDownlodeFile:
        {
            [DLHttpsClient downloadWithUrl:self.url
                                saveToPath:mSaveTopath
                                  progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                
              if (_uplodeProgress) self.uplodeProgress(bytesProgress,totalBytesProgress);
                
            } success:^(id response) {
                
                [self dealResponse:response];
                
                
            } failure:^(NSError *error) {
                
                [self onRequestFailed:error];
                
            }];
        }
            
            
            break;

    }
}

/**
 利用当前时间和服务器时间 比出来一个差值
 */
- (void)saveTimeDifference:(NSInteger)remoteTime {
    if (remoteTime < 1000000000) return;
    
    //本地时间
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger time = [date timeIntervalSince1970];
    
    NSInteger timeDifference = remoteTime - time;
    
    if ([DNSession sharedSession].timeDifference == 0 ||
        labs([DNSession sharedSession].timeDifference) > labs(timeDifference)
        ) {
        [DNSession sharedSession].timeDifference = timeDifference;
        
        
    }
}

// Ant +++ 适配网速服务器

- (void)dealWangsuResponse:(id)response
{
    DLJSONObject *json = [[DLJSONObject alloc]initWithDictionary:response];
    
    if (self.requestSuccess)
        self.requestSuccess(json);
    
    [self onFinish];
}
- (void)dealResponse:(id)response
{
    if (self.responseType == DLResponseTypeJSON) {
        
        DLJSONObject *json = [[DLJSONObject alloc]initWithDictionary:response];
        
        NSInteger code    = [(DLJSONObject *)json getInteger:@"errno"];

        /** 存储差值 */
        [self saveTimeDifference:[(DLJSONObject *)json getInteger:@"time"]];
        
        if (0 != code) { // 业务失败
            NSString *message = [json optString:@"errmsg"
                                   defaultValue:@"业务失败code不等于0"];
            
            NSError *error = [[DLServerError alloc]initWithDomain:DLSEVERErrorDomain
                                                             code:code
                                                     errorMessage:message];
            
            [self onRequestFailed:error];
            
        }else // 业务成功
        {
            if (self.requestSuccess)
            self.requestSuccess(json);
            
            [self onFinish];
        }
    
    }else // 不是json格式
    {
        if (self.requestSuccess)
        self.requestSuccess(response);
        
        [self onFinish];
    }
}

// 请求失败
-(void)onRequestFailed:(NSError *)error
{
    NSError *newError = error;
    
    //判断错误类型
    if ([[error domain] isEqualToString:NSURLErrorDomain]){
        switch ([error code]){
            case NSURLErrorTimedOut:{
                //网络响应超时
                newError =[[DLServerError alloc]initWithDomain:NSURLErrorDomain
                                                          code:[error code]
                                                  errorMessage:@"网络超时"];
                
                

                
            }
                break;
                
            case NSURLErrorCannotConnectToHost:
                //不能连接到主机
                newError =[[DLServerError alloc]initWithDomain:NSURLErrorDomain
                                                          code:[error code]
                                                  errorMessage:@"不能连接主机"];
                
                break;
                
            case NSURLErrorNotConnectedToInternet:
                //当在发出请求后，断开网络会报此错误
                
                newError =[[DLServerError alloc]initWithDomain:NSURLErrorDomain
                                                          code:[error code]
                                                  errorMessage:@"网络断开"];
                
                break;
                
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateNotYetValid:
                //证书过期
                newError =[[DLServerError alloc]initWithDomain:NSURLErrorDomain
                                                          code:[error code]
                                                  errorMessage:@"证书过期"];
                break;
                
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateHasUnknownRoot:
                //证书无效
                
                newError =[[DLServerError alloc]initWithDomain:NSURLErrorDomain
                                                          code:[error code]
                                                  errorMessage:@"证书错误"];

                break;
                
            default:
            {
                //其它网络错误，如 500，404 等。
                NSInteger code = [error code];
                if (code >= 300 && code <= 510){
                    newError =[[DLServerError alloc]initWithDomain:NSURLErrorDomain
                                                              code:[error code]
                                                      errorMessage:@"网络错误"];

                }
                else{
                    NSString *errDescription = [error localizedDescription];
                    if ([error userInfo]){
                        errDescription = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
                    }
                
                    newError =[[DLServerError alloc]initWithDomain:NSURLErrorDomain
                                                              code:[error code]
                                                      errorMessage:[NSString stringWithFormat:@"%@",errDescription]];
                    
                }
                break;
            }
        }
    }

    
    if (self.requestFaile) self.requestFaile(newError);
    
    [self onFinish];
    if (_isShowErrorToast) {
        
    
        NSString *str = [NSString stringWithFormat:@"%@",[newError.userInfo objectForKey:NSLocalizedFailureReasonErrorKey]];
        
  

        if (!str) return;


          [[UIApplication sharedApplication].keyWindow makeToast:str
    duration:2.0
    position:CSToastPositionCenter];
        
    }
    
}


/**
 请求之前操作
 */
- (void)onBeforeExecute
{
    
    [self creatHeader];
    
    if (_isNeedAddcommonParameter) {
        
        [self addCommonParameter]; // 添加公共请求参数
    }
    

    
    if ([self.url rangeOfString:@"://"].location != NSNotFound) {
        // URL 是一个绝对路径
        self.url = [DLHttpsBusinesRequest replaceHostByScheme:self.url];
    }
    else{
        // url 是一个相对路径 添加缺省主机头
        if ([self.url hasPrefix:@"/"]) {
            self.url = [DLMainServerAddress stringByAppendingString:self.url];
        }
        else{
            self.url = [DLMainServerAddress stringByAppendingFormat:@"/%@",self.url];
        }
    }

      NSLog(@"URL = %@",_url); NSLog(@" parameter =  %@",_parameter);
    
    if (_isShowLoading) {
        
         mProgressView = [[DLProgressView alloc] init];
        mProgressView.mode = MBProgressHUDModeIndeterminate;
        mProgressView.minSize = CGSizeMake(90, 90);
        
        if (_loadingMessage) {
            
            mProgressView.labelText = _loadingMessage;
        }else
        {
            mProgressView.labelText = @"加载中...";
        }
        
        [mProgressView show];

    }
}

- (void)onFinish
{
    if (mProgressView) {
        [mProgressView close];
    }
}

/**
 *  替换 URL 中的主机头。
 *  将 URL 中的 msvr:// 等 scheme 替换成实际的主机头，如果 URL中没有上述的主机头则原样返回 URL。
 *
 *  @param url 等替换的 URL
 *
 *  @return 替换后的　URL。
 */
+ (NSString*)replaceHostByScheme:(NSString*)url // 例： msver://abc 替换成 http://weiying/abc
{
    if (!url) return url;
    
    if (!ServerAddressList) {
        return url;
    }
    
    NSRange range = [url rangeOfString:@"://"];
    if (range.location == NSNotFound){
        return url;
    }
    
    range.length += range.location; //自定义主机头的length
    range.location = 0;
    
    NSString* scheme  = [url substringWithRange:range];
    NSString* address = [ServerAddressList optString:scheme defaultValue:nil];// 取出对应的实际主机头
    
    if (IsStrEmpty(address)) {
        return url;
    }
    
    if (![address hasSuffix:@"/"]){ // 如果实际主机头没有 / 则加 / 保证路径完整
        address = [address stringByAppendingString:@"/"];
    }
    
 
     url = [url stringByReplacingCharactersInRange:range withString:address];

    
    return url;
}

/**
 取消请求
 */
- (void)cancel
{
    [DLHttpsClient cancelRequestWithURL:self.url];
}

/**
 取消所有请求
 */
- (void)cancelAllRequest
{
    [DLHttpsClient cancelAllRequest];
}

@end
