//
//  DNSearchViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSearchViewController.h"
#import "DNLoginViewController.h"
#import "DNTopUpViewController.h"
#import "DNPlayerViewController.h"

@interface DNSearchViewController ()


@end

@implementation DNSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
    [self addNotifi];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryToGetData) name:@"DNRefreshVipState" object:nil];
}
-(void)retryToGetData
{
    if (IsStrEmpty(self.searchTextField.text)) {
        return;
    }
    switch (_topbar.selectIndex) {
        case 0:
        {
            [self searchVideo:self.searchTextField.text];
        }
            break;
        case 1:
        {
            
            [self searchPhoto:self.searchTextField.text];
        }
            break;
        default:
            break;
    }
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    
    [self.customNavigationBar addSubview:self.searchTextField];
    
    [self.customNavigationBar addSubview:self.cancleButton];
    
    
    [self initTopBar];
    [self initPageView];
    
    UISwipeGestureRecognizer *swipeGestureTop = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureTop.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureTop];
    

}

-(void)initTopBar
{
    DLTopBarConfig *topbarConfig = [[DLTopBarConfig alloc]init];
    
    topbarConfig.titleSelectColor = kThemeColor;
    topbarConfig.titleNormalColor = [UIColor customColorWithString:@"#B2B2B2"];
    topbarConfig.underLineColor   = kThemeColor;
    
    topbarConfig.uderLineHeight   = 2;
    topbarConfig.lineType         = DLTopBarUderlineType_equTitleWidth;
    
    _topbar = [[DLTopBarView alloc]initWithFrame:CGRectMake(0,64,KScreenWidth,43) config:topbarConfig];
    _topbar.backgroundColor = [UIColor customColorWithString:@"ffffff"];
    
    NSArray * arr = @[@"视频",
                      @"图片"];
    [_topbar addTabBarItemWithTitles:arr];
    
    _topbar.delegate = self;
    
    _topbar.selectIndex = 0;
    
    [self.view addSubview:_topbar];
}

-(void)initPageView
{
    
    CGRect pageRect = CGRectMake(0, 64+43, KScreenWidth, KScreenHeight-107);
    
    _pageView = [[DLPageView alloc]initWithFrame:pageRect];
    _pageView.delegate = self;

    
    self.viewArray = [NSMutableArray arrayWithCapacity:2];

    [self.viewArray addObject:self.searchVideoView];
    [self.viewArray addObject:self.searchPhotoView];
    [self.pageView addSubviews:self.viewArray];

    [self.view addSubview:_pageView];
}

-(void)selectPhoto:(DNPhotoModel*)photoModel;
{
    NSString * albumid = [NSString stringWithFormat:@"%ld",(long)photoModel.albumid];
    NSString * vip     = [NSString stringWithFormat:@"%@",photoModel.vip];
    
    
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


-(void)selectVideo:(DNVideoModel*)videoModel;
{
    if ([videoModel.vip isEqualToString:@"N"]) {
        
        NSString * playUrl = [videoModel.play valueForKey:@"url"];
        
        if (IsStrEmpty(playUrl)) {
            
            [self.view makeToast:@"视频播放地址错误" duration:3.0 position:CSToastPositionCenter];
            
        }else
        {
            DNPlayerViewController * player = [DNPlayerViewController viewController];
            player.videoModel = videoModel;
            player.enterType = record;
            [self.navigationController pushViewController:player animated:YES];
        }
        
        
        
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
            NSString * playUrl = [videoModel.play valueForKey:@"url"];
            
            if (IsStrEmpty(playUrl)) {
                
                [self.view makeToast:@"视频播放地址错误" duration:3.0 position:CSToastPositionCenter];
                
            }else
            {
                DNPlayerViewController * player = [DNPlayerViewController viewController];
                player.videoModel = videoModel;
                player.enterType = record;
                [self.navigationController pushViewController:player animated:YES];
            }
            
        }
    }

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
        [self searchVideo:self.searchTextField.text];
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
}
/**
 *  视图的item被选中时的回调函数
 *
 *  @param index 视图item的索引
 */
-(void)topTabBarDidSelectedWithIndex:(NSInteger)index
{
    
    [_pageView moveToPageWithIndex:index];
    

    
}

#pragma mark -- pageViewDelegate

