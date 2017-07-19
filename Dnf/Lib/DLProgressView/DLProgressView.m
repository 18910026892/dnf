//
//  DLProgressView.m
//  Dreamer-ios-client
//
//  Created by Ant on 16/12/26.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "DLProgressView.h"

@implementation DLProgressView
{
    UIButton* mCloseButton;
}

#pragma mark - 类方法
+(void)show:(NSString*)message
{
    DLProgressView* progress = [[DLProgressView alloc] init];
    progress.labelText = message;
    [progress show];
}

+(void)show:(NSString* _Nonnull)message cancelback:(DLProgressViewCancelCallBack _Nullable)callback
{
    DLProgressView* progress = [[DLProgressView alloc] init];
    progress.labelText = message;
    progress.cancelable = YES;
    progress.cancelCallback = callback;
    [progress show];
}

+(void)hide
{
    MBProgressHUD* v = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (v){
        [v hide:YES];
    }
}

+(void)setMessage:(NSString* _Nonnull)message
{
    MBProgressHUD* v = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (v){
        v.labelText = message;
    }
}

#pragma mark - 属性方法


#pragma mark - 公共方法
-(void)show
{
    UIView* view = [UIApplication sharedApplication].keyWindow;
    self.removeFromSuperViewOnHide = YES;
    [view addSubview:self];
    
    if (_cancelable) {
        UIImage *image = [UIImage imageNamed:@"progress_close"];
        mCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mCloseButton setImage:image
                      forState:UIControlStateNormal];
        
        mCloseButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [mCloseButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mCloseButton];
    }
    
    [self show:YES];
}

-(void)close
{
    [mCloseButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self hide:YES];
}

#pragma mark 私有方法
-(void)cancel
{
    if (_cancelCallback) {
        _cancelCallback();
    }
    
    [self close];
}

#pragma mark 重写方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = mCloseButton.frame;
    CGSize size  = self.size;
    frame.origin.x = (self.bounds.size.width + size.width) / 2 + self.xOffset - frame.size.width / 2;
    frame.origin.y = (self.bounds.size.height - size.height) / 2 + self.yOffset - frame.size.height / 2;
    
    mCloseButton.frame = frame;
}


@end
