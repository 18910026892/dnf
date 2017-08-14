//
//  DNWebViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNWebViewController.h"
#import "DNTopUpViewController.h"
#import "DNPlayerViewController.h"
#import "DNSearchViewController.h"
#import "DNLoginViewController.h"
@interface DNWebViewController ()

@end

@implementation DNWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self creatUserInterface];
    // Do any additional setup after loading the view.
    [self setNavTitle:_webTitle];

    // 1、 开启日志

    [WebViewJavascriptBridge enableLogging];
    
    // 2、给指定的webView建立js与Objc的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    [self registerMethodToJs];
    

    
}



-(void)setCookie
{
    if (IsStrEmpty([DNSession sharedSession].token)) {
        return;
    }
    

    NSString *urlstr  = self.url; //[self.parameter valueForKey:DL_VC_PARAM_KEY_URL];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"token" forKey:NSHTTPCookieName];
    [cookieProperties setObject:[DNSession sharedSession].token forKey:NSHTTPCookieValue];
    if ([urlstr containsString:@"html5.dnfe.tv"]) {
        [cookieProperties setObject:@"html5.dnfe.tv" forKey:NSHTTPCookieDomain];
    }
    
//    if ([urlstr containsString:@"192.168.1.161"]) {
//        [cookieProperties setObject:@"192.168.1.161" forKey:NSHTTPCookieDomain];
//    }
    
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    
    
}

- (void)deleteCookie{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *urlstr  = self.url;//[self.parameter valueForKey:DL_VC_PARAM_KEY_URL];
    if (urlstr.length) {
        NSArray *cookieAry = [cookieJar cookiesForURL: [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        for (cookie in cookieAry) {
            
            [cookieJar deleteCookie: cookie];
            
        }
        
    }
}
-(void)loadWeb
{
    [self deleteCookie];
    [self setCookie];


    NSString *urlstr  = self.url;

    
    if (urlstr && [urlstr length]) {
        NSURL *url;
        if ([urlstr hasPrefix:@"http://"] || [urlstr hasPrefix:@"https://"] ) {
            url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //[NSURL URLWithString:@"http://html5.dnfe.tv/test1.php"]
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
        [_webView loadRequest:request];
    }
    
   
//    
//    NSString *htmlpath = [[NSBundle mainBundle] pathForResource:@"index3" ofType:@"html"];
//    NSString* appHtml = [NSString stringWithContentsOfFile:htmlpath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlpath];
//    [self.webView loadHTMLString:appHtml baseURL:baseURL];
  
}

#pragma mark -- jsBrige注册时间给Html5调用

- (void)registerMethodToJs
{
    __weak DNWebViewController *weakSelf = self;

    [self.bridge registerHandler:@"gotoNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        DLJSONObject *object = [[DLJSONObject alloc]initWithDictionary:data];
        
        NSString * type = [object getString:@"type"];
        
        DLJSONObject *obj = [object getJSONObject:@"data"];

        //收藏
        if ([type isEqualToString:@"toColumn"]) {
            [weakSelf toColumn:obj];
        }else if([type isEqualToString:@"toShare"])
        {
            [weakSelf toShare:obj];
        }else if([type isEqualToString:@"toVideo"])
        {
            [weakSelf toVideo:obj];
             
        }else if([type isEqualToString:@"toPhoto"])
        {
            [weakSelf toPhoto:obj];
            
        }else if([type isEqualToString:@"toFavorite"])
        {
            
            if ([[DNSession sharedSession] isLogin]==NO) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录，请先完成登录" preferredStyle:UIAlertControllerStyleAlert];
                
                // Create the actions.
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
                }];
                
                [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                    DNLoginViewController * login = [DNLoginViewController viewController];
                    [self.navigationController pushViewController:login animated:YES];
                    
                }];
                
                [otherAction setValue:kThemeColor forKey:@"_titleTextColor"];
                
                
                // Add the actions.
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else
            {
                NSString * resource = [obj getString:@"resource"];
                NSString * relationid;
                if ([resource isEqualToString:@"video"]) {
                    relationid = [NSString stringWithFormat:@"%@",[obj getString:@"videoid"]];
                }else if([resource isEqualToString:@"vr"])
                {
                    relationid = [NSString stringWithFormat:@"%@",[obj getString:@"vrid"]];
                }else if([resource isEqualToString:@"party"])
                {
                    relationid = [NSString stringWithFormat:@"%@",[obj getString:@"partyid"]];
                }
                
                DLHttpsBusinesRequest *request = [DLHttpRequestFactory addCollecionResource:resource relationid:relationid];
                
                request.requestSuccess = ^(id response)
                {
                    
                    responseCallback(@"0");
                };
                
                request.requestFaile   = ^(NSError *error)
                {
                    
                    responseCallback(@"1");
                };
                
                [request excute];
            }

            
       
         
        }
        
    }];

}




