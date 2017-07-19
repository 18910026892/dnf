//
//  DLHttpsBusinesRequest.h
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/25.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  定义Http请求的类型
 */

typedef NS_ENUM(NSInteger, DLHttpRequestMethod){
    
    DLHttpRequestMethodGet = 0,       // get
    DLHttpRequestMethodPost,          // post
    DLHttpRequestMethodUplodeImage,   // uplodeImage
    DLHttpRequestMethodUplodeFile,    // uplodeFile
    DLHttpRequestMethodDownlodeFile,   // downlodeFile
    DLhttpRequestmethodUploadeFile_wansuAdapt  // Ant +++ 适配网速上传文件
    
    
};
#import "DLHttpsClient.h"
@interface DLHttpsBusinesRequest : NSObject

/**是否显示错误提示，缺省显示*/
@property (nonatomic,assign) BOOL isShowErrorToast;
/**是否显示 Loading，缺省不显示 */
@property (nonatomic,assign) BOOL isShowLoading;
/**是否处理通用错误（例如：当登录无效时会显示一个对话框提示用户重新登录），默认 YES */
@property (nonatomic,assign) BOOL isProcessCommonError;
/**Loading 中的消息文本，缺省为 nil，显示缺省文本 */
@property (nonatomic,copy) NSString *loadingMessage;

/**是否需要添加 公共参数 缺省 为 YES  不指定则默认添加 */
@property (nonatomic, assign) BOOL isNeedAddcommonParameter;


/**
 请求数据类型 不设置默认为 DLRequestTypePlainText
 */
@property (nonatomic, assign) DLRequestType requestType;


/**
 返回数据类型 不设置默认为JSON
 */
@property (nonatomic, assign) DLResponseType responseType;

/** Http 表单数据（NSNumber、NSString）*/
@property (strong, nonatomic, readonly) NSMutableDictionary *parameter;

/** 是否需要刷新缓存 */
@property (nonatomic, assign) BOOL isNeedRefreshCatch;

/** 下载进度回调*/
@property (nonatomic, copy) DLDownloadProgress downloadProgress;
     
/** 上传进度回调*/
@property (nonatomic, copy) DLUploadProgress   uplodeProgress;

/** get进度回调*/
@property (nonatomic, copy) DLGetProgress      getProgress;

/** post进度回调*/
@property (nonatomic, copy) DLPostProgress     postProgress;

/** 请求成功回调*/
@property (nonatomic, copy) DLResponseSuccess  requestSuccess;

/** 请求失败回调*/
@property (nonatomic, copy) DLResponseFail     requestFaile;


/**
 * 设置服务地址
 * @param address config 文件中的 ServerAddress 节点对象
 */
+(void)setServerAddress:(DLJSONObject*)address;

/**
 *  初始化方法
 *
 *  @param url      Http 请求地址
 *  @param prameter Http 请求参数 NSString、NSData 数据字典，如果添加了 NSData,
 *                    则http请求的方法会强制为 multipart/form-data。
 *  @param method   请求方法  默认为 GET 请求
 *
 *  @return   返回 MSHttpRequest 对象
 */
- (instancetype)initWithUrl:(NSString *)url
                  parameter:(NSDictionary *)prameter
                     method:(DLHttpRequestMethod)method;
/**
 *  初始化方法
 *
 *  @param url    Http 请求地址
 *  @param method 请求方法
 *
 *  @return 返回一个 MSHttpRequest 对象
 */
- (instancetype)initWithUrl:(NSString *)url method:(DLHttpRequestMethod)method;

/**
 *  添加表单数据
 *
 *  @param value 数据
 *  @param key   数据对应的键值
 */
- (void)addParameter:(NSString *)value key:(NSString *)key;


/**
 添加上传图片的请求参数 如果请求方法是 DLHttpRequestMethodUplodeImage 这个方法要调用

 @param image    image
 @param filename 给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 @param name     与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 @param mimeType 默认为image/jpeg
 */
- (void)addUploadImage:(UIImage *)image
              filename:(NSString *)filename
                  name:(NSString *)name
              mimeType:(NSString *)mimeType;


/**
 添加上传文件的请求参数  如果请求方法是 DLHttpRequestMethodUplodeFile 要调用这个方法

 @param uploadingFile 待上传文件的路径
 */
- (void)addUplodeFileFile:(NSString *)uploadingFile;


/**
 添加下载的请求参数    如果请求方法是 DLHttpRequestMethodDownlodeFile 要调用这个方法

 @param saveTopath 保存路径
 */
- (void)addDownloadeFillePath:(NSString *)saveTopath;

/**
 执行请求
 */
- (void)excute;


/**
 取消请求
 */
- (void)cancel;


/**
 取消所有请求
 */
- (void)cancelAllRequest;

@end
