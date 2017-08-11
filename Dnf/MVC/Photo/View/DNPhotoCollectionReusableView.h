//
//  DNPhotoCollectionReusableView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNTopPhotoCollectionViewCell.h"
#import "DNPhotoModel.h"
#import "DNVipSegmentView.h"


@protocol DNPhotoCollectionReusableViewDelegate <NSObject>

-(void)didSelectPhoto:(DNPhotoModel*)photoModel;

@end


@interface DNPhotoCollectionReusableView : UICollectionReusableView<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic, weak)id<DNPhotoCollectionReusableViewDelegate> photoDelegate;

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)DNVipSegmentView * segMentView;

@property(nonatomic,strong)NSMutableArray * recommedArray;

@end
