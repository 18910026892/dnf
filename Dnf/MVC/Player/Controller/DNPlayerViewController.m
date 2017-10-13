//
//  DNPlayerViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPlayerViewController.h"
#import "DNLoginViewController.h"
#import <StoreKit/StoreKit.h>
@interface DNPlayerViewController ()<DLVideoRecommendTableViewCellDelegate>

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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self storeReview];
}

-(void)storeReview
{

    if ([DNConfig sharedConfig].store==NO) {
        float version = [[UIDevice currentDevice].systemVersion floatValue];
        
        if (version>10.3||version==10.3) {
            
            [SKStoreReviewController requestReview];
            [DNConfig sharedConfig].store= YES;
        }
    }
}
    



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:YES];
    [self setupUI];
    [self addNotifi];


}


-(void)changeVideo:(NSNotification*)notice
{
    
    NSDictionary * noticeDic= (NSDictionary*)notice.object;
    
    
    self.videoModel = [DNVideoModel mj_objectWithKeyValues:noticeDic];

}

-(void)setupUI
{
    [self setTabBarHide:YES];
    [self.view addSubview:self.videoInfoView];
    [self.view addSubview:self.tableView];
    [self checkVip];
    [self getvideoList];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)addNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVideo:) name:@"DLChangeVideo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getvideoList) name:@"DNRefreshVipState" object:nil];
}



-(void)checkVip
{
    CGFloat y;
    if ([DNSession sharedSession].vip==NO) {
        [self.view addSubview:self.vipView];
    
         y = KScreenWidth*(9.0/16.0)+110;
    
    
    }else
    {
        [self.vipView removeFromSuperview];
        y = KScreenWidth*(9.0/16.0)+60;

    }
    
    self.tableView.y = y;
    self.tableView.height = KScreenHeight-y;
    
    
}

-(void)getvideoList
{
    //浏览记录
    NSString * resource = [NSString stringWithFormat:@"%@",self.videoModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.videoModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.videoModel.vrid];
    }else if([resource isEqualToString:@"party"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.videoModel.partyid];
    }
    
    
    [self getRecommendResource:resource relationid:relationid];
    
}


-(void)playVideo{
    
    if(IsStrEmpty(self.videoUrl))
    {
        return;
    }

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
    
    self.videoController.videoControl.videoTitleLabel.text = [NSString stringWithFormat:@"%@",self.videoModel.title];
    
    [self.videoController.videoControl.vipButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if([self.videoModel.resource isEqualToString:@"vr"]||[self.videoModel.resource isEqualToString:@"party"])
    {
        [self.videoController fullScreenButtonClick];
    }
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
    NSString * resource = [NSString stringWithFormat:@"%@",self.videoModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.videoModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.videoModel.vrid];
    }else if([resource isEqualToString:@"party"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)self.videoModel.partyid];
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

-(void)reportButtonClick:(UIButton*)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"举报" message:@"确认要举报当前视频么？" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
            [self.view makeToast:@"举报成功" duration:3 position:CSToastPositionCenter];
        
    }];
    
    [otherAction setValue:kThemeColor forKey:@"_titleTextColor"];
    
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)shareButtonClick:(UIButton*)sender
{
  
    NSString * relationid = @"";
    
    NSDictionary * shareDict = [NSDictionary dictionaryWithObjectsAndKeys:relationid,@"relationid",nil];
    
    [DLShareView showMyShareViewWothSuperView:self.view
                                  isShowLaHei:NO
                                       userId:nil
                                      andType:10
                                resourcesType:@""
                                    andRoomID:@"1"
                                 andShareDict:shareDict
                                    backColor:nil];
}


#pragma mark - TabelView delegate 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 96;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recomendArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString * cellid = @"DLVideoRecommendTableViewCell";
    
    DLVideoRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[DLVideoRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.cellDelegate = self;
    cell.videoModel = self.recomendArray[indexPath.row];
    
    return cell;
    
}

-(void)colleciton:(DNVideoModel*)videoModel;

{
    NSString * resource = [NSString stringWithFormat:@"%@",videoModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)videoModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)videoModel.vrid];
    }else if([resource isEqualToString:@"party"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)videoModel.partyid];
    }
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory addCollecionResource:resource relationid:relationid];
    
    request.requestSuccess = ^(id response)
    {
        [self getvideoList];
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        
    };
    
    [request excute];

}
-(void)share:(DNVideoModel*)videoModel;
{
    NSString * relationid = @"";
    
    NSDictionary * shareDict = [NSDictionary dictionaryWithObjectsAndKeys:relationid,@"relationid",nil];
    
    [DLShareView showMyShareViewWothSuperView:self.view
                                  isShowLaHei:NO
                                       userId:nil
                                      andType:10
                                resourcesType:@""
                                    andRoomID:@"1"
                                 andShareDict:shareDict
                                    backColor:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.videoModel = self.recomendArray[indexPath.row];
  
}

#pragma mark request
-(void)getRecommendResource:(NSString*)resource
                 relationid:(NSString*)relationid
{
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory recommendVideoResource:resource relationid:relationid];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * jsonArray = [dataObject getJSONArray:@"recommend"];
        
        self.videoController.videoControl.videoArray = jsonArray.array;
        
        self.recomendArray = [DNVideoModel mj_objectArrayWithKeyValuesArray:jsonArray.array];
        
        
        [self showNoDataView];
  
        [self.tableView reloadData];
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
    
}

