//
//  DNRecordCollectionViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNRecordCollectionViewCell.h"

@implementation DNRecordCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self addSubview:self.coverImageView];
        [self addSubview:self.vrLabel];
        [self addSubview:self.vipLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.selectImageView];
        
    }
    return self;
    
}

-(void)setRecordModel:(DNRecordModel *)recordModel
{
    _recordModel = recordModel;
    

    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:recordModel.cover]];
    
    
    if (recordModel.duration==0||!recordModel.duration) {
        self.timeLabel.hidden = YES;
        
    }else
    {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [self formatTime:recordModel.duration];
    }
    
    
    self.vipLabel.hidden = ([recordModel.vip isEqualToString:@"Y"])?NO:YES;
    
    self.vrLabel.hidden = ([recordModel.resource isEqualToString:@"vr"])?NO:YES;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        //选中时
      self.selectImageView.image = [UIImage imageNamed:@"checkbox_hover"];
        
    }else{
        //非选中
      self.selectImageView.image = [UIImage imageNamed:@"checkbox_normal"];
    }
    
    if (self.delegate) {
        [self.delegate selectRecordModel:self.recordModel select:selected];
    }
    
    // Configure the view for the selected state
}
//format audio time
- (NSString *)formatTime:(int)num{
    
    int second = (int)num%60;//秒
    int minute = (int)num/60%60;
    int house = (int)num/3600;
    if (num < 3600) {
        return [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",house,minute,second];
}


-(UIImageView*)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.frame = CGRectMake(0, 0, self.width, self.height);
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
        _vipLabel.frame = CGRectMake(self.width-26, 0, 26, 14);
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

-(UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake(self.width-40, self.height-18, 40, 18);
        _timeLabel.hidden = YES;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
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


-(UIImageView*)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-38, self.height-38, 32, 32)];
        _selectImageView.image = [UIImage imageNamed:@"checkbox_normal"];
    }
    return _selectImageView;
}

@end
