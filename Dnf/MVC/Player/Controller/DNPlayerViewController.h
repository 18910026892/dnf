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
#import "DNTopUpViewController.h"
#import "DNRecordModel.h"
@interface DNPlayerViewController : DNWebViewController

@property(nonatomic,strong)DNRecordModel * recordModel;
@property(nonatomic,strong)KRVideoPlayerController  *videoController;
@property(nonatomic,strong)DNVideoInfoView * videoInfoView;

@end
