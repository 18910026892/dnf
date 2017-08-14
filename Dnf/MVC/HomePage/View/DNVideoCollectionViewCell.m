//
//  DNVideoCollectionViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNVideoCollectionViewCell.h"
#import "NSString+Date.h"
@implementation DNVideoCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.12].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
  
        [self.contentView addSubview:self.coverImageView];
 
    }
    return self;
}

-(void)setVideoModel:(DNVideoModel *)videoModel
{
    _videoModel = videoModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.cover]];

    
    self.vipLabel.hidden = ([videoModel.vip isEqualToString:@"Y"])?NO:YES;

}

-(UIImageView*)coverImageView
{
    if(!_coverImageView)
    {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 169,95)];
        
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
        [_coverImageView addSubview:self.vipLabel];
  
    }
    return _coverImageView;
    
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


@end
