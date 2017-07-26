//
//  DLRecordListView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/20.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DLRecordListView.h"

@implementation DLRecordListView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
      
        _isEdit = NO;
        self.offset = 0;
        [self addSubview:self.collectionView];
        
    }
    return self;
    
}

-(void)getDataWithType:(int)type
{
    DLHttpsBusinesRequest *request;
    
    [_noDataView hide];
 
    NSString * offsetString = [NSString stringWithFormat:@"%d",self.offset];
    
    if ([self.type isEqualToString:@"record"]) {
        request =  [DLHttpRequestFactory getRecordListWithNumber:@"20" offset:offsetString];
    }else
    {
        request = [DLHttpRequestFactory getCollectionListWithNumber:@"20" offset:offsetString];

    }
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * josnArray;
        
        if ([self.type isEqualToString:@"record"]) {
            josnArray = [dataObject getJSONArray:@"access"];
        }else
        {
           josnArray = [dataObject getJSONArray:@"favorite"];
            
        }

    
        NSMutableArray * modelArray = [DNRecordModel mj_objectArrayWithKeyValuesArray:josnArray.array];

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
        
        NSLog(@"没有数据");
        if ([self.type isEqualToString:@"record"]) {
            
            [self showNoDataView:self.collectionView noDataString:@"没有浏览记录"
                     noDataImage:@"default_nobrowselog"
                  imageViewFrame:CGRectMake((KScreenWidth-104)/2.0,
                                            165,
                                            104,
                                            80)];
        }else
        {
            [self showNoDataView:self.collectionView noDataString:@"没有收藏癖记录"
                     noDataImage:@"default_collection"
                  imageViewFrame:CGRectMake((KScreenWidth-104)/2.0,
                                            165,
                                            104,
                                            80)];
        }
        
       
    }else
    {
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [self loadMoreData];
            
        }];
        
    }
}

#pragma mark - NoDataView method
/**
 *  显示无数据视图
 */

-(void)showNoDataView:(UIView*)superView noDataString:(NSString *)noDataString noDataImage:(NSString*)imageName imageViewFrame:(CGRect)rect
{
    if (!_noDataView) {
        _noDataView =  [[DLNoDataView alloc] init];
        _noDataView.delegate = self;
    }
    [_noDataView showNoDataView:superView noDataString:noDataString noDataImage:imageName imageViewFrame:rect];
}


- (void)hideNoDataView
{
    [_noDataView hide];
}

#pragma CollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [_dataArray count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    DNRecordCollectionViewCell * cell;
    
    if(!cell)
    {
        cell= ( DNRecordCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DNRecordCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.recordModel = self.dataArray[indexPath.row];
    cell.selectImageView.hidden = !self.isEdit;
    cell.delegate =  self;
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    if (self.isEdit==YES) {
      
        return CGSizeMake(KScreenWidth,52);
    }else
    {
        if ([self.dataArray count]==0) {
            return CGSizeMake(KScreenWidth, 0);
        }else
            return CGSizeMake(KScreenWidth,95);
    }

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionFooter) {
        NSLog(@"footer");
    }
    _collectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DNRecordHeaderView" forIndexPath:indexPath];
    _collectionHeader.backgroundColor = [UIColor customColorWithString:@"fafafa"];
     [_collectionHeader.clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return _collectionHeader;
}

-(void)clearButtonClick:(UIButton*)sender
{
    if(self.delegate)
    {
        [self.delegate clear];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DNRecordModel * recordModel = self.dataArray[indexPath.row];
    
    if (self.delegate&&self.isEdit==NO) {
        [self.delegate selectRecordModel:recordModel];
    }
}


#pragma mark --UICollectionViewDelegate

-(void)selectRecordModel:(DNRecordModel*)recordModel
                  select:(BOOL)select
{
    if (self.isEdit ==YES) {
        
        NSString * resources;
        
        if ([self.type isEqualToString:@"record"]) {
            resources = [NSString stringWithFormat:@"%ld",(long)recordModel.accessid];
        }else
        {
           resources =  [NSString stringWithFormat:@"%ld",(long)recordModel.favoriteid];
        }
        

        if (select) {
          
              [self.videoIdArray addObject:resources];

        }else
        {
            
             [self.videoIdArray removeObject:resources];

        }
        
            self.collectionHeader.selectCount = [self.videoIdArray count];

    
    }
}
//重新加载请求
-(void)retryToGetData
{
    self.offset = 0;
    [self getDataWithType:1];

}

-(void)setType:(NSString *)type
{
    _type = type;
    
    [self retryToGetData];
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


-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        
        CGFloat cellWidth = KScreenWidth/2-15-3.5;
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        layout.itemSize = CGSizeMake(cellWidth, cellWidth*9/16);
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,self.width, self.height) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[DNRecordCollectionViewCell class] forCellWithReuseIdentifier:@"DNRecordCollectionViewCell"];
        [_collectionView registerClass:[DNRecordHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNRecordHeaderView"];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self retryToGetData];
        }];
        
    }
    return _collectionView;
}


-(void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    if (isEdit==YES) {
        self.collectionHeader.circleView.y = 29;
        self.collectionHeader.titleLabel.y = 22;
        self.collectionHeader.selectLabel.y = 24;
        self.collectionHeader.clearButton.hidden = YES;
        self.collectionHeader.selectLabel.hidden = NO;

    }else
    {
        self.collectionHeader.circleView.y = 29+43;
        self.collectionHeader.titleLabel.y = 22+43;
        self.collectionHeader.selectLabel.y = 24+43;
        self.collectionHeader.clearButton.hidden = NO;
        self.collectionHeader.selectLabel.hidden = YES;
    }

    [self.collectionView reloadData];
    
}

-(NSMutableArray*)videoIdArray
{
    if (!_videoIdArray) {
        _videoIdArray = [NSMutableArray array];
    }
    return _videoIdArray;
}

@end
