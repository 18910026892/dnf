//
//  DNHomePageViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNHomePageViewController.h"
#import "DNHomePageCollectionReusableView.h"
#import "DNTopUpViewController.h"
#import "DNPlayerViewController.h"
@interface DNHomePageViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,DNHomePageCollectionReusableViewDelegate>

@property(nonatomic,strong)UICollectionView * collectionView;

//推荐图片数组
@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)DNHomePageCollectionReusableView * collecitonHeader;

@property(nonatomic,assign) int offset;


@end

@implementation DNHomePageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabBarHide:NO];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}


-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
    [self creatUserInterface];
    [self fastlogin];
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

-(void)creatUserInterface
{
    [self.view addSubview:self.collectionView];
}


-(void)getBannerList
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getBannerList];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONArray * jsonArray = [[object getJSONObject:@"data"] getJSONArray:@"recommend"];
        

        NSMutableArray * imageArray = [NSMutableArray array];
        
        NSMutableArray * bannerArray = [DNVideoModel mj_objectArrayWithKeyValuesArray:jsonArray.array];
        
        for (NSDictionary * dict in jsonArray.array) {
            
            [imageArray addObject:[dict valueForKey:@"cover"]];
        }
        
        self.collecitonHeader.bannerImageArray = imageArray;
        self.collecitonHeader.bannerArray = bannerArray;
     
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
     
    };
    
    [request excute];
}


-(void)getRecommendVideo
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory recommendVideo];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONArray * jsonArray = [[object getJSONObject:@"data"] getJSONArray:@"recommend"];
        
        self.collecitonHeader.dataArray = [DNVideoModel mj_objectArrayWithKeyValuesArray:jsonArray.array];
        
        
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
}

-(void)fastlogin
{
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory fastLogin:[DNSession sharedSession].token];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        NSInteger resultCode = [object getInteger:@"errno"];
        
        [DNSession sharedSession].loginServerTime = [object getLong:@"time"];
     
        
        if (0 == resultCode) {
     
            DLJSONObject *resultData = [object getJSONObject:@"data"];
       
            [DNSession sharedSession].uid  = [resultData getString:@"uid"];
            
            [DNSession sharedSession].token = [resultData getString:@"token"];
            
            [DNSession sharedSession].birthday = [resultData getString:@"birth"];
            
            [DNSession sharedSession].avatar  = [resultData getString:@"avatar"];
            
            [DNSession sharedSession].nickname = [resultData getString:@"nickname"];
            
            [DNSession sharedSession].sex  = [resultData getString:@"gender"];
            
            [DNSession sharedSession].token = [resultData getString:@"token"];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DNUserInfoChange" object:nil];
            
            //获取vip信息
           [self cheakIsVip];
            
        }else
            
        {
           
            [[DNSession sharedSession] removeUserInfo];
        }
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        [[DNSession sharedSession] removeUserInfo];
    };
    
    [request excute];
}

-(void)cheakIsVip
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory checkIsVip];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        NSString * isvip = [dataObject getString:@"isvip"];
        
        [DNSession sharedSession].vip = ([isvip isEqualToString:@"Y"])?YES:NO;
      
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
      
    };
    
    [request excute];
}

-(void)requestDataWithType:(int)type
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory recommendAlbum :@"9" offset:[NSString stringWithFormat:@"%d",_offset]];

    request.requestSuccess = ^(id response){ // 成功回调
 
        // 取数据
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * albumArray = [dataObject getJSONArray:@"recommend"];
        
        NSMutableArray * modelArray = [DNPhotoModel mj_objectArrayWithKeyValuesArray:albumArray.array];
        
        if (type == 1) {
            
            //首先要清空id 数组 和数据源数组
            self.dataArray = [NSMutableArray arrayWithArray:modelArray];
            
        }else if(type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:self.dataArray];
            [Array addObjectsFromArray:modelArray];
            self.dataArray = Array;
            
        }
        
        
        //判断是否有更多数据
        _offset = [dataObject getInteger:@"offset"];
        
        [self stopLoadData];
        
        [self nomoredata:modelArray];

        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
    
  
    
}


-(void)nomoredata:(NSMutableArray*)array
{
    if ([array count]==0) {
        
        self.collectionView.mj_footer = nil;
    }
    
}

//停止刷新
-(void)stopLoadData
{
    
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
    [_collectionView reloadData];
    
}

//重新加载请求
-(void)retryToGetData
{
    _offset = 0;
    
    [self getBannerList];
    [self getRecommendVideo];
    [self requestDataWithType:1];
    
    __weak __typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
        
    }];
}


-(void)loadMoreData
{
    [self requestDataWithType:2];
}


#pragma mark - collectionView Delegate


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//设置一组有多少item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DNPhotoCollectionViewCell * cell;
    if(!cell)
    {
        cell= (DNPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DNPhotoCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.photoModel = self.dataArray[indexPath.row];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DNPhotoModel * photoModel = self.dataArray[indexPath.row];
    
    [self toPhoto:photoModel];
    
}

-(void)toPhoto:(DNPhotoModel *)photoModel
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

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12,15,0,15);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGFloat height = KScreenWidth/345*194 +270;
    return CGSizeMake(KScreenWidth,height);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionFooter) {
        NSLog(@"footer");
    }
    _collecitonHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DNHomePageCollectionReusableView" forIndexPath:indexPath];
    
    _collecitonHeader.videoDelegate = self;
    
    [_collecitonHeader.upMoreButton addTarget:self action:@selector(upMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
     [_collecitonHeader.downMoreButton addTarget:self action:@selector(downMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _collecitonHeader;
}

-(void)upMoreClick:(UIButton*)sender
{
    [self.tabBar setTabBarSelectedIndex:1];
}

-(void)downMoreClick:(UIButton*)sender
{
    [self.tabBar setTabBarSelectedIndex:3];
}

-(void)selectVideo:(DNVideoModel*)videoModel
{
    if ([videoModel.vip isEqualToString:@"N"]) {
        
        NSString * playUrl = [videoModel.play valueForKey:@"url"];
        
        if (IsStrEmpty(playUrl)) {
            
            [self.view makeToast:@"视频播放地址错误" duration:3.0 position:CSToastPositionCenter];
            
        }else
        {
            DNPlayerViewController * player = [DNPlayerViewController viewController];
            player.videoModel = videoModel;
            player.enterType = web;
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
                player.enterType = web;
                
                [self.navigationController pushViewController:player animated:YES];
            }
            
        }
    }

}

-(void)didSelectPhoto:(DNPhotoModel*)photoModel
{
    [self toPhoto:photoModel];
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 7.5;
        layout.minimumInteritemSpacing = 7.5;
        
        CGFloat itemWidth = (KScreenWidth-45)/3;
        CGFloat itemHeight = itemWidth/110*217;
        
        layout.itemSize = CGSizeMake(itemWidth,itemHeight);
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,64,KScreenWidth,KScreenHeight-118) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DNPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"DNPhotoCollectionViewCell"];
        
        [_collectionView registerClass:[DNHomePageCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNHomePageCollectionReusableView"];
        
        __weak __typeof(self) weakSelf = self;
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf retryToGetData];
            
        }];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadMoreData];
            
        }];
        
        
        
        [_collectionView.mj_header beginRefreshing];
        
    }
    return _collectionView;
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