-(void)showNoDataView
{
    if ([self.recomendArray count]==0) {
        
        CGFloat y;
        if ([DNSession sharedSession].vip==NO) {
            
            
            y = KScreenWidth*(9.0/16.0)+110;
            
            
        }else
        {
            y = KScreenWidth*(9.0/16.0)+60;
            
        }
        
        
        CGRect rect  = CGRectMake(KScreenWidth/2-52,100, 104, 80);
        [self showNoDataView:self.tableView noDataString:@"暂无数据" noDataImage:@"default_nodata" imageViewFrame:rect];
        
        
    }
}


-(void)increaseResource:(NSString*)resource
           relationid:(NSString*)relationid
{
    NSString * type = [NSString stringWithFormat:@"watch_%@",resource];
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory increaseCount:type relateid:relationid];

    [request excute];
}

-(void)recordResource:(NSString*)resource
           relationid:(NSString*)relationid;
{
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory addRecordResource:resource relationid:relationid];
    
    [request excute];
}


#pragma mark getter

-(UITableView*)tableView
{
    if (!_tableView) {
        CGFloat y = KScreenWidth*(9.0/16.0)+110;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,y,KScreenWidth,KScreenHeight-y) style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorColor = [UIColor customColorWithString:@"eeeeee"];
    
    }
    return _tableView;
}



-(DNVideoInfoView*)videoInfoView
{
    if (!_videoInfoView) {
    
        _videoInfoView = [[DNVideoInfoView alloc]init];

        [_videoInfoView.collectionButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView.reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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


-(UIView*)tableHeader
{
    if (!_tableHeader) {
        _tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 41)];
        [_tableHeader addSubview:self.circleView];
        [_tableHeader addSubview:self.headerTitle];
    }
    return _tableHeader;
}


-(UIView*)circleView
{
    if (!_circleView) {
        _circleView = [[UIView alloc]initWithFrame:CGRectMake(15, 18, 10, 10)];
        _circleView.layer.cornerRadius = 5;
        _circleView.layer.borderWidth = 1;
        _circleView.layer.borderColor = kThemeColor.CGColor;
        
    }
    return _circleView;
}

-(UILabel*)headerTitle
{
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(34, 12, 200, 24)];
        _headerTitle.text = @"更多推荐视频";
        _headerTitle.textAlignment = NSTextAlignmentLeft;
        _headerTitle.textColor = [UIColor blackColor];
        _headerTitle.font = [UIFont fontWithName:TextFontName_Light size:17];
        
    }
    return _headerTitle;
}

#pragma mark setter
-(void)setVideoModel:(DNVideoModel *)videoModel
{
    _videoModel = videoModel;
    
    NSString * vip = videoModel.vip;
    
    if ([vip isEqualToString:@"N"]) {
        
        [self updateInfo:videoModel];
        
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
            [self updateInfo:videoModel];
        }
    }
 
}

-(void)updateInfo:(DNVideoModel*)videoModel
{
    self.videoUrl = [self.videoModel.play valueForKey:@"url"];
    
    if (IsStrEmpty(_videoUrl)) {
        return;
    }
    
    //视频地址
    self.videoController.contentURL =  [NSURL URLWithString:self.videoUrl];
    
    //视频信息
    self.videoInfoView.collection = (videoModel.favoriteid==0)?NO:YES;
    
    if (self.videoInfoView.collection==YES) {
        self.videoInfoView.collectionButton.userInteractionEnabled = NO;
    }
    
    
    self.videoInfoView.videoTitleLabel.text =  [NSString stringWithFormat:@"%@",videoModel.title];
    self.videoInfoView.watchCountLabel.text = [NSString stringWithFormat:@"%ld次播放",videoModel.watches];
    self.videoController.videoControl.videoTitleLabel.text = [NSString stringWithFormat:@"%@",videoModel.title];
    
    
    //浏览记录
    NSString * resource = [NSString stringWithFormat:@"%@",videoModel.resource];
    
    NSString * relationid;
    if ([resource isEqualToString:@"video"]) {
        relationid = [NSString stringWithFormat:@"%ld",(long)videoModel.videoid];
    }else if([resource isEqualToString:@"vr"])
    {
        relationid = [NSString stringWithFormat:@"%ld",(long)videoModel.vrid];
    }else if([resource isEqualToString:@"party"])
    {
         relationid = [NSString stringWithFormat:@"%ld",(long)videoModel.partyid];
    }
    
    [self recordResource:resource relationid:relationid];
    
    
    [self increaseResource:resource relationid:relationid];

    
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
