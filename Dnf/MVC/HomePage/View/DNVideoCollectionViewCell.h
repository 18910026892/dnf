//
//  DNVideoCollectionViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVideoModel.h"
@interface DNVideoCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)DNVideoModel * videoModel;

@property(nonatomic,strong)UIImageView * coverImageView;

@property(nonatomic,strong)UILabel * vipLabel;


@end
