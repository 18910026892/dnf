//
//  DNWebViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>
#import "WebViewJavascriptBridge.h"
#import "DNVideoModel.h"
@interface DNWebViewController : DNBaseViewController
<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}

@property WebViewJavascriptBridge *bridge;

@property(nonatomic,strong)UIButton * backButton;

@property(nonatomic,strong)UIWebView * webView;

@property(nonatomic,copy)NSString *  url;

@property(nonatomic,copy)NSString *  webTitle;

@end
