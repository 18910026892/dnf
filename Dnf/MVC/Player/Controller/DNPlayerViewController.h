//
//  DNPlayerViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import <KRVideoPlayerController.h>
#import "DNVideoInfoView.h"
#import "DNVideoVipView.h"
#import "DNTopUpViewController.h"
#import "DLShareView.h"
#import "DNVideoModel.h"
#import "DLVideoRecommendTableViewCell.h"
typedef NS_ENUM(NSInteger, playerControllerEnterType)
{
    web=0,
    record,
};

@interface DNPlayerViewController : DNBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)DNVideoModel * videoModel;
@property(nonatomic,assign)playerControllerEnterType enterType;


@property(nonatomic,strong)KRVideoPlayerController  *videoController;
@property(nonatomic,strong)DNVideoInfoView * videoInfoView;
@property(nonatomic,strong)DNVideoVipView  * vipView;
@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UIView  * tableHeader;
@property(nonatomic,strong)UIView  * circleView;
@property(nonatomic,strong)UILabel * headerTitle;

@property(nonatomic,strong)NSMutableArray * recomendArray;

@end
