//
//  DLShareView.m
//  Dreamer
//
//  Created by frank on 16/10/4.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import "DLShareView.h"
#import "DLShareContentManager.h"
#import "DLThirdShareManager.h"
#import "DLShareModel.h"
#import <MBProgressHUD.h>
@implementation DLShareView
{
    MBProgressHUD * _hud;
}

+(void)showMyShareViewWothSuperView:(UIView *)superView
                        isShowLaHei:(BOOL)bl
                             userId:(NSString *)userId
                            andType:(int)type
                      resourcesType:(NSString*)resourceType
                          andRoomID:(NSString *)roomID
                       andShareDict:(NSDictionary*)dict
                          backColor:(UIColor *)backColor;
{
    
    //当type 为1000时 小视频分享界面
    for (UIView * view in superView.window.subviews) {
        if ([[view  class] isSubclassOfClass:[DLShareView class]]) {
            [view removeFromSuperview];
        }
    }
    
    DLShareView * view =  [[self alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, KScreenHeight)isShowLaHei:bl
                                               userId:userId
                                                 type:type
                                        resourcesType:resourceType
                                               roomID:roomID
                                         andShareDict:dict
                                            backColor:backColor];
    
    
    [superView.window addSubview:view];
}

-(instancetype)initWithFrame:(CGRect)frame
                 isShowLaHei:(BOOL)bl
                      userId:(NSString *)userId
                        type:(int)type
               resourcesType:(NSString*)resourceType
                      roomID:(NSString *)roomID
                andShareDict:(NSDictionary *)dict
                       backColor:(UIColor *)backColor
{
    
    if ( self = [super initWithFrame:frame]) {
        
        self.userId = userId;
        self.type = type;
        self.resourcesType = resourceType;
        self.shareDict = dict;
        [self createUIIsShowLahei:bl backColor:backColor isFullScreen:YES];
    }
    
    return self;
}

- (instancetype)initWithScreenshotsShareWithFrame:(CGRect)frame
                                           userId:(NSString *)userId
                                             type:(int)type
                                    resourcesType:(NSString*)resourceType
                                           roomID:(NSString *)roomID
                                     andShareDict:(NSDictionary *)dict
                                        backColor:(UIColor *)backColor
{
    
    if ( self = [super initWithFrame:frame]) {
        
        self.userId = userId;
        self.type = type;
        self.resourcesType = resourceType;
        self.shareDict = dict;
        [self createUIIsShowLahei:NO backColor:backColor isFullScreen:NO];
    }
    
    return self;

}

-(void)createUIIsShowLahei:(BOOL)bl backColor:(UIColor *)backColor isFullScreen:(BOOL)isFullScreen
{
    self.backgroundColor        = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.3];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 150)];
    bgView.backgroundColor = [UIColor customColorWithString:@"ffffff"];
    [self addSubview:bgView];

    
    float space;
    CGFloat itemWidth = 0;
    UIColor *platformNameColor = nil;
    
    if (isFullScreen) {
        
        itemWidth = 36;
        platformNameColor = [UIColor customColorWithString:@"999999"];
        
        
    }else{
        
        itemWidth = 32;
        platformNameColor = [UIColor customColorWithString:@"999999"];
    }

    
    if (KScreenWidth <= 320) {
        
        space  = (self.width - itemWidth*4)/8;
        
    }else{
        
          space  = (self.width - itemWidth*5)/10;
    }
    
    NSArray *imageArr = @[@"share_moment",
                        @"share_weibo",
                        @"share_wechat",
                        @"share_qq",
                        @"share_qzone"];
    NSArray *titleArr = @[@"朋友圈",
                          @"微博",
                          @"微信",@"QQ",
                          @"QQ空间"];
  

    float scrollY = 0;
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollY, self.width,100)];
    scroll.backgroundColor = [UIColor customColorWithString:@"ffffff"];
    [bgView addSubview:scroll]; 
    scroll.userInteractionEnabled = YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(itemWidth*5+space*10,100);
    
    if (isFullScreen) {
      
        bgView.y = self.height;
        
        [UIView animateWithDuration:0.3f animations:^{
            bgView.y = self.height - bgView.height;
        }];
    }
    
    for (int i=0; i<imageArr.count; i++) {
        UIView *view = [self createViewWithTitle:titleArr[i]
                                        andImage:imageArr[i]
                                            andX:space+(itemWidth + space*2)*i
                                            andY:21
                                       itemwidth:itemWidth
                               platformNameColor:platformNameColor];
        

        view.tag = 2000 + i;
 
        UITapGestureRecognizer *tapShareView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShareView:)];
        [view addGestureRecognizer:tapShareView];
        [scroll addSubview:view];
    }
    
    // DNF new
    UIView * line = [UIView new];
    line.frame = CGRectMake(0, 100, KScreenWidth, 0.5);
    line.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
    [bgView addSubview:line];
    
    UIButton * cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    cancle.frame = CGRectMake(0, 100, KScreenWidth, 50);
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor customColorWithString:@"484848"] forState:UIControlStateNormal];
    cancle.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
    [cancle addTarget:self action:@selector(tapView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancle];
    
}

