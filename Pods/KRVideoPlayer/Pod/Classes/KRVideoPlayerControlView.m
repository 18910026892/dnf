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

static const CGFloat kVideoControlBarHeight = 60.0;
static const CGFloat kVideoTimeLabelWidth = 100.0;
static const CGFloat kVideoControlAnimationTimeinterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeinterval = 5.0;

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
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, assign) BOOL isCollecionViewShow;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;



@end

@implementation KRVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.videoTitleLabel];
        [self addSubview:self.vipButton];
        [self addSubview:self.closeButton];
        [self addSubview:self.bottomBar];
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        self.shrinkScreenButton.hidden = YES;
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.timeLabel];
        [self.bottomBar addSubview:self.totalLabel];
        [self addSubview:self.indicatorView];
      
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

    self.videoTitleLabel.frame = CGRectMake(55, 35, CGRectGetWidth(self.bounds)-175, 24);
    self.vipButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-15-71, 36, 71, 22);
    
    self.closeButton.frame = CGRectMake(15, 27, CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.playButton.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.pauseButton.frame = self.playButton.frame;
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    self.progressSlider.frame = CGRectMake(CGRectGetMinX(self.bottomBar.frame), CGRectGetHeight(self.bottomBar.bounds) - CGRectGetHeight(self.progressSlider.bounds)/2, CGRectGetWidth(self.bottomBar.frame), CGRectGetHeight(self.progressSlider.bounds));
    
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.bottomBar.frame)+15,0,kVideoTimeLabelWidth, CGRectGetHeight(self.bottomBar.frame));
    self.totalLabel.frame = CGRectMake(CGRectGetMaxX(self.bottomBar.frame)-47-100,0,kVideoTimeLabelWidth, CGRectGetHeight(self.bottomBar.frame));
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    
    self.videoCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds),115);

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
        self.playButton.alpha = 0.0;
        self.pauseButton.alpha = 0.0;
        self.videoTitleLabel.alpha = 0.0;
        self.vipButton.alpha = 0.0;
        
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
        self.playButton.alpha = 1.0;
        self.pauseButton.alpha = 1.0;
        self.closeButton.alpha = 1.0;
        self.videoTitleLabel.alpha = 1.0;
        self.vipButton.alpha = 1.0;
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

    
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

-(void)swipeGesture:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.videoCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-115, CGRectGetWidth(self.bounds), 115);
            
            _isCollecionViewShow = YES;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    else  if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.videoCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds),115);
            _isCollecionViewShow = NO;
            
        } completion:^(BOOL finished) {
            
        }];
     
    }
    
}

#pragma mark - Property

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
        [_playButton setImage:[UIImage imageNamed:@"video_player_big_normal"] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, 60, 60);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"video_timeout_big_normal"] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, 60, 60);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"video_fullscreen"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
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
        [_progressSlider setThumbTintColor:[UIColor clearColor]];
        [_progressSlider setMinimumTrackTintColor:kThemeColor];
        [_progressSlider setMaximumTrackTintColor:HexRGBAlpha(0xffffff, 0.37)];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"video_back_normal"] forState:UIControlStateNormal];
        _closeButton.bounds = CGRectMake(0, 0, 40, 40);
     
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
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _timeLabel;
}

-(UILabel*)totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.backgroundColor = [UIColor clearColor];
        _totalLabel.font = [UIFont systemFontOfSize:14];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _totalLabel;
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
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:vipLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = vipLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    vipLabel.layer.mask = maskLayer;
    vipLabel.hidden = YES;
    [cell.contentView addSubview:vipLabel];
    
    
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
  
    NSDictionary * dict = self.videoArray[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DLChangeVideo" object:dict];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell =  [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0;
    
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


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
 
    return !_isCollecionViewShow;
}



@end
