//
//  DNMessageTableViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNMessageModel.h"

//气泡相对于cell 的间距
#define BACKGROUND_WITH_CELL_SPAC 10.0

//内容相对气泡的间距
#define CONTENT_HORIZONTAL_SPAC 18.7
#define CONTENT_VERTICAL_SPAC 9
@interface DNMessageTableViewCell : UITableViewCell

@property(nonatomic, strong)UIImageView *icon;
@property(nonatomic, strong)UIView *messageView;
@property(nonatomic, strong)DNMessageModel *messageModel;

@end
