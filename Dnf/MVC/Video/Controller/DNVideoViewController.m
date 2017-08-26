//
//  DNVideoViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNVideoViewController.h"
#import "DNTopUpViewController.h"
#import "DNPlayerViewController.h"
@interface DNVideoViewController ()

@end

@implementation DNVideoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self addNotifi];
    self.vip = NO;
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryToGetData) name:@"DNRefreshVipState" object:nil];
}


-(void)freeButtonClick:(UIButton*)sender
{
    self.vip = NO;
    self.segmentView.type = 0;
    [self retryToGetData];
}

-(void)vipButtonClick:(UIButton*)sender
{
    self.vip = YES;
    self.segmentView.type = 1;
    [self retryToGetData];
}



-(void)requestDataWithType:(int)type
                     isVip:(BOOL)isVip
{
    DLHttpsBusinesRequest *request;
    
    if (isVip==NO) {
        request =  [DLHttpRequestFactory getFreeVideoList:@"10" offset:[NSString stringWithFormat:@"%d",_offset]];
    }else
    {
        request =  [DLHttpRequestFactory getPayVideoList:@"10" offset:[NSString stringWithFormat:@"%d",_offset]];
    }
    
    
    request.requestSuccess = ^(id response){ // 成功回调
        
        //停止loading
        [self hideNoNetWorkView];
        [self hideNoDataView];
        
        // 取数据
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * videoArray = [dataObject getJSONArray:@"video"];
        
        NSMutableArray * modelArray = [DNVideoModel mj_objectArrayWithKeyValuesArray:videoArray.array];
        
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
        
        [self nodata];
        
        [self nomoredata:modelArray];
        
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        [self nonet];
    };
    
    [request excute];
}

-(void)nodata
{
    if ([self.dataArray count]==0) {
        
        CGRect rect  = CGRectMake(KScreenWidth/2-52, 121, 104, 80);
        [self showNoDataView:self.view noDataString:@"暂无数据" noDataImage:@"default_nodata" imageViewFrame:rect];
    
        [_noDataView setContentViewFrame:CGRectMake(0, 108, KScreenWidth, KScreenHeight-108-54)];
    }
    
}

-(void)nomoredata:(NSMutableArray*)array
{
    if ([array count]==0) {
        
        self.tableView.mj_footer = nil;
    }
    
}

-(void)nonet
{
    
    [self showNoNetWorkViewWithimageName:@"default_nonetwork"];
}
//停止刷新
-(void)stopLoadData
{
    
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [_tableView reloadData];
    
}

//重新加载请求
-(void)retryToGetData
{
    _offset = 0;
    [self requestDataWithType:1 isVip:self.vip];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
        
    }];
}


-(void)loadMoreData
{
    [self requestDataWithType:2 isVip:self.vip];
}


#pragma mark - TabelView delegate 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 210;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString * cellid = @"DNVideoTableViewCell";
    
    DNVideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[DNVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.videoModel = self.dataArray[indexPath.section];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoModel * videoModel = self.dataArray[indexPath.section];
    
    
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


#pragma mark getter setter

-(UITableView*)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,128,KScreenWidth,KScreenHeight-182) style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        
        __weak __typeof(self) weakSelf = self;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf retryToGetData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadMoreData];
            
        }];
        
        
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}


-(DNVipSegmentView*)segmentView
{
    if (!_segmentView) {
        _segmentView = [[DNVipSegmentView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth,64)];
        
        [_segmentView.vipButton addTarget:self action:@selector(vipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_segmentView.freeButton addTarget:self action:@selector(freeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _segmentView;
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
