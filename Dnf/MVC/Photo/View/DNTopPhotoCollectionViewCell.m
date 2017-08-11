//
//  DNTopPhotoCollectionViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTopPhotoCollectionViewCell.h"

@implementation DNTopPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.12].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.vipLabel];
        
    }
    return self;
}

-(void)setPhotoModel:(DNPhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    NSString * imageUrl = [photoModel.play valueForKey:@"url"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];

    
    self.vipLabel.hidden = ([photoModel.vip isEqualToString:@"Y"])?NO:YES;
    
}

-(UIImageView*)coverImageView
{
    if(!_coverImageView)
    {

        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,200,320)];
        
        [_coverImageView addSubview:self.vipLabel];
     
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



@end
