//
//  DNThirdLoginManager.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/28.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNThirdLoginManager.h"

#import "AppDelegate.h"

static id _threeLoginManager = nil;


@implementation DNThirdLoginManager

+(instancetype)shareInstance
{
    if (_threeLoginManager==nil) {
        
        _threeLoginManager =
        [[[self class]alloc]init];
        
    }
    
    return _threeLoginManager;
}

-(void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    
    
}

-(void)threeLoginWithPlatform:(SSDKPlatformType)platformType
{
    
    [SSEThirdPartyLoginHelper loginByPlatform:platformType
                                   onUserSync:^(SSDKUser *user,
                                                SSEUserAssociateHandler associateHandler)
     {
         associateHandler (user.uid, user, user);
         
         
         NSMutableDictionary * parameterDic = [NSMutableDictionary dictionary];
         
         [parameterDic setObject:user.credential.token forKey:@"access_token"];
         [parameterDic setObject:user.uid forKey:@"rid"];
         
         NSString * loginType; // 登录平台
         BOOL iswechat = NO;
         switch (platformType) {
                 
             case SSDKPlatformTypeSinaWeibo:
             {
                 loginType=@"sina";
            
             }
                 break;
             case SSDKPlatformTypeWechat:
             {
                 iswechat = YES;
                 loginType=@"wx";
                 NSString * unionid = [user.rawData valueForKey:@"unionid"];
                 NSString * openid  = [user.rawData valueForKey:@"openid"];
                 
                 [parameterDic setValue:openid forKey:@"rid"];
                 [parameterDic setValue:unionid forKey:@"unionid"];
                 
           
                 
             }
                 break;
             case SSDKPlatformTypeQQ:
                 
             {
                 loginType=@"qq";
                 
                
                 
             }
                 
                 break;
                 
         
                 
             default:
                 break;
         }
         
         [parameterDic setObject:loginType forKey:@"source"];
         
         
         [self requestUrlLoginByOpenIdWithParameter:parameterDic isWechat:iswechat];
         
         
         
     } onLoginResult:^(SSDKResponseState state,
                       SSEBaseUser *user,
                       NSError *error)
     {
         
        
         if (state == SSDKResponseStateSuccess)
         {
             
         }
         
     }];
    

}

/*** 第三方登陆 ***/
- (void)requestUrlLoginByOpenIdWithParameter:(NSMutableDictionary *)parameterDic isWechat:(BOOL)iswechat
{
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory thirdLogInWithParamer:parameterDic];
    
    request.requestSuccess = ^(id response){ // 成功回调
        
        DLJSONObject *object = response;
        
        [DNSession sharedSession].loginServerTime = [object getLong:@"time"];
        
        DLJSONObject *resultData = [object getJSONObject:@"data"];
        

        [DNSession sharedSession].uid  = [resultData getString:@"uid"];
        
        [DNSession sharedSession].token = [resultData getString:@"token"];
        
        [DNSession sharedSession].birthday = [resultData getString:@"birth"];
        
        [DNSession sharedSession].avatar  = [resultData getString:@"avatar"];
        
        [DNSession sharedSession].nickname = [resultData getString:@"nickname"];
        
        [DNSession sharedSession].sex  = [resultData getString:@"gender"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DNUserInfoChange" object:nil];
        
        if ([[resultData getString:@"channel"] length]) {
            [DNSession sharedSession].channel = [resultData getString:@"channel"];
        }else{
            [DNSession sharedSession].channel = @"0";
        }
        
        [self cheakIsVip];
        [self changeRootVC];
    
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
      
        
        
    };
    
    [request excute];
}


-(void)cheakIsVip
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory checkIsVip];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        NSString * isvip = [dataObject getString:@"isvip"];
        
        [DNSession sharedSession].vip = ([isvip isEqualToString:@"Y"])?YES:NO;
        
        NSString * state = ([isvip isEqualToString:@"Y"])?@"1":@"0";
        
        NSDictionary * dict =[NSDictionary dictionaryWithObjectsAndKeys:state,@"state", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DNRefreshVipState" object:dict];
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
}



/**
 获取QQ联合id
 */
-(void)useAccessToken:(NSString*)accessToken getQQUnionid:(void (^)(NSString * unionid))unionid
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getQQUnionidAccessTocken:accessToken];
    
    request.requestSuccess = ^(id response)
    {
        
        NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"callback(" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@");" withString:@""];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError * jsonError = nil;
        NSMutableDictionary * dic=[NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:0
                                                                    error:&jsonError];
        if (jsonError) {
        }
        
        NSString * uniString = [dic valueForKey:@"unionid"];
        
        unionid(uniString);
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
    
    
}


-(void)changeRootVC
{
    
    UINavigationController * rootNav = [[UINavigationController alloc] initWithRootViewController:[DNMainTabBarViewController shareTabBarController]];
    
    rootNav.navigationBar.hidden = YES;
    _slideMenu = [[XLSlideMenu alloc] initWithRootViewController:rootNav];
    DNPersonalViewController * personalViewController = [DNPersonalViewController viewController];
    //设置左侧菜单
    _slideMenu.leftViewController = personalViewController;
    self.viewController.view.window.rootViewController = _slideMenu;
}


@end
