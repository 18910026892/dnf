//
//  DLVideoRecommendTableViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVideoModel.h"
@interface DLVideoRecommendTableViewCell : UITableViewCell


@property(nonatomic,strong)DNVideoModel * videoModel;

@property(nonatomic,strong)UIImageView * coverImageView;

@property(nonatomic,strong)UILabel * vrLabel;

@property(nonatomic,strong)UILabel * vipLabel;

@property(nonatomic,strong)UILabel * watchLabel;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UILabel * titleLabel;


@end
