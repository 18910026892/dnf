//
//  DLThirdShareManager.m
//  Dreamer
//
//  Created by Ant on 16/9/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "DLThirdShareManager.h"

#import "DLShareModel.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "DLThirdShareSDKInitiingizer.h"

static DLJSONObject *ShareSDKKeys; //地址列表
@implementation DLThirdShareManager


static DLThirdShareManager *instance = nil;

+(instancetype)shareInstance
{
    @synchronized (self) {
        if (!instance) {
            instance = [[self alloc] init];
        }
        return instance;
    }
}

+(void)destroyInstance
{
    @synchronized (self) {
        if (instance) {
            instance = nil;
        }
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (void)setShareSDKKeys:(DLJSONObject *)SDKKeys
{
    [DLThirdShareSDKInitiingizer setShareSDKKeys:SDKKeys];
}


- (void)registerApp
{
    [DLThirdShareSDKInitiingizer registerApp];
}


- (void)shareToSinaWeiboWith:(DLShareModel *)model
{
    [self shareWithPlatformType:SSDKPlatformTypeSinaWeibo params:model];
}

- (void)shareToWechat:(DLShareModel *)model
{
    [self shareWithPlatformType:SSDKPlatformTypeWechat params:model];
}

- (void)shareToWechatQuan:(DLShareModel *)model
{
    [self shareWithPlatformType:SSDKPlatformSubTypeWechatTimeline params:model];
}

-(void)shareToFaceBook:(DLShareModel *)model
{
    [self shareWithPlatformType:SSDKPlatformTypeFacebook params:model];
}

-(void)shareToTwitter:(DLShareModel *)model
{
    [self shareWithPlatformType:SSDKPlatformTypeTwitter params:model];
}

-(void)shareToInstragram:(DLShareModel *)model
{
    [self shareWithPlatformType:SSDKPlatformTypeInstagram params:model];
}

- (void)shareToQQWithParams:(DLShareModel *)model
{
    if (![QQApiInterface isQQInstalled]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你还没有安装QQ客户端"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    [self shareWithPlatformType:SSDKPlatformSubTypeQQFriend params:model];
}

- (void)shareToQQZoneWithParams:(DLShareModel *)model
{
    if (![QQApiInterface isQQInstalled]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你还没有安装QQ客户端"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        
        [alert show];
        
  
        
        return;
    }
    
    [self shareWithPlatformType:SSDKPlatformSubTypeQZone params:model];
}


- (void)shareWithPlatformType:(SSDKPlatformType)type params:(DLShareModel *)model
{
    NSString *alertMessage = [self getAlertMessage:type];
    
    UIImage * shareImage = model.shareImage;
    
    //分享的头像
    NSString *imageUrl =  model.shareImageUrl;
   
    //分享的标题
    NSString * shareTitle =model.shareTitle;
    
    //分享的内容
    NSString * shareDesc = model.shareContent;
    
    //分享的地址
    NSString * shareUrl = model.shareUrl;
    

    [self downloadShareImageWithShareImageUrl:imageUrl completed:^(UIImage *image) {
       
        NSArray *imageArray = @[shareImage];
        
        
        NSString * url = [shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *Params= [NSMutableDictionary dictionary];
        
        [Params SSDKSetupShareParamsByText:shareDesc
                                    images:imageArray
                                       url:[NSURL URLWithString:url]
                                     title:shareTitle
                                      type:SSDKContentTypeAuto];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self shareToPlatForm:Params
                     platFormType:type
                       shareModel:model
                     alertMessage:alertMessage];
            
        });
        
    }];
    
}

//- (void)shareScreemshotToPlatformWithType:(SSDKPlatformType)type
//                                   params:(DLShareModel *)model
//                             alertMessage:(NSString *)alertMessage{
//    
//   
//    NSString *image = [self switchPNGToJpg:model.shareImage];
//   
//    NSArray *imageArray = @[image];
//    
//    NSMutableDictionary *Params= [[NSMutableDictionary alloc]init];
//    
//    [Params SSDKSetupShareParamsByText:@"http://www.dreamlive.tv/"
//                                images:imageArray
//                                   url:nil
//                                 title:nil
//                                  type:SSDKContentTypeImage];
//    
//    [self shareToPlatForm:Params
//             platFormType:type
//               shareModel:model
//             alertMessage:alertMessage];
//    
//}

- (void)shareToPlatForm:(NSMutableDictionary *)Params
           platFormType:(SSDKPlatformType)platFormType
             shareModel:(DLShareModel *)model
           alertMessage:(NSString *)alertMessage
{

    
    [ShareSDK share:platFormType parameters:Params onStateChanged:^(SSDKResponseState state,
                                                            NSDictionary *userData,
                                                            SSDKContentEntity *contentEntity,
                                                            NSError *error) {
    
        
        switch (state)
        {
            case SSDKResponseStateSuccess:
            {
                [self shareSuccess:model];
                
            }
                break;
                
            case SSDKResponseStateFail:
            {
                [self shareFailed:platFormType error:error alert:alertMessage];
            }
                break;
                
            case SSDKResponseStateCancel:
            {
                
            }
                break;
                
            default:
                
                break;
        }
        
    }];
    
    NSLog(@" model sharetype %@",model.shareType);
    
}

- (void)shareSuccess:(DLShareModel *)shareModel
{

    
    [self shareCallback:shareModel];
 
}

- (void)shareFailed:(SSDKPlatformType)platformType
              error:(NSError *)error
              alert:(NSString *)alertMessage
{
    /*
     分享到微博时候，点击取消 ，会提示未安装微博客户端
     */
    if (platformType != SSDKPlatformTypeSinaWeibo) {
        
        if (error.code == 208 || error.code == 204) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:alertMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
        
    }

}

- (NSString *)getAlertMessage:(SSDKPlatformType)platformType
{
    NSString *alertMessage = nil;
    
    switch (platformType) {
        case SSDKPlatformTypeSinaWeibo:
            
            alertMessage = @"你还没有安装微博客户端";
            
            
            break;
            
        case SSDKPlatformTypeWechat:
            
            alertMessage = @"你还没有安装微信客户端";
            
            break;
            
        case SSDKPlatformSubTypeWechatTimeline:
            
            alertMessage = @"你还没有安装微信客户端";
            
            break;
            
        case SSDKPlatformSubTypeQQFriend:
            alertMessage = @"你还没有安装QQ客户端";
            break;
            
        case SSDKPlatformSubTypeQZone:
            
            alertMessage = @"你还没有安装QQ客户端";
            
            break;
        case SSDKPlatformTypeFacebook:
            
          //  alertMessage = DLLocalizedString(@"1.0_107", nil);
            
            break;
        case SSDKPlatformTypeTwitter:
            
            //alertMessage = DLLocalizedString(@"1.0_108", nil);
            
            break;
            
            
        default:
            break;
    }

    return alertMessage;
}

- (NSString *)shareTitleWith:(SSDKPlatformType)platFormType
                  shareTitle:(NSString *)shareTitle
                    nickName:(NSString *)nickName
{
  NSString *  temShareTitle = shareTitle;
    
    if ([temShareTitle containsString:@"{nickname}"]||[temShareTitle containsString:@"{title}"])
    {
        
        temShareTitle =  [temShareTitle stringByReplacingOccurrencesOfString:@"{nickname}" withString:nickName];
        
        temShareTitle = [temShareTitle stringByReplacingOccurrencesOfString:@"{title}" withString:nickName];
    }
    
    if (platFormType == SSDKPlatformSubTypeQQFriend || platFormType == SSDKPlatformSubTypeQZone )
    {
        if (temShareTitle.length == 0)
        {
            temShareTitle = @"大妞范";
        }
    }
    
    return temShareTitle;
    
}

- (NSString *)shareDesc:(NSString *)shareDec nickname:(NSString *)nickName
{
    NSString *shareDesc = shareDec;
    
    if ([shareDesc containsString:@"{nickname}"]||[shareDesc containsString:@"{title}"]) {
        
        shareDesc =  [shareDesc stringByReplacingOccurrencesOfString:@"{nickname}" withString:nickName];
        
        shareDesc =  [shareDesc stringByReplacingOccurrencesOfString:@"{title}" withString:nickName];
        
    }
    
    return shareDesc;

}

- (void)downloadShareImageWithShareImageUrl:(NSString *)imageUrl completed:(void(^)(UIImage *image))finish
{
    // 创建分享参数
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl]
                                                          options:SDWebImageDownloaderHighPriority
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
    {
        
        finish(image);
        
    }];

}

