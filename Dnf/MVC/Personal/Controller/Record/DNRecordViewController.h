//
//  DNRecordViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import "DNRecordCollectionViewCell.h"
#import "DNRecordHeaderView.h"
#import "DNVideoModel.h"
@interface DNRecordViewController : DNBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)DNRecordHeaderView * collectionHeader;
@property (nonatomic,strong) UIButton * clearButton;

@property (nonatomic,strong) UIButton * deleteButton;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * videoIdArray;

@property(nonatomic,assign)int offset;

@property(nonatomic,assign)int total;

@property(nonatomic,assign)BOOL isEdit;

//刷新视图
-(void)retryToGetData;

@end
