//
//  KRVideoPlayerControlView.h
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRVideoPlayerControlView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UIButton *closeButton;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel * videoTitleLabel;
@property (nonatomic,strong)UIButton * vipButton;
@property (nonatomic,strong)UICollectionView * videoCollectionView;
@property (nonatomic,strong)NSMutableArray * videoArray;


@property(nonatomic,strong)UIView * guideView;
@property(nonatomic,strong)UIImageView * guideImageView1,*guideImageView2,*guideImageView3,*guideImageView4;
@property(nonatomic,strong)UILabel * guideLabel1,*guideLabel2,*guideLabel3,*guideLabel4;


@property (nonatomic,assign)BOOL fullScreen;
@property (nonatomic,assign)BOOL guide;


- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

@end
