//
//  DNSearchViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNHallBaseViewController.h"
#import "DLTopBarView.h"
#import "DLPageView.h"
#import "DNSearchPhotoView.h"
#import "DNSearchVideoView.h"
#import "DLTopBarConfig.h"

#import "DNVideoModel.h"
#import "DNPhotoModel.h"
@interface DNSearchViewController : DNHallBaseViewController<UITextFieldDelegate,DLTopBarViewDelegate,DLPageViewDelegate,DNSearchPhotoViewDelegate,DNSearchVideoViewDelegate>

@property(nonatomic,strong)NSMutableArray * viewArray;

@property (nonatomic,strong) DLTopBarView *topbar; // 标题

@property (nonatomic,strong) DLPageView *pageView; // 切换用

@property(nonatomic,strong)DNSearchPhotoView * searchPhotoView;

@property(nonatomic,strong)DNSearchVideoView * searchVideoView;

@property(nonatomic,strong)UIImageView * searchImageView;

@property(nonatomic,strong)UIButton * cancleButton;

@property(nonatomic,strong)UITextField * searchTextField;

@end