-(void)toPhoto:(DLJSONObject*)obj
{

    NSString * albumid = [obj getString:@"albumid"];
    NSString * vip     = [obj getString:@"vip"];
    NSString * relationid = [obj getString:@"relationid"];

    if ([vip isEqualToString:@"N"]) {
   
        [self getPhotoData:albumid];
        
    }else
    {
        if ([DNSession sharedSession].vip==NO) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"VIP购买" message:@"非VIP用户，无法查看以下内容\n请购买VIP后再来观看" preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            }];
            
            [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                DNTopUpViewController * topUp = [DNTopUpViewController viewController];
                [self.navigationController pushViewController:topUp animated:YES];
                
            }];
            
            [otherAction setValue:kThemeColor forKey:@"_titleTextColor"];
            
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else
            
        {
               [self getPhotoData:albumid];
        }
    }
    
    
    
    
}

-(void)getPhotoData:(NSString*)albumid
{
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getPhoto:albumid];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * photo = [dataObject getJSONArray:@"photo"];
        
        [self showPhoto:photo];
        
        
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
    };
    
    [request excute];
}


-(void)showPhoto:(DLJSONArray * )photo
{
    //1.创建图片浏览器
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    
    
    for (int i = 0 ; i < photo.array.count; i++) {
        NSDictionary * play = [photo.array[i] valueForKey:@"play"];
        NSString *pic = [play valueForKey:@"url"];
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:pic];
        [photos addObject:photo];
    }
    brower.photos = photos;
    
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = 0;
    
    
    if ([photos count]==0) {
        
        [self.view makeToast:@"图片为空，请重试" duration:3.0 position:CSToastPositionCenter];
        
        return;
    }
    
    //4.显示浏览器
    [brower show];
    
}

-(void)toVideo:(DLJSONObject*)obj
{
    NSDictionary * videoDict = obj.dictionary;
    DNVideoModel * model = [DNVideoModel mj_objectWithKeyValues:videoDict];
    [self playVideo:model];
}

-(void)playVideo:(DNVideoModel*)videoModel
{
   
    if ([videoModel.vip isEqualToString:@"N"]) {
        
        NSString * playUrl = [videoModel.play valueForKey:@"url"];
        
        if (IsStrEmpty(playUrl)) {
        
             [self.view makeToast:@"视频播放地址错误" duration:3.0 position:CSToastPositionCenter];
            
        }else
        {
            DNPlayerViewController * player = [DNPlayerViewController viewController];
            player.enterType = web;
            player.videoModel = videoModel;
            [self.navigationController pushViewController:player animated:YES];
        }
        
      
    }else
    {
        
        if ([DNSession sharedSession].vip==YES) {
            NSString * playUrl = [videoModel.play valueForKey:@"url"];
            
            if (IsStrEmpty(playUrl)) {
                
                  [self.view makeToast:@"视频播放地址错误" duration:3.0 position:CSToastPositionCenter];
                
            }else
            {
                DNPlayerViewController * player = [DNPlayerViewController viewController];
                player.enterType = web;
                player.videoModel = videoModel;
                [self.navigationController pushViewController:player animated:YES];
            }
            
        }else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"VIP购买" message:@"非VIP用户，无法查看以下内容\n请购买VIP后再来观看" preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            }];
            
            [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                DNTopUpViewController * topUp = [DNTopUpViewController viewController];
                [self.navigationController pushViewController:topUp animated:YES];
                
            }];
            
            [otherAction setValue:kThemeColor forKey:@"_titleTextColor"];
            
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
    }
    
}


-(void)toColumn:(DLJSONObject*)obj
{
    
    NSInteger target = [obj getInteger:@"target"];
    NSString * query  = [obj getString:@"query"];
    
    
    if (target==5) {
        //去搜索页
        DNSearchViewController * searchVc = [DNSearchViewController viewController];
        searchVc.searchTextField.text = query;
        [self.navigationController pushViewController:searchVc animated:YES];
 
    }else
    {
       [self.tabBar setTabBarSelectedIndex:target];
    }
    

}

-(void)toShare:(DLJSONObject*)obj
{
    
    //浏览记录
    NSString * resource = [obj getString:@"resource"];
    
    NSString * relationid = [obj getString:@"relationid"];
    
    NSDictionary * shareDict = [NSDictionary dictionaryWithObjectsAndKeys:relationid,@"relationid",nil];
    
    [DLShareView showMyShareViewWothSuperView:self.view
                                  isShowLaHei:NO
                                       userId:nil
                                      andType:10
                                resourcesType:resource
                                    andRoomID:@"1"
                                 andShareDict:shareDict
                                    backColor:nil];
}


-(void)initProgressView
{
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    CGRect barFrame = CGRectMake(0,64,KScreenWidth,2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    
    [self.view addSubview:_webViewProgressView];
}


-(void)creatUserInterface
{
    self.view.backgroundColor = [UIColor customColorWithString:@"fafafa"];
    [self.view addSubview:self.webView];
    [self initProgressView];
}

-(UIWebView*)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-54)];
        _webView.backgroundColor = [UIColor customColorWithString:@"fafafa"];
        _webView.delegate = self;
        _webView.opaque  = NO;
        _webView.tag = 1;
        _webView.scalesPageToFit = YES;
        _webView.autoresizesSubviews = YES;
        
    }
    return _webView;
}



-(void)setUrl:(NSString *)url
{
    _url = url;

    NSLog(@" url %@",url);
    
    [self loadWeb];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    
    NSLog(@"网络加载进度 %f",progress);
    [_webViewProgressView setProgress:progress animated:YES];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
