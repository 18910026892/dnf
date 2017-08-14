//
//  DNHomePageCollectionReusableView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPageFlowView.h"
#import "DNVideoModel.h"
#import "DNVideoCollectionViewCell.h"


@protocol DNHomePageCollectionReusableViewDelegate <NSObject>

-(void)selectVideo:(DNVideoModel*)videoModel;

@end


@interface DNHomePageCollectionReusableView : UICollectionReusableView<SBPageFlowViewDelegate,SBPageFlowViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, weak)id<DNHomePageCollectionReusableViewDelegate> videoDelegate;

@property(nonatomic,strong)SBPageFlowView * flowView;


@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIView * upCircleView;
@property(nonatomic,strong)UIView * downCircleView;
@property(nonatomic,strong)UILabel * videoTitle;
@property(nonatomic,strong)UILabel * photoTitle;
@property(nonatomic,strong)UIButton * upMoreButton;
@property(nonatomic,strong)UIButton * downMoreButton;
@property(nonatomic,strong)UILabel * vipLabel;




@property(nonatomic,strong)NSMutableArray * bannerArray;
@property(nonatomic,strong)NSMutableArray * bannerImageArray;
@property(nonatomic,strong)NSMutableArray * dataArray;

@end