/**
 *  滑动时的回调函数
 *
 *  @param index 子视图的索引
 */
- (void)pageViewDidMoveToIndex:(NSInteger)index
{
    _topbar.selectIndex = index;


    if (IsStrEmpty(self.searchTextField.text)) {
        return;
    }
    switch (index) {
        case 0:
        {
            [self searchVideo:self.searchTextField.text];
        }
            break;
        case 1:
        {
            
            [self searchPhoto:self.searchTextField.text];
        }
            break;
        default:
            break;
    }
    
}

/**
 *  滑动时的回调函数
 *
 *  @param percentage 滑动层的偏移量
 */
- (void)pageViewDidScroll:(CGFloat)percentage
{
    NSLog(@"%f",percentage);
    [_topbar moveUnderlineWithPercent:percentage];
    
}



-(void)swipeGesture:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        
        [self.searchTextField resignFirstResponder];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //用来区分点击搜索和模糊搜索
    [_searchTextField resignFirstResponder];
    [self startSearch:textField.text];
    
    return YES;
}

-(void)startSearch:(NSString*)keyword
{


    switch (_topbar.selectIndex) {
        case 0:
        {
            [self searchVideo:keyword];
        }
            break;
            case 1:
        {
       
            [self searchPhoto:keyword];
        }
            break;
        default:
            break;
    }
    

    
}

-(void)searchVideo:(NSString*)keyword
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory searchVideoText:keyword];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        DLJSONArray * jsonArray = [dataObject getJSONArray:@"video"];
        
        NSLog(@" 搜索返回值 %@",jsonArray.array);
        
        if ([jsonArray count]==0) {
            
            [self.view makeToast:@"暂无搜索结果" duration:3.0 position:CSToastPositionCenter];
        }else
        {
           self.searchVideoView.dataArray = [DNVideoModel mj_objectArrayWithKeyValuesArray:jsonArray.array];
            
        }
        
        
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
}

-(void)searchPhoto:(NSString*)keyword
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory searchVideoText:keyword];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONArray * jsonArray = [[object getJSONObject:@"data"] getJSONArray:@"album"];
        
        if ([jsonArray count]==0) {
            
            [self.view makeToast:@"暂无搜索结果" duration:3.0 position:CSToastPositionCenter];
        }else
        {
            self.searchPhotoView.dataArray = [DNPhotoModel mj_objectArrayWithKeyValuesArray:jsonArray.array];
            
            
        }
        
        
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
}



-(UIImageView*)searchImageView
{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc]init];
        _searchImageView.frame = CGRectMake(9,9, 14, 14);
        
        _searchImageView.image = [UIImage imageNamed:@"search_icon"];
    }
    return _searchImageView;
}

-(UIButton*)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(KScreenWidth-62, 22, 60, 40);
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:14];
        [_cancleButton addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

-(UITextField*)searchTextField
{
    if (!_searchTextField) {
        _searchTextField                    = [[UITextField alloc] init];
        _searchTextField.backgroundColor     = [UIColor whiteColor];
        _searchTextField.frame = CGRectMake(47, 26, KScreenWidth-47-64, 32);
        _searchTextField.layer.cornerRadius  = 16;
        _searchTextField.layer.shadowColor = [UIColor customColorWithString:@"38528a"].CGColor;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.placeholder = @"搜索";
        _searchTextField.delegate = self;
        _searchTextField.font = [UIFont fontWithName:TextFontName size:14];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];

        [leftView addSubview:self.searchImageView];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;

 
    }
    return _searchTextField;
    

}

-(DNSearchVideoView*)searchVideoView
{
    if (!_searchVideoView) {
        _searchVideoView = [[DNSearchVideoView alloc]initWithFrame:CGRectMake(0, 107, KScreenWidth, KScreenHeight-107)];
;
        _searchVideoView.delegate = self;
    }
    return _searchVideoView;
}

-(DNSearchPhotoView*)searchPhotoView
{
    if (!_searchPhotoView) {
        _searchPhotoView = [[DNSearchPhotoView alloc]initWithFrame:CGRectMake(0, 107, KScreenWidth, KScreenHeight-107)];
        _searchPhotoView.delegate =self;
    }
    return _searchPhotoView;
}

-(NSMutableArray*)viewArray
{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

-(void)backEvent
{
    [self.navigationController popViewControllerAnimated:YES];
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
