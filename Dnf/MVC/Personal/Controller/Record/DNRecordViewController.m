//
//  DNRecordViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNRecordViewController.h"
#import "DNPlayerViewController.h"
#import "DNTopUpViewController.h"
@interface DNRecordViewController ()


@end

@implementation DNRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit = NO;
    [self creatUserInterface];

}

-(void)showLeft
{
    [self.xl_sldeMenu showLeftViewControllerAnimated:YES];
    
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    
    [self setNavTitle:@"浏览记录"];
    [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.leftButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.deleteButton];

}



-(void)rightButtonClick:(UIButton*)sender
{
    self.isEdit = !self.isEdit;
    
}

-(void)deleteButtonClick:(UIButton*)sender
{
  
     NSInteger  dataCount = [self.videoIdArray count];
    
    if (dataCount==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先选择要删除的对象" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            
            
        }];

        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
       
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"这些项目将从您的收藏中删除" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            
            
        }];
        
        NSString * deleteString = [NSString stringWithFormat:@"删除%ld个项目",dataCount];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:deleteString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString * idString = [self.videoIdArray componentsJoinedByString:@","];
            
             [self deleteRecordWithIdString:idString];
            
        }];
        
        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [deleteAction setValue:[UIColor customColorWithString:@"fe3824"] forKey:@"_titleTextColor"];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

-(void)deleteRecordWithIdString:(NSString*)idString
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory deleteRecordWithAccessidid:idString];
    
    request.requestSuccess = ^(id response)
    {
   
        self.isEdit = NO;
      
        [self  retryToGetData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DNRecordListChange" object:nil];
       
        [self.view makeToast:@"删除成功" duration:3.0 position:CSToastPositionCenter];
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
}


-(void)clear
{

    NSInteger  dataCount = [self.dataArray count];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"这些项目将从您的收藏中删除" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        
     
    }];
    
    NSString * deleteString = [NSString stringWithFormat:@"删除%ld个项目",dataCount];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:deleteString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
 
        
        [self deleteRecordWithIdString:@"all"];
    
    }];

    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [deleteAction setValue:[UIColor customColorWithString:@"fe3824"] forKey:@"_titleTextColor"];

    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];

    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)getDataWithType:(int)type
{


    
    NSString * offsetString = [NSString stringWithFormat:@"%d",self.offset];
    
    DLHttpsBusinesRequest *request=  [DLHttpRequestFactory getRecordListWithNumber:@"40" offset:offsetString];
   
    request.requestSuccess = ^(id response)
    {
            [self hideNoDataView];
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * jsonArray = [dataObject getJSONArray:@"access"];
        
        NSMutableArray * modelArray = [DNVideoModel mj_objectArrayWithKeyValuesArray:jsonArray.array];
        
        if (type == 1) {
            
            self.dataArray = [NSMutableArray arrayWithArray:modelArray];
            
        }else if(type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:self.dataArray];
            [Array addObjectsFromArray:modelArray];
            self.dataArray = Array;
            
        }
        
        
        //停止loading
        [self stopLoadData];
        
        //判断是否有更多数据
        _offset = [dataObject getInteger:@"offset"];
        
        _total  = [dataObject getInteger:@"total"];
        
        
        //没有数据
        [self noDataMethods];
        
        if ([modelArray count]==0) {
            self.collectionView.mj_footer = nil;
        }
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
    
}

//停止刷新
-(void)stopLoadData
{
    
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
    [self.collectionView reloadData];
    
}

//加载更多数据
-(void)loadMoreData
{
    [self getDataWithType:2];
}

//没有数据
-(void)noDataMethods
{
    if (self.dataArray.count==0) {
        
        self.clearButton.hidden = YES;
        self.rightButton.hidden = YES;
        
        [self showNoDataView:self.collectionView noDataString:@"没有浏览记录"
                 noDataImage:@"default_nobrowselog"
              imageViewFrame:CGRectMake((KScreenWidth-104)/2.0,
                                        122,
                                        104,
                                        80)];
        
    }else
    {
        
        self.clearButton.hidden = NO;
        self.rightButton.hidden = NO;
        __weak __typeof(self) weakSelf = self;
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadMoreData];
            
        }];
        
    }
}