- (NSArray *)getImageArrayWithImage:(UIImage *)image
{
    NSArray *imageArray = [NSArray array];
    if (image) {
        imageArray = @[image];
    }else
    {
        imageArray = @[[UIImage imageNamed:@"my_icon_id"]];
    }
    
    return imageArray;
}

- (NSString *)getShareContentWithPlatformType:(SSDKPlatformType)platFormType
                                     shareUrl:(NSString *)shareUrl
                                     shareDes:(NSString *)shareDes
{
    NSString *content    = nil;
    
    if (platFormType == SSDKPlatformTypeSinaWeibo) {
        if (shareDes) {
            content = [NSString stringWithFormat:@"%@%@",shareDes,shareUrl];
            
        } else {
            content = shareUrl;
        }
        
    }else
    {
        content = shareDes;
    }
    
    return content;

}

// 分享统计

- (void)shareCallback:(DLShareModel *)model
{
    //分享统计
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory shareCallBackWithType:model.resourcesType // nil
                                                                             uid:model.uid
                                                                        relateid:model.relateid // nil
                                                                          target:model.shareTarget
                                                                         shareid:model.shareId]; // nil

    
    request.isShowErrorToast = NO;
    
    request.requestSuccess = ^(id response)
    {
       
   
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    
    [request excute];

}

- (NSString *)switchPNGToJpg:(UIImage *)newImage
{
    NSString *temp = NSTemporaryDirectory();
    NSString *imagePath = [temp stringByAppendingPathComponent:@"dreami0.jpg"];
    
    NSData *data = nil;
    data = UIImageJPEGRepresentation(newImage,1);
    [data writeToFile:imagePath atomically:YES];
    
    return imagePath;
}


@end
