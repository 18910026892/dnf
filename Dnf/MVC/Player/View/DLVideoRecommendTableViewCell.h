//
//  DLVideoRecommendTableViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVideoModel.h"

@protocol DLVideoRecommendTableViewCellDelegate <NSObject>

-(void)colleciton:(DNVideoModel*)videoModel;

-(void)share:(DNVideoModel*)videoModel;

@end
@interface DLVideoRecommendTableViewCell : UITableViewCell

@property(nonatomic, weak)id<DLVideoRecommendTableViewCellDelegate> cellDelegate;

@property(nonatomic,strong)DNVideoModel * videoModel;

@property(nonatomic,strong)UIImageView * coverImageView;

@property(nonatomic,strong)UILabel * vrLabel;

@property(nonatomic,strong)UILabel * vipLabel;

@property(nonatomic,strong)UILabel * watchLabel;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIButton * collectionButton;

@property(nonatomic,strong)UIButton * shareButton;

@end
