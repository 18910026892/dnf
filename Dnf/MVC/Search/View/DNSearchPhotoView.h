//
//  DNSearchPhotoView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNPhotoCollectionViewCell.h"
#import "DNPhotoModel.h"
@protocol DNSearchPhotoViewDelegate <NSObject>

-(void)selectPhoto:(DNPhotoModel*)photoModel;

@end
@interface DNSearchPhotoView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, weak)id<DNSearchPhotoViewDelegate>delegate;

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@end
