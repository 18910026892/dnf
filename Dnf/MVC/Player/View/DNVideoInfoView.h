//
//  DNVideoInfoView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DNVideoInfoView : UIView

//视频标题
@property(nonatomic,copy)NSString * videoTitle;

//播放次数
@property(nonatomic,copy)NSString * watchCount;

//是否收藏
@property(nonatomic,assign)BOOL collection;


//视频播放标题
@property(nonatomic,strong)UILabel * videoTitleLabel;

//视频播放次数
@property(nonatomic,strong)UILabel * watchCountLabel;

//收藏按钮
@property(nonatomic,strong)UIButton * collectionButton;

//分享按钮
@property(nonatomic,strong)UIButton * shareButton;

//vip
@property(nonatomic,strong)UILabel * vipInfoLabel;

//开通
@property(nonatomic,strong)UIButton * openButton;

//线条
@property(nonatomic,strong)UIView* lineA,*lineB;



@end
