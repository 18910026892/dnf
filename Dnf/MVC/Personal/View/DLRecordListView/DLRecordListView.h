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
@interface DLRecordListView : UIView
<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,assign)BOOL isEdit;

@end
