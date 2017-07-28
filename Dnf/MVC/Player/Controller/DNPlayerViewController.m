//
//  DNPlayerViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPlayerViewController.h"

@interface DNPlayerViewController ()


@end

@implementation DNPlayerViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


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
    
    [self.videoController dismiss];
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    self.xl_sldeMenu.slideEnabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:YES];
    [self setupUI];
    [self getVideoList];

}

-(void)setupUI
{
    [self setTabBarHide:YES];
    [self.view addSubview:self.videoInfoView];
    [self checkVip];
    [self playVideo];
    
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


-(void)playVideo{

    
//     NSURL *url = [NSURL URLWithString:@"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4"];
    NSURL * videoURL = [NSURL URLWithString:[self.recordModel.play valueForKey:@"url"]];
    [self addVideoPlayerWithURL:videoURL];
}


-(void)getVideoList
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory recommendVideo];
    
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

-(void)addVideoPlayerWithURL:(NSURL *)url{
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
    [self.videoController showInView:self
         .view];
    self.videoController.contentURL = url;
 
    [self.videoController.videoControl.closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.videoController.videoControl.videoTitleLabel.text = [NSString stringWithFormat:@"%@",self.recordModel.title];
    
}



-(void)backButtonClick:(UIButton*)sender
{
    
    if (self.enterType==web) {
         [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
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
    NSString * resource = [NSString stringWithFormat:@"%@",self.recordModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.recordModel.vrid];
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
    }
    
    [self recordResource:resource relationid:relationid];
    
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
