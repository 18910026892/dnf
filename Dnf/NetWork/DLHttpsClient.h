//
//  DLHttpsClient.h
//  DreamerFoundation
//
//  Created by Ant on 16/12/25.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 *  下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 */
typedef void (^DLDownloadProgress)(int64_t bytesRead,
int64_t totalBytesRead);

typedef DLDownloadProgress DLGetProgress;   // 下载进度
typedef DLDownloadProgress DLPostProgress;  // 下载进度

/*!
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^DLUploadProgress)(int64_t bytesWritten,
int64_t totalBytesWritten);

/**
 *  定义Http返回数据格式
 */
typedef NS_ENUM(NSUInteger, DLResponseType) {
    DLResponseTypeJSON = 1, // 默认
    DLResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    DLResponseTypeData = 3
};

/**
 *  定义Http请求数据格式
 */
typedef NS_ENUM(NSUInteger, DLRequestType) {
    DLRequestTypeJSON = 1, // 默认
    DLRequestTypePlainText  = 2 // 普通text/html
};



/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, DLNetworkStatus)
{
    /*! 未知网络 */
    DLNetworkStatusUnknown           = 0,
    /*! 没有网络 */
    DLNetworkStatusNotReachable,
    /*! 手机 3G/4G 网络 */
    DLNetworkStatusReachableViaWWAN,
    /*! wifi 网络 */
    DLNetworkStatusReachableViaWiFi
};


// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型
typedef NSURLSessionTask DLURLSessionTask;
typedef void(^DLResponseSuccess)(id response);
typedef void(^DLResponseFail)(NSError *error);


/*! 实时监测网络状态的 block */
typedef void(^DLNetworkStatusBlock)(DLNetworkStatus status);

/*! 定义请求成功的 block */
typedef void( ^ DLResponseSuccess)(id response);
/*! 定义请求失败的 block */
typedef void( ^ DLResponseFail)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ DLUploadProgress)(int64_t bytesProgress,
int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ DLDownloadProgress)(int64_t bytesProgress,
int64_t totalBytesProgress);


@class NSURLSessionTask;


@interface DLHttpsClient : NSObject


+ (void)updateBaseUrl:(NSString *)baseUrl;
+ (NSString *)baseUrl;

/**
 *	设置请求超时时间，默认为30秒
 *
 *	@param timeout 超时时间
 */
+ (void)setTimeout:(NSTimeInterval)timeout;

/**
 *	当检查到网络异常时，是否从从本地提取数据。默认为NO。一旦设置为YES,当设置刷新缓存时，
 *  若网络异常也会从缓存中读取数据。同样，如果设置超时不回调，同样也会在网络异常时回调，除非
 *  本地没有数据！
 *
 *	@param shouldObtain	YES/NO
 */
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain;

/**
 *
 *	默认只缓存GET请求的数据，对于POST请求是不缓存的。如果要缓存POST获取的数据，需要手动调用设置
 *  对JSON类型数据有效，对于PLIST、XML不确定！
 *
 *	@param isCacheGet			默认为YES
 *	@param shouldCachePost	默认为NO
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost;

/**
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *	默认不会自动清除缓存，如果需要，可以设置自动清除缓存，并且需要指定上限。当指定上限>0M时，
 *  若缓存达到了上限值，则每次启动应用则尝试自动去清理缓存。
 *
 *	@param mSize				缓存上限大小，单位为M（兆），默认为0，表示不清理
 */
+ (void)autoToClearCacheWithLimitedToSize:(NSUInteger)mSize;



/**
 *
 *	清除缓存
 */
+ (void)clearCaches;

/*!
 *
 *  开启或关闭接口打印信息
 *
 *  @param isDebug 开发期，最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;


/**
 配置请求格式

 @param requestType                   请求格式，默认为JSON
 @param responseType                  响应格式，默认为JSON
 @param shouldAutoEncode              自动encode url 默认是NO
 @param shouldCallbackOnCancelRequest 取消请求时是否需要回调， 默认为 YES
 */
+ (void)configRequestType:(DLRequestType)requestType
             responseType:(DLResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;


/*!
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;


/**
 *	取消所有请求
 */
+ (void)cancelAllRequest;
/**
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的HYBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;


#pragma mark -- get请求

/**
 GET请求接口， 若不指定BaseUrl 可传入完整的url
 
 @param url          url
 @param refreshCache 是否署刷新缓存 由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 @param success      参数字典
 @param fail         失败回调
 
 @return 返回任务实例
 */
+ (DLURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          success:(DLResponseSuccess)success
                             fail:(DLResponseFail)fail;
// 多一个params参数
+ (DLURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(DLResponseSuccess)success
                             fail:(DLResponseFail)fail;
// 多一个带进度回调
+ (DLURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(DLGetProgress)progress
                          success:(DLResponseSuccess)success
                             fail:(DLResponseFail)fail;

#pragma mark -- post请求

/**
 POST 请求接口
 
 @param url          url
 @param refreshCache 是否要刷新缓存
 @param params       参数字典
 @param success      成功回调
 @param fail         失败回调
 
 @return 请求实例
 */
+ (DLURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                           success:(DLResponseSuccess)success
                              fail:(DLResponseFail)fail;
+ (DLURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                          progress:(DLPostProgress)progress
                           success:(DLResponseSuccess)success
                              fail:(DLResponseFail)fail;

#pragma mark -- 上传文件
/**
 *
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	@param image			图片对象
 *	@param url				上传图片的接口路径，如/path/images/
 *	@param filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	@param name				与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	@param mimeType		默认为image/jpeg
 *	@param parameters	参数
 *	@param progress		上传进度
 *	@param success		上传成功回调
 *	@param fail				上传失败回调
 *
 *	@return  DLURLSessionTask
 */
+ (DLURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(DLUploadProgress)progress
                               success:(DLResponseSuccess)success
                                  fail:(DLResponseFail)fail;

/**
 *
 *	上传文件操作
 *
 *	@param url						上传路径
 *	@param uploadingFile	待上传文件的路径
 *	@param progress			上传进度
 *	@param success				上传成功回调
 *	@param fail					上传失败回调
 *
 *	@return DLURLSessionTask
 */

+ (DLURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                             parameters:(NSDictionary *)parameters
                                progress:(DLUploadProgress)progress
                                 success:(DLResponseSuccess)success
                                    fail:(DLResponseFail)fail;

/*
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (DLURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(DLDownloadProgress)progressBlock
                               success:(DLResponseSuccess)success
                               failure:(DLResponseFail)failure;

@end
