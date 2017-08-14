//
//  KRVideoPlayerControlView.m
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import "KRVideoPlayerControlView.h"
#import "UIImageView+WebCache.h"
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define kThemeColor  HexRGBAlpha(0xFF6BB7, 1)

static const CGFloat kVideoControlBarHeight = 46.0;
static const CGFloat kVideoControlAnimationTimeinterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeinterval = 10.0;

@interface KRVideoPlayerControlView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;
//@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;



@end

@implementation KRVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    
        _fullScreen = NO;
        _guide = NO;
        
        [self addSubview:self.topBar];
        [self addSubview:self.closeButton];
        [self addSubview:self.bottomBar];
        [self.bottomBar addSubview:self.playButton];
        [self.bottomBar addSubview:self.pauseButton];
        self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        self.shrinkScreenButton.hidden = YES;
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.timeLabel];
        [self addSubview:self.indicatorView];

        
        
        [self addSubview:self.videoTitleLabel];
        [self addSubview:self.vipButton];
        [self addSubview:self.videoCollectionView];
      
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        
        UISwipeGestureRecognizer * swipeUp =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        
 
        //设置轻扫的方向
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        
        UISwipeGestureRecognizer * swipeDown =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        //设置轻扫的方向
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeUp];
        [self addGestureRecognizer:swipeDown];

  
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.videoTitleLabel.frame = CGRectMake(86, 35, CGRectGetWidth(self.bounds)-176, 24);
    self.vipButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-15-71, 36, 71, 22);
    self.closeButton.frame = CGRectMake(12, 24,  kVideoControlBarHeight,  kVideoControlBarHeight);
    
    CGFloat videoCollectionViewY= (self.fullScreen==NO)?CGRectGetHeight(self.bounds):
    CGRectGetHeight(self.bounds) - 25;
    self.videoCollectionView.frame = CGRectMake(0,videoCollectionViewY, CGRectGetWidth(self.bounds),115);

    
    CGFloat bottomBary= (self.fullScreen==NO)?CGRectGetHeight(self.bounds) - kVideoControlBarHeight:
    CGRectGetHeight(self.bounds) - kVideoControlBarHeight/2-50;
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), bottomBary, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    
    
    
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.playButton.frame = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    self.pauseButton.frame = self.playButton.frame;
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 87, CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, 41, CGRectGetHeight(self.fullScreenButton.bounds));
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.progressSlider.bounds)/2, CGRectGetMinX(self.timeLabel.frame) - CGRectGetMaxX(self.playButton.frame)-7, CGRectGetHeight(self.progressSlider.bounds));
    

    
   BOOL guide = [[NSUserDefaults standardUserDefaults] valueForKey:@"DNPlayerControllerGuide"];
    if (guide==NO) {
    
        self.guideView.frame = self.bounds;
        self.guideImageView1.frame =  CGRectMake(CGRectGetMidX(self.bounds)-40, CGRectGetMidY(self.bounds)-40, 80, 80);
        self.guideLabel1.frame =  CGRectMake(CGRectGetMidX(self.bounds)-65, CGRectGetMidY(self.bounds)+50,130, 21);
        
        self.guideImageView2.frame =  CGRectMake(CGRectGetMidX(self.bounds)+50, CGRectGetMidY(self.bounds)-40, 80, 80);
        self.guideLabel2.frame =  CGRectMake(CGRectGetMidX(self.bounds)+10, CGRectGetMidY(self.bounds)+50,160, 21);
    
        self.guideImageView3.frame = CGRectMake(CGRectGetMaxX(self.bounds)-11-24, CGRectGetMaxY(self.bounds)-62,24, 24);
    
        self.guideLabel3.frame =  CGRectMake(CGRectGetMaxX(self.bounds)-71, CGRectGetMaxY(self.bounds)-99,62, 21);
    
        self.guideImageView4.frame =  CGRectMake(CGRectGetMaxX(self.bounds)-186-130, CGRectGetMaxY(self.bounds)-84, 186, 50);
    
        self.guideLabel4.frame =  CGRectMake(CGRectGetMaxX(self.bounds)-147-148, CGRectGetMaxY(self.bounds)-18-56, 147, 18);
    
    }
    

    
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.closeButton.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
        self.videoTitleLabel.alpha = 0.0;
        self.vipButton.alpha = 0.0;
        self.videoCollectionView.alpha = 0.0;

        
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.bottomBar.alpha = 1.0;
        self.closeButton.alpha = 1.0;
        self.videoTitleLabel.alpha = 1.0;
        self.vipButton.alpha = 1.0;
        self.videoCollectionView.alpha = 1.0;
      
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    
    [self videoRecommendHide];

    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}
