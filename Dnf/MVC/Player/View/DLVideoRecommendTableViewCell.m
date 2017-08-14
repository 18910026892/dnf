//
//  DLVideoRecommendTableViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DLVideoRecommendTableViewCell.h"
#import "NSString+Date.h"
@implementation DLVideoRecommendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.watchLabel];
        
        [self.contentView addSubview:self.collectionButton];
        [self.contentView addSubview:self.shareButton];
        
    }
    return self;
}

-(void)setVideoModel:(DNVideoModel *)videoModel
{
    _videoModel = videoModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.cover]];
    
    self.vrLabel.hidden = ([videoModel.resource isEqualToString:@"vr"])?NO:YES;
    
    self.vipLabel.hidden = ([videoModel.vip isEqualToString:@"Y"])?NO:YES;
    
    self.watchLabel.text = [NSString stringWithFormat:@"%ld次播放",videoModel.watches];
    
    self.timeLabel.text  = [NSString formatTime:videoModel.duration];
    
    self.titleLabel.text = videoModel.title;
    

    
    if (videoModel.favoriteid==0) {
        [self.collectionButton setImage:[UIImage imageNamed:@"video_collection_small_normal"] forState:UIControlStateNormal];
        [self.collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectionButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
     
    }else
        
    {
        [self.collectionButton setImage:[UIImage imageNamed:@"video_collectioned_hover"] forState:UIControlStateNormal];
        
        [self.collectionButton setTitle:@"已收" forState:UIControlStateNormal];
        [self.collectionButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    }

    
}

-(void)collectionButtonClick:(UIButton*)sender
{
    if (self.cellDelegate) {
        [self.cellDelegate colleciton:self.videoModel];
    }
}
-(void)shareButtonClick:(UIButton*)sender
{
    if (self.cellDelegate) {
        [self.cellDelegate share:self.videoModel];
    }
}

-(UIImageView*)coverImageView
{
    if(!_coverImageView)
    {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9.5,138,78)];
        
        _coverImageView.layer.borderWidth = 0.5;
        _coverImageView.layer.borderColor = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.12].CGColor;
        _coverImageView.layer.cornerRadius = 3;
        _coverImageView.layer.masksToBounds = YES;
        
        CAGradientLayer *gradiedtLayer = [[CAGradientLayer alloc] init];
        gradiedtLayer.frame = CGRectMake(0, 130,KScreenWidth-30,50);
        gradiedtLayer.colors = [NSArray arrayWithObjects:(id)[[[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0] CGColor],
                                (id)[[[UIColor customColorWithString:@"000000"]colorWithAlphaComponent:0.5] CGColor],
                                nil];
        gradiedtLayer.locations =
        [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
         [NSNumber numberWithFloat:1.0],
         nil];
        gradiedtLayer.startPoint = CGPointMake(0,0);
        gradiedtLayer.endPoint = CGPointMake(0,1);
        [_coverImageView.layer addSublayer:gradiedtLayer];
        [_coverImageView addSubview:self.vrLabel];
        [_coverImageView addSubview:self.vipLabel];
        [_coverImageView addSubview:self.timeLabel];
    }
    return _coverImageView;
    
}


-(UILabel*)vrLabel
{
    if (!_vrLabel) {
        _vrLabel = [[UILabel alloc]init];
        _vrLabel.frame = CGRectMake(0, 0, 45, 14);
        _vrLabel.text = @"VR视频";
        _vrLabel.hidden = YES;
        _vrLabel.textAlignment = NSTextAlignmentCenter;
        _vrLabel.textColor = [UIColor whiteColor];
        _vrLabel.font = [UIFont fontWithName:TextFontName_Light size:11];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_vrLabel.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _vrLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _vrLabel.layer.mask = maskLayer;
        _vrLabel.backgroundColor = [[UIColor customColorWithString:@"7D49F1"] colorWithAlphaComponent:0.8];
        
        
    }
    return _vrLabel;
}

-(UILabel*)vipLabel
{
    if (!_vipLabel) {
        _vipLabel = [[UILabel alloc]init];
        _vipLabel.frame = CGRectMake(CGRectGetWidth(self.coverImageView.bounds)-26, 0, 26, 14);
        _vipLabel.text = @"VIP";
        _vipLabel.hidden = YES;
        _vipLabel.textColor = [UIColor whiteColor];
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.font = [UIFont fontWithName:TextFontName_Light size:11];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_vipLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _vipLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _vipLabel.layer.mask = maskLayer;
        _vipLabel.backgroundColor = [[UIColor customColorWithString:@"e92b2b"] colorWithAlphaComponent:0.8];
    }
    return _vipLabel;
}


-(UILabel*)watchLabel
{
    if (!_watchLabel) {
        _watchLabel = [[UILabel alloc]initWithFrame:CGRectMake(163,30, KScreenWidth-178, 20)];
        _watchLabel.textColor = [UIColor customColorWithString:@"999999"];
        _watchLabel.font = [UIFont fontWithName:TextFontName_Light size:13];
        _watchLabel.textAlignment = NSTextAlignmentLeft;
        _watchLabel.text = @"0次观看";
        
    }
    return _watchLabel;
}

-(UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake(CGRectGetWidth(self.coverImageView.bounds)-40, CGRectGetHeight(self.coverImageView.bounds)-18, 40, 18);
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont fontWithName:TextFontName_Light size:11];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_timeLabel.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _timeLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _timeLabel.layer.mask = maskLayer;
        _timeLabel.backgroundColor = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.3];
    }
    return _timeLabel;
}

-(UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(163,11, KScreenWidth-178,18)];
        _titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"标题最多展示十个汉字";
    }
    return _titleLabel;
}

-(UIButton*)collectionButton
{
    if (!_collectionButton) {
        _collectionButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionButton.frame = CGRectMake(164,57,72, 26);
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:10];
        _collectionButton.layer.cornerRadius = 13;
        _collectionButton.layer.borderWidth = 0.5;
        _collectionButton.layer.borderColor = [UIColor customColorWithString:@"eeeeee"].CGColor;
        
        _collectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_collectionButton setImage:[UIImage imageNamed:@"video_collection_small_normal"] forState:UIControlStateNormal];
        [_collectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [_collectionButton setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 2)];
   
        
        [_collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    }
    return _collectionButton;
}

-(UIButton*)shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(254,57,72, 26);
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"video_share_small_normal"] forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:10];
        _shareButton.layer.cornerRadius = 13;
        _shareButton.layer.borderWidth = 0.5;
        _shareButton.layer.borderColor = [UIColor customColorWithString:@"eeeeee"].CGColor;
        
        [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 2)];
        _shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shareButton;
}



@end
