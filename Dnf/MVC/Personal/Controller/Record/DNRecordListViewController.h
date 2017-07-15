//
//  DNRecordListViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import "DNRecordCollectionViewCell.h"
#import "DNRecordHeaderView.h"
@interface DNRecordListViewController : DNBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@end