-(void)guideOnTap:(UITapGestureRecognizer *)gesture
{
    
    if (_guide==NO) {
        
        self.guideImageView1.frame =  CGRectMake(CGRectGetMidX(self.bounds)-130, CGRectGetMidY(self.bounds)-40, 80, 80);
        self.guideLabel1.frame =  CGRectMake(CGRectGetMidX(self.bounds)-155, CGRectGetMidY(self.bounds)+50,130, 21);
        self.guideLabel1.text = @"单击屏幕关闭菜单";
        self.guideLabel1.textAlignment = NSTextAlignmentLeft;
        self.guideImageView2.hidden = NO;
        self.guideLabel2.hidden = NO;
        self.guideImageView3.hidden = NO;
        self.guideLabel3.hidden = NO;
        self.guideImageView4.hidden = NO;
        self.guideLabel4.hidden = NO;
        
        _guide = YES;
        
    }else
    {
        
        [self.guideView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DNPlayerControllerGuide"];
    }

}

-(void)swipeGesture:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self videoRecommendShow];
    }
    
    else  if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
   
        [self videoRecommendHide];
     
    }
    
}
-(void)videoRecommendShow
{
    
    if ([self.videoArray count]==0) {
        return;
    }
    
    if (self.videoCollectionView.frame.origin.y==CGRectGetHeight(self.bounds)-25) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.videoCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-115, CGRectGetWidth(self.bounds), 115);
    
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
 
}

-(void)videoRecommendHide
{
    if (self.videoCollectionView.frame.origin.y==CGRectGetHeight(self.bounds)-115) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.videoCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-25, CGRectGetWidth(self.bounds),115);
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
    

}

#pragma mark - Property
-(UIView*)guideView
{
    if (!_guideView) {
        _guideView = [[UIView alloc]init];
        _guideView.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideOnTap:)];
        [_guideView addGestureRecognizer:tapGesture];
        [_guideView addSubview:self.guideImageView1];
        [_guideView addSubview:self.guideLabel1];
        [_guideView addSubview:self.guideImageView2];
        [_guideView addSubview:self.guideLabel2];
        [_guideView addSubview:self.guideImageView3];
        [_guideView addSubview:self.guideLabel3];
        [_guideView addSubview:self.guideImageView4];
        [_guideView addSubview:self.guideLabel4];
        
    }
    return _guideView;
}

-(UIImageView*)guideImageView1
{
    if (!_guideImageView1) {
        _guideImageView1 = [[UIImageView alloc]init];
        _guideImageView1.image = [UIImage imageNamed:@"guide_click_on"];
  
    }
    return _guideImageView1;
}

-(UIImageView*)guideImageView2
{
    if (!_guideImageView2) {
        _guideImageView2 = [[UIImageView alloc]init];
        _guideImageView2.image = [UIImage imageNamed:@"guide_upwards"];
        _guideImageView2.hidden = YES;
    }
    return _guideImageView2;
}

-(UIImageView*)guideImageView3
{
    if (!_guideImageView3) {
        _guideImageView3 = [[UIImageView alloc]init];
        _guideImageView3.image = [UIImage imageNamed:@"video_shrinkscreen"];
        _guideImageView3.hidden = YES;
    }
    return _guideImageView3;
}

-(UIImageView*)guideImageView4
{
    if (!_guideImageView4) {
        _guideImageView4 = [[UIImageView alloc]init];
        _guideImageView4.image = [UIImage imageNamed:@"guide_bubble_normal"];
        _guideImageView4.hidden = YES;
    }
    return _guideImageView4;
}


-(UILabel*)guideLabel1
{
    if (!_guideLabel1) {
        _guideLabel1 = [[UILabel alloc]init];
        _guideLabel1.text = @"单机屏幕呼出菜单";
        _guideLabel1.font = [UIFont systemFontOfSize:15];
        _guideLabel1.textAlignment = NSTextAlignmentCenter;
        _guideLabel1.textColor = [UIColor whiteColor];
    
    }
    return _guideLabel1;
}

-(UILabel*)guideLabel2
{
    if (!_guideLabel2) {
        _guideLabel2 = [[UILabel alloc]init];
        _guideLabel2.text = @"向上拖动显示推荐视频";
        _guideLabel2.font = [UIFont systemFontOfSize:15];
        _guideLabel2.textAlignment = NSTextAlignmentCenter;
        _guideLabel2.textColor = [UIColor whiteColor];
        _guideLabel2.hidden = YES;
    }
    return _guideLabel2;
}


-(UILabel*)guideLabel3
{
    if (!_guideLabel3) {
        _guideLabel3 = [[UILabel alloc]init];
        _guideLabel3.text = @"退出全屏";
        _guideLabel3.font = [UIFont systemFontOfSize:15];
        _guideLabel3.textAlignment = NSTextAlignmentCenter;
        _guideLabel3.textColor = [UIColor whiteColor];
        _guideLabel3.hidden = YES;
    
    }
    return _guideLabel3;
}

