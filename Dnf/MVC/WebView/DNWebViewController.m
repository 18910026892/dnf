//
//  DNWebViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNWebViewController.h"

typedef NS_ENUM(NSInteger, DLJSGotonativeType)
{
    DLJSGotonativeType_gotoPhoto = 1,//图片
    DLJSGotonativeType_gotoVideo = 2,//小视频
    DLJSGotonativeType_gotoVR = 3, // VR


};


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

#pragma mark -- jsBrige注册时间给Html5调用

- (void)registerMethodToJs
{
 
    
    [self.bridge registerHandler:@"gotoNative" handler:^(id data, WVJBResponseCallback responseCallback) {
    
        [self gotoNative:data];
    }];

}

- (void)gotoNative:(NSDictionary *)object
{
 
    NSInteger type = 1;
    switch (type) {
        case DLJSGotonativeType_gotoPhoto: // 图片浏览器
        {
            
        }
            break;
        case DLJSGotonativeType_gotoVideo: //视频播放
        {
            
        }
            break;
        case DLJSGotonativeType_gotoVR: //vr
        {
            
        }
            break;
        default:
            break;
    }
}


-(void)initProgressView
{
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    CGRect barFrame = CGRectMake(0,62,KScreenWidth,2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    
    [self.view addSubview:_webViewProgressView];
}


-(void)creatUserInterface
{
    [self.view addSubview:self.webView];
    [self initProgressView];
}

-(UIWebView*)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-113)];
        _webView.backgroundColor = [UIColor clearColor];
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
    NSURL * URL = [NSURL URLWithString:url];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
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
