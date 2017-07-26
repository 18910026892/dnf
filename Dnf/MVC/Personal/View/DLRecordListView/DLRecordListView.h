//
//  DLRecordListView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/20.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNRecordCollectionViewCell.h"
#import "DNRecordHeaderView.h"
#import "DLNoDataView.h"
@protocol DNRecordListViewCellDelegate <NSObject>
@optional

-(void)selectRecordModel:(DNRecordModel*)recordModel;

-(void)clear;

@end


@interface DLRecordListView : UIView
<UICollectionViewDelegate,UICollectionViewDataSource,DNRecordCollectionViewCellDelegate,NoDataViewDelegate>
{
    DLNoDataView * _noDataView;
}

@property(nonatomic,weak)id<DNRecordListViewCellDelegate>delegate;

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * videoIdArray;

@property(nonatomic,assign)int offset;

@property(nonatomic,assign)int total;

@property(nonatomic,strong)DNRecordHeaderView * collectionHeader;

@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,copy)NSString * type;

//刷新视图
-(void)retryToGetData;

@end
