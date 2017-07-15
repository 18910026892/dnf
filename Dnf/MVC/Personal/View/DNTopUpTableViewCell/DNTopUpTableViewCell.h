//
//  DNTopUpTableViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNTopUpModel.h"
@protocol DNTopUpTableViewCellDelegate <NSObject>

-(void)didSelectPriceButton:(DNTopUpModel*)topUpModel;

@end

@interface DNTopUpTableViewCell : UITableViewCell

@property(nonatomic, weak)id<DNTopUpTableViewCellDelegate> delegate;

@property(nonatomic,strong)DNTopUpModel * topUpModel;

@property(nonatomic,strong)UILabel * vipTitleLabel;
@property(nonatomic,strong)UILabel * vipDescLabel;

@property(nonatomic,strong)UIButton * priceButton;

@end
