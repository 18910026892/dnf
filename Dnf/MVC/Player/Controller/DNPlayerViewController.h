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
#import "DNRecordModel.h"
#import "DLShareView.h"
//展示类型 关注， 列表 , 集合视图 ,校园,小视频
typedef NS_ENUM(NSInteger, playerControllerEnterType)
{
    web=0,
    record,
};

@interface DNPlayerViewController : DNWebViewController

@property(nonatomic,strong)DNRecordModel * recordModel;
@property(nonatomic,assign)playerControllerEnterType enterType;


@property(nonatomic,strong)KRVideoPlayerController  *videoController;
@property(nonatomic,strong)DNVideoInfoView * videoInfoView;
@property(nonatomic,strong)DNVideoVipView  * vipView;



@end
