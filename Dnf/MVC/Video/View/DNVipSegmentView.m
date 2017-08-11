//
//  DNVipSegmentView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNVipSegmentView.h"

@implementation DNVipSegmentView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        
        [self addSubview:self.freeButton];
        [self addSubview:self.vipButton];
      
        self.type = 0;
        
    }
    return self;
    
}

-(UIButton*)freeButton
{
    if(!_freeButton)
    {
        _freeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _freeButton.frame = CGRectMake(KScreenWidth/2-81,20, 81, 24);
        [_freeButton setTitle:@"免费专区" forState:UIControlStateNormal];
        _freeButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:13];
        _freeButton.layer.cornerRadius = 12;
    }
    return _freeButton;
}

-(UIButton*)vipButton
{
    if(!_vipButton)
    {
        _vipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipButton.frame = CGRectMake(KScreenWidth/2,20, 81, 24);
        [_vipButton setTitle:@"VIP专区" forState:UIControlStateNormal];
        _vipButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:13];
        _vipButton.layer.cornerRadius = 12;
    }
    return _vipButton;
}

-(void)setType:(DNVipSegmentViewType)type
{
    _type = type;
    
    switch (type) {
        case 0:
        {
            self.freeButton.backgroundColor = kThemeColor;
            self.freeButton.layer.cornerRadius = 12;
            [self.freeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.vipButton.backgroundColor = [UIColor clearColor];
            [self.vipButton setTitleColor:[UIColor customColorWithString:@"484848"] forState:UIControlStateNormal];
        }
            break;
            case 1:
        {
            self.vipButton.backgroundColor = kThemeColor;
            self.vipButton.layer.cornerRadius = 12;
            [self.vipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.freeButton.backgroundColor = [UIColor clearColor];
            [self.freeButton setTitleColor:[UIColor customColorWithString:@"484848"] forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
    
}

@end
