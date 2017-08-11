//
//  DNPhotoCollectionViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPhotoCollectionViewCell.h"

@implementation DNPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.12].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];

    }
    return self;
}

-(void)setPhotoModel:(DNPhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    NSString * imageUrl = [photoModel.play valueForKey:@"url"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    self.countLabel.text = [NSString stringWithFormat:@"共%ld张",photoModel.photonumber];
    
    
    self.vipLabel.hidden = ([photoModel.vip isEqualToString:@"Y"])?NO:YES;
    
    self.titleLabel.text = photoModel.title;

}

-(UIImageView*)coverImageView
{
    if(!_coverImageView)
    {
        
        CGFloat itemWidth = (KScreenWidth-45)/3;
        CGFloat itemHeight = itemWidth/110*176;
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,itemWidth,itemHeight)];
 
        [_coverImageView addSubview:self.vipLabel];
        [_coverImageView addSubview:self.countLabel];
    }
    return _coverImageView;
    
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


-(UILabel*)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.frame = CGRectMake(CGRectGetWidth(self.coverImageView.bounds)-64, CGRectGetHeight(self.coverImageView.bounds)-18, 64, 18);
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont fontWithName:TextFontName_Light size:11];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_countLabel.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _countLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _countLabel.layer.mask = maskLayer;
        _countLabel.backgroundColor = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.3];
    }
    return _countLabel;
}

-(UILabel*)titleLabel
{
    if (!_titleLabel) {
        
        CGFloat itemWidth = (KScreenWidth-45)/3;
        CGFloat itemHeight = CGRectGetHeight(self.bounds)-CGRectGetHeight(self.coverImageView.bounds);
        CGFloat itemY = CGRectGetMaxY(self.coverImageView.bounds);
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, itemY,itemWidth,itemHeight)];
        _titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"最多六个字";
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}



@end