-(UIView *)createViewWithTitle:(NSString *)title
                      andImage:(NSString *)image
                          andX:(float)x andY:(float)y
                     itemwidth:(CGFloat)width
             platformNameColor:(UIColor *)platformNameColor
{
    UIView *bgView         = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, 135 - 34 - 20)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,width,width)];
    imageView.image        = [UIImage imageNamed:image];
    
    [bgView addSubview:imageView];
    
    
    UILabel *label      = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5,0, 0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = platformNameColor;
    label.font          = [UIFont fontWithName:TextFontName_Light size:13];
    label.text          = title;
    
    [label sizeToFit];
    [bgView addSubview:label];
   
    label.center = CGPointMake(imageView.center.x, label.y+0.5*label.height);
    
    return bgView;
}




-(void)tapShareView:(UITapGestureRecognizer *)tap
{

 
       NSString * relateid = [self getRelateid];
    
        // target:分享目的地，wx|weibo|qq|qzone|circle 中文意思 微信好友，微博,QQ,qq空间，微信朋友圈
    
        UIView *view = (UIView *)tap.view;
    
    
        switch (view.tag - 2000) {
            case weixin:{
                
                [self shareToplatformWithNSDictionary:@{}  relateid:relateid Type:3 target:@"wx"];
                

                
            }
                break;
            case pengyou:{
                
                [self shareToplatformWithNSDictionary:@{} relateid:@"" Type:1 target:@"circle"];
                //
                
    
                
            }
                break;
            case weibo:{
               
                [self shareToplatformWithNSDictionary:@{} relateid:@"" Type:2 target:@"weibo"];

                
            }
                break;
                
            case qq:{
                
                [self shareToplatformWithNSDictionary:@{}  relateid:relateid Type:4 target:@"qq"];
                

            }
                break;
            case kongjian:{
                
                [self shareToplatformWithNSDictionary:@{}  relateid:relateid Type:5 target:@"qzone"];
                

                
            }
                break;
 
                
            default:
            {
                
            }
                
        }
   
}

- (NSString *)getRelateid
{
    
    NSString * relateid = [self.shareDict valueForKey:@"relationid"];

    
    return relateid;
    

}

-(void)shareToplatformWithNSDictionary:(NSDictionary*)shareDict
                              relateid:(NSString*)relateid
                                  Type:(NSInteger)type
                                target:(NSString*)target
{

    

    DLShareModel *shareModel = [[DLShareModel alloc]init];
    shareModel.shareImage = [UIImage imageNamed:@"share_icon"];
    shareModel.shareUrl    = MainUrl(@"share");
    shareModel.shareContent   = @"身边的小伙伴都下载了大妞范，你还在等什么？";
    shareModel.shareId     = @"1";
    shareModel.shareTarget = target;
    shareModel.shareTitle  = @"大妞范";
    shareModel.resourcesType = self.resourcesType;
    shareModel.relateid      = relateid;
  
    switch (type) {
        case 3:
        {
            [[DLThirdShareManager shareInstance] shareToWechat:shareModel];
        }
            break;
        case 1:
        {
            [[DLThirdShareManager shareInstance] shareToWechatQuan:shareModel];
        }
            break;
        case 4:
        {
            [[DLThirdShareManager shareInstance] shareToQQWithParams:shareModel];
        }
            break;
        case 5:
        {
            [[DLThirdShareManager shareInstance] shareToQQZoneWithParams:shareModel];
        }
            break;
        case 2:
        {
            [[DLThirdShareManager shareInstance] shareToSinaWeiboWith:shareModel];
        }
            break;
   
        default:
            break;
    }
    
}


-(void)tapView
{
    [self removeFromSuperview];
}

+(void)removeShareViewWithSuperView:(UIView *)superView
{
    for (UIView * view in superView.window.subviews) {
        if ([[view  class] isSubclassOfClass:[DLShareView class]]) {
            [view removeFromSuperview];
        }
    }
}


//- (DLLanguageType) getCurrentUseLanguage {
//    DLLanguageType systemlanguageType = [[DLLanguageManager shareInstance] getSystemLanguage];
//    return DLLanguageType_English;
//}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
