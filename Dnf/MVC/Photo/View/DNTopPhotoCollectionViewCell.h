//
//  DNTopPhotoCollectionViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNPhotoModel.h"
@interface DNTopPhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)DNPhotoModel * photoModel;

@property(nonatomic,strong)UIImageView * coverImageView;

@property(nonatomic,strong)UILabel * vipLabel;

@end