//
//  DNPhotoViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNHallBaseViewController.h"
#import "DNPhotoCollectionViewCell.h"
#import "DNPhotoModel.h"
#import "DNPhotoCollectionReusableView.h"
@interface DNPhotoViewController : DNHallBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,DNPhotoCollectionReusableViewDelegate>


@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)DNPhotoCollectionReusableView * collecitonHeader;

@property(nonatomic,assign) int offset;

@property(nonatomic,assign)BOOL vip;


@end
