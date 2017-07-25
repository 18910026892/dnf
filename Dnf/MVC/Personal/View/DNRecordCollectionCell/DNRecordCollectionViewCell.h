//
//  DNRecordCollectionViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNRecordModel.h"
@interface DNRecordCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)DNRecordModel * recordModel;

@property(nonatomic,strong)UIImageView * coverImageView;

@property(nonatomic,strong)UILabel * vrLabel;

@property(nonatomic,strong)UILabel * vipLabel;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UIImageView * selectImageView;


@end
