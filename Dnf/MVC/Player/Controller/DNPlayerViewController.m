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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 
    [self.videoController dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self playVideo];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:YES];
    [self setupUI];

}

-(void)setupUI
{
    [self setTabBarHide:YES];
    
    [self.view addSubview:self.videoInfoView];
    
    CGFloat y = KScreenWidth*(9.0/16.0)+110;
    self.webView.frame = CGRectMake(0, y, KScreenWidth, KScreenHeight-y);
    
    self.url = MainUrl(@"videoList");
}

-(void)playVideo{

    NSString * playUrl = [self.recordModel.play valueForKey:@"url"];
    NSURL * videoURL = [NSURL URLWithString:playUrl];
    [self addVideoPlayerWithURL:videoURL];
}



-(void)addVideoPlayerWithURL:(NSURL *)url{
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
    [self.videoController showInView:self
         .view];
    self.videoController.contentURL = url;
    
    [self.videoController.videoControl.closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backButtonClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"share");
}

-(DNVideoInfoView*)videoInfoView
{
    if (!_videoInfoView) {
    
        _videoInfoView = [[DNVideoInfoView alloc]init];
        
        [_videoInfoView.openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView.collectionButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoInfoView;
}


-(void)setRecordModel:(DNRecordModel *)recordModel
{
    _recordModel = recordModel;
    
    self.videoInfoView.collection = (recordModel.favoriteid==0)?NO:YES;
    
    if (self.videoInfoView.collection==YES) {
        self.videoInfoView.collectionButton.userInteractionEnabled = NO;
    }
    
    NSString * resource = [NSString stringWithFormat:@"%@",recordModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)recordModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)recordModel.vrid];
    }
    
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