#pragma CollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.dataArray count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    DNRecordCollectionViewCell * cell;
    
    if(!cell)
    {
        cell= ( DNRecordCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DNRecordCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.videoModel = self.dataArray[indexPath.row];
    cell.selectImageView.hidden = !self.isEdit;
    cell.tag = 1000+indexPath.row;

    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{

    if ([self.dataArray count]==0) {
       
        return CGSizeMake(KScreenWidth, 0);
        
    }else
       
    return CGSizeMake(KScreenWidth,52);
 
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionFooter) {
        NSLog(@"footer");
    }
    _collectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DNRecordHeaderView" forIndexPath:indexPath];
    _collectionHeader.backgroundColor = [UIColor customColorWithString:@"fafafa"];

    
    
    return _collectionHeader;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    DNVideoModel * videoModel = self.dataArray[indexPath.row];

    if (self.isEdit==NO) {
        
        [self playVideo:videoModel];
    }else
        
    {
        [self editVideoModel:videoModel IndexPath:indexPath];
    }
    

}

-(void)editVideoModel:(DNVideoModel *)videoModel
   IndexPath:(NSIndexPath *)indexPath
{
    DNRecordCollectionViewCell * cell = [self.collectionView viewWithTag:1000+indexPath.row];
    if (cell.selected) {
        
        [self.videoIdArray addObject:[NSString stringWithFormat:@"%ld",(long)videoModel.accessid]];
        
    }else
    {
        
        [self.videoIdArray removeObject:[NSString stringWithFormat:@"%ld",(long)videoModel.accessid]];
        
    }
    
    self.collectionHeader.selectCount = [self.videoIdArray count];
    
    NSLog(@" %@",self.videoIdArray);

    
}


-(void)playVideo:(DNVideoModel*)videoModel
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


#pragma mark --UICollectionViewDelegate

//重新加载请求
-(void)retryToGetData
{
    self.offset = 0;
    [self getDataWithType:1];
    
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,15,0,15);
}



#pragma mark setter
-(void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    
    self.leftButton.hidden = _isEdit;
    self.clearButton.hidden = _isEdit;
    self.deleteButton.hidden = !_isEdit;
    self.collectionHeader.selectLabel.hidden= !_isEdit;
    self.titleLabel.text = (_isEdit==NO)?@"浏览记录":@"选择项目";
    [self.rightButton setTitle:(_isEdit==NO)?@"管理":@"取消" forState:UIControlStateNormal];
    
    CGFloat collectionY = (isEdit==NO)?107:64;
    self.collectionView.y = collectionY;
    [self.collectionView reloadData];
    
    
    if (isEdit==NO) {
        __weak __typeof(self) weakSelf = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf retryToGetData];
        }];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadMoreData];
            
        }];
    }else
    {
        _collectionView.mj_header = nil;
        
        _collectionView.mj_footer = nil;
    }
    
}

#pragma mark getter

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        
        CGFloat cellWidth = KScreenWidth/2-15-3.5;
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        layout.itemSize = CGSizeMake(cellWidth, cellWidth*9/16);
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,64+43,KScreenWidth,KScreenHeight-64-43) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[DNRecordCollectionViewCell class] forCellWithReuseIdentifier:@"DNRecordCollectionViewCell"];
        [_collectionView registerClass:[DNRecordHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNRecordHeaderView"];
        
        
        __weak __typeof(self) weakSelf = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf retryToGetData];
        }];
        
        [_collectionView.mj_header beginRefreshing];
        
    }
    return _collectionView;
}


-(UIButton*)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0,KScreenHeight-43, KScreenWidth, 43);
        _deleteButton.backgroundColor = [[UIColor customColorWithString:@"fafafa"] colorWithAlphaComponent:0.9];
        [_deleteButton setImage:[UIImage imageNamed:@"record_delete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}


-(UIButton*)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(0,64, KScreenWidth, 43);

        _clearButton.backgroundColor = [UIColor whiteColor];
        [_clearButton setTitle:@"一键清空" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clearButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _clearButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 13);
        
        [_clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}



-(NSMutableArray*)videoIdArray
{
    if (!_videoIdArray) {
        _videoIdArray = [NSMutableArray array];
    }
    return _videoIdArray;
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
