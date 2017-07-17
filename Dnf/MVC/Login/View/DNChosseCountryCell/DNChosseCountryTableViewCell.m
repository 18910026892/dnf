//
//  DNChosseCountryTableViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNChosseCountryTableViewCell.h"

@implementation DNChosseCountryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.numLbl];
        [self.contentView addSubview:self.countryLbl];
    }
    return self;
}
-(UILabel*)countryLbl
{
    if (!_countryLbl) {
        _countryLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 41.5, 19.5)];
        _countryLbl.font = [UIFont fontWithName:TextFontName_Light size:16];
        _countryLbl.textColor = [UIColor customColorWithString:@"262626"];
    }
    return _countryLbl;
}

-(UILabel*)numLbl
{
    if (!_numLbl) {
        _numLbl = [[UILabel alloc]initWithFrame:CGRectMake(51.5, 15, 100, 19.5)];
        _numLbl.textColor = [UIColor customColorWithString:@"3f3f3f"];
        _numLbl.font =[UIFont fontWithName:TextFontName_Light size:16];
    }
    return _numLbl;
}


-(void)setCountry:(NSString *)country {
    _country = country;
    self.countryLbl.text = _country;
    [self.countryLbl sizeToFit];
}

-(void)setCountryNum:(NSInteger)countryNum {
    _countryNum = countryNum;
    self.numLbl.text = [NSString stringWithFormat:@"/ +%ld", _countryNum];
    self.numLbl.x = CGRectGetMaxX(self.countryLbl.frame)+2;
}


@end
