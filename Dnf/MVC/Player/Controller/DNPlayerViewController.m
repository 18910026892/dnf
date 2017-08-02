//
//  DNPlayerViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPlayerViewController.h"
#import "DNLoginViewController.h"
@interface DNPlayerViewController ()

@property(nonatomic,copy)NSString * videoUrl;

@end

@implementation DNPlayerViewController





-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self playVideo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.xl_sldeMenu.slideEnabled = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    self.xl_sldeMenu.slideEnabled = YES;
    
    [self.videoController dismiss];
    
}

-(void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:YES];
    [self setupUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVideo:) name:@"DLChangeVideo" object:nil];

}


-(void)changeVideo:(NSNotification*)notice
{
    
    NSDictionary * noticeDic= (NSDictionary*)notice.object;
    self.recordModel = [DNRecordModel mj_objectWithKeyValues:noticeDic];

}

-(void)setupUI
{
    [self setTabBarHide:YES];
    [self.view addSubview:self.videoInfoView];
    [self checkVip];
    [self getvideoList];

    self.url = MainUrl(@"videoList");

}

-(void)checkVip
{
    if ([DNSession sharedSession].vip==NO) {
        [self.view addSubview:self.vipView];
        
        CGFloat y = KScreenWidth*(9.0/16.0)+110;
        self.webView.frame = CGRectMake(0, y, KScreenWidth, KScreenHeight-y);
    }else
    {
        [self.vipView removeFromSuperview];
        CGFloat y = KScreenWidth*(9.0/16.0)+60;
        self.webView.frame = CGRectMake(0, y, KScreenWidth, KScreenHeight-y);
    }
    
}

-(void)getvideoList
{
    //浏览记录
    NSString * resource = [NSString stringWithFormat:@"%@",self.recordModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.vrid];
    }else if([resource isEqualToString:@"party"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.partyid];
    }
    
    
    [self getRecommendResource:resource relationid:relationid];
    
}


-(void)playVideo{

    NSURL * videoURL = [NSURL URLWithString:self.videoUrl];

    [self addVideoPlayerWithURL:videoURL];
}

-(void)addVideoPlayerWithURL:(NSURL *)url{
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
    [self.videoController showInView:self
         .view];
    self.videoController.contentURL = url;
 
    [self.videoController.videoControl.closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.videoController.videoControl.videoTitleLabel.text = [NSString stringWithFormat:@"%@",self.recordModel.title];
    
    [self.videoController.videoControl.vipButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}



-(void)backButtonClick:(UIButton*)sender
{
    
    if (self.enterType==web) {
         [self.navigationController popToRootViewControllerAnimated:NO];
    }else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
   
}

-(void)openButtonClick:(UIButton*)sender
{
    DNTopUpViewController * topupVC = [DNTopUpViewController viewController];
    [self.navigationController pushViewController:topupVC animated:YES];

}


-(void)collectButtonClick:(UIButton*)sender
{
    NSLog(@"collection");
    
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
        NSString * resource = [NSString stringWithFormat:@"%@",self.recordModel.resource];
        
        NSString * relationid;
        if ([resource isEqualToString:@"video"]) {
            relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.videoid];
        }else if([resource isEqualToString:@"vr"])
        {
            relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.vrid];
        }else if([resource isEqualToString:@"party"])
        {
            relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.partyid];
        }
        
        DLHttpsBusinesRequest *request = [DLHttpRequestFactory addCollecionResource:resource relationid:relationid];
        
        request.requestSuccess = ^(id response)
        {
            
            self.videoInfoView.collection = YES;
        };
        
        request.requestFaile   = ^(NSError *error)
        {
            
            
        };
        
        [request excute];
    }
    
    


}

-(void)shareButtonClick:(UIButton*)sender
{
    //浏览记录
    NSString * resource = [NSString stringWithFormat:@"%@",self.recordModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.vrid];
    }else if([resource isEqualToString:@"party"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.partyid];
    }
    
    
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

-(DNVideoInfoView*)videoInfoView
{
    if (!_videoInfoView) {
    
        _videoInfoView = [[DNVideoInfoView alloc]init];

        [_videoInfoView.collectionButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoInfoView;
}

-(DNVideoVipView*)vipView
{
    if (!_vipView) {
        _vipView = [[DNVideoVipView alloc]init];
        [_vipView.openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipView;
}





//记录跳转
-(void)setRecordModel:(DNRecordModel *)recordModel
{
    _recordModel = recordModel;
    
    NSString * vip = recordModel.vip;

    if ([vip isEqualToString:@"N"]) {
        
        [self updateInfo:recordModel];
        
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
            [self updateInfo:recordModel];
        }
    }
    
    
 
    
}

-(void)updateInfo:(DNRecordModel*)recordModel
{
    self.videoUrl = [self.recordModel.play valueForKey:@"url"];
    //视频地址
    self.videoController.contentURL =  [NSURL URLWithString:self.videoUrl];
    
    //视频信息
    self.videoInfoView.collection = (recordModel.favoriteid==0)?NO:YES;
    
    if (self.videoInfoView.collection==YES) {
        self.videoInfoView.collectionButton.userInteractionEnabled = NO;
    }
    
    
    self.videoInfoView.videoTitleLabel.text =  [NSString stringWithFormat:@"%@",recordModel.title];
    self.videoInfoView.watchCountLabel.text = [NSString stringWithFormat:@"%ld次播放",recordModel.watches];
    
    
    //浏览记录
    NSString * resource = [NSString stringWithFormat:@"%@",recordModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)recordModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)recordModel.vrid];
    }else if([resource isEqualToString:@"party"])
    {
         relationid = [NSString stringWithFormat:@"%ld",(long)recordModel.partyid];
    }
    
    [self recordResource:resource relationid:relationid];
    

    
}

-(void)getRecommendResource:(NSString*)resource
           relationid:(NSString*)relationid
{
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory recommendVideoResource:resource relationid:relationid];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        self.videoController.videoControl.videoArray = [dataObject getJSONArray:@"recommend"].array;
        
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
    
}

-(void)recordResource:(NSString*)resource
           relationid:(NSString*)relationid;
{
 
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory addRecordResource:resource relationid:relationid];

    [request excute];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
