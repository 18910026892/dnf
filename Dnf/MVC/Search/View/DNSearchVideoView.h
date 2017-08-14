//
//  DNSearchVideoView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVideoModel.h"
#import "DLVideoRecommendTableViewCell.h"

@protocol DNSearchVideoViewDelegate <NSObject>

-(void)selectVideo:(DNVideoModel*)videoModel;

-(void)colleciton:(DNVideoModel*)videoModel;

@end


@interface DNSearchVideoView : UIView<UITableViewDelegate,UITableViewDataSource,DLVideoRecommendTableViewCellDelegate>


@property(nonatomic, weak)id<DNSearchVideoViewDelegate>delegate;
//应用展示列表
@property(nonatomic,strong)UITableView * tableView;

//vr数据源
@property(nonatomic,strong)NSMutableArray * dataArray;

@end