-(UILabel*)guideLabel4
{
    if (!_guideLabel4) {
        _guideLabel4 = [[UILabel alloc]init];
        _guideLabel4.text = @"下面隐藏部分是推荐视频";
        _guideLabel4.font = [UIFont systemFontOfSize:13];
        _guideLabel4.textAlignment = NSTextAlignmentCenter;
        _guideLabel4.textColor = [UIColor blackColor];
        _guideLabel4.hidden = YES;
        
    }
    return _guideLabel4;
}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor clearColor];
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"video_player_normal"] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"video_timeout_normal"] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0,kVideoControlBarHeight,kVideoControlBarHeight);
        
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"video_fullscreen"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
        _fullScreenButton.backgroundColor = [UIColor clearColor];
    
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"video_shrinkscreen"] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _shrinkScreenButton;
}
- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
       [_progressSlider setThumbImage:[UIImage imageNamed:@"video_slider_oval"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:kThemeColor];
        [_progressSlider setMaximumTrackTintColor:HexRGBAlpha(0xffffff, 0.37)];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
        _progressSlider.backgroundColor = [UIColor clearColor];
    }
    return _progressSlider;
}


- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"video_back_normal"] forState:UIControlStateNormal];
        _closeButton.backgroundColor = [UIColor clearColor];
     
    }
    return _closeButton;
}

-(UILabel*)videoTitleLabel
{
    if (!_videoTitleLabel) {
        _videoTitleLabel = [[UILabel alloc]init];
        _videoTitleLabel.frame = CGRectZero;
        _videoTitleLabel.font = [UIFont systemFontOfSize:17];
        _videoTitleLabel.textColor = [UIColor whiteColor];
        _videoTitleLabel.textAlignment = NSTextAlignmentCenter;
        _videoTitleLabel.hidden = YES;
    }
    return _videoTitleLabel;
}

-(UIButton*)vipButton
{
    if (!_vipButton) {
        _vipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipButton.backgroundColor = HexRGBAlpha(0xf750a5,1);
        [_vipButton setTitle:@"VIP购买" forState:UIControlStateNormal];
        [_vipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _vipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _vipButton.layer.cornerRadius = 11;
    
        _vipButton.hidden = YES;
    }
    return _vipButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
        _timeLabel.backgroundColor = [UIColor clearColor];
    }
    return _timeLabel;
}


- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

-(void)setVideoArray:(NSMutableArray *)videoArray
{
    _videoArray = videoArray;
    [self.videoCollectionView reloadData];
}


-(UICollectionView*)videoCollectionView
{
    if (!_videoCollectionView) {
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(169,95);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _videoCollectionView =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _videoCollectionView.showsHorizontalScrollIndicator = NO;
        _videoCollectionView.dataSource = self;
        _videoCollectionView.delegate = self;
        _videoCollectionView.scrollEnabled = YES;
        _videoCollectionView.backgroundColor = [UIColor clearColor];
        _videoCollectionView.allowsMultipleSelection = NO;
        _videoCollectionView.hidden = YES;
        [_videoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
    }
    return _videoCollectionView;
}


# pragma CollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.videoArray count];
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(169,95);
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15,6.7,15,6.7);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    UICollectionViewCell * cell;
    
    if(!cell)
    {
        cell= (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        
    }

    UIImageView * cover = [[UIImageView alloc]init];
    cover.frame = CGRectMake(0, 0, 169, 95);
    [cell.contentView addSubview:cover];
    
    
    UILabel * vipLabel= [[UILabel alloc]initWithFrame:CGRectMake(169-26, 0, 26, 14)];
    vipLabel.text = @"VIP";
    vipLabel.textAlignment = NSTextAlignmentCenter;
    vipLabel.backgroundColor = HexRGBAlpha(0xe92b2b, .8);
    vipLabel.textColor = [UIColor whiteColor];
    vipLabel.font = [UIFont systemFontOfSize:11];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:vipLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = vipLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    vipLabel.layer.mask = maskLayer;
    vipLabel.hidden = YES;
    [cell.contentView addSubview:vipLabel];
    
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 169, 95)];
    maskView.backgroundColor = HexRGBAlpha(0x000000, .2);
    maskView.tag = 2000+indexPath.row;
    [cell.contentView addSubview:maskView];
    
    NSDictionary * dict = self.videoArray[indexPath.row];
    NSString * imageUrl = [dict valueForKey:@"cover"];
    [cover sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    NSString * vip = [dict valueForKey:@"vip"];
    vipLabel.hidden = ([vip isEqualToString:@"Y"])?NO:YES;

    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;

    
    return cell;
    
}

#pragma mark --UICollectionViewDelegate

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据idenxPath获取对应的cell
    UICollectionViewCell *cell =  [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = kThemeColor.CGColor;
    cell.layer.masksToBounds = YES;
    
    UIView * maskView  = (UIView*)[cell viewWithTag:2000+indexPath.row];
    maskView.hidden = YES;
  
    NSDictionary * dict = self.videoArray[indexPath.row];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DLChangeVideo" object:dict];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell =  [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0;
    
    UIView * maskView  = (UIView*)[cell viewWithTag:2000+indexPath.row];
    maskView.hidden = NO;
    
}


#pragma mark - Private Method

- (NSString *)videoImageName:(NSString *)name
{
    if (name) {
        NSString *path = [NSString stringWithFormat:@"KRVideoPlayer.bundle/%@",name];
        return path;
    }
    return nil;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch

{
    
    
    if (CGRectContainsPoint(self.videoCollectionView.frame, [touch locationInView:self])) {
        
        [self endEditing:YES];
        
        return NO;
    }
    
    return YES;
    
}


@end
