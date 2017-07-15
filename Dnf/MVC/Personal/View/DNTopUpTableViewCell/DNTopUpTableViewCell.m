//
//  DNTopUpTableViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTopUpTableViewCell.h"

@implementation DNTopUpTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.vipTitleLabel];
        [self.contentView addSubview:self.vipDescLabel];
        [self.contentView addSubview:self.priceButton];
    
    }
    return self;
}

-(void)setTopUpModel:(DNTopUpModel *)topUpModel
{
    _topUpModel = topUpModel;
    
    self.vipTitleLabel.text = topUpModel.vipTitle;
    self.vipDescLabel.text = topUpModel.vipDesc;
    [self.priceButton setTitle:[NSString stringWithFormat:@"￥ %ld",(long)topUpModel.vipPrice] forState:UIControlStateNormal];
}


-(UILabel*)vipTitleLabel
{
    if (!_vipTitleLabel) {
        _vipTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 17.5)];
        _vipTitleLabel.textColor = [UIColor customColorWithString:@"484848"];
        _vipTitleLabel.font = [UIFont fontWithName:TextFontName_Light size:17];
        _vipTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _vipTitleLabel;
}

-(UILabel*)vipDescLabel
{
    if (!_vipDescLabel) {
        _vipDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, KScreenWidth-58-100, 15)];
        _vipDescLabel.textColor = [UIColor customColorWithString:@"999999"];
        _vipDescLabel.textAlignment = NSTextAlignmentLeft;
        _vipDescLabel.font = [UIFont fontWithName:TextFontName_Light size:12];
    }
    return _vipDescLabel;
}


-(UIButton*)priceButton
{
    if (!_priceButton) {
        _priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _priceButton.frame = CGRectMake(KScreenWidth-95, 14, 80, 32);
        _priceButton.backgroundColor = kThemeColor;
        _priceButton.layer.cornerRadius = 16;
        _priceButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];

        [_priceButton addTarget:self action:@selector(priceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _priceButton;
}

-(void)priceButtonClick:(UIButton*)sender
{
    if (self.delegate) {
        [self.delegate didSelectPriceButton:self.topUpModel];
    }
}

@end
