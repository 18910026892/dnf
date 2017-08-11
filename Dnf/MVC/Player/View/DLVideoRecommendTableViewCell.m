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
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_vrLabel.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
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
        _vipLabel.text = @"vip";
        _vipLabel.hidden = YES;
        _vipLabel.textColor = [UIColor whiteColor];
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.font = [UIFont fontWithName:TextFontName_Light size:11];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_vipLabel.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
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
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_timeLabel.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
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


@end
