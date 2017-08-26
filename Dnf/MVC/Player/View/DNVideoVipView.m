//
//  DNVideoVipView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/27.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNVideoVipView.h"

@implementation DNVideoVipView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        CGFloat y = KScreenWidth*(9.0/16.0)+60;
        self.frame = CGRectMake(0, y, KScreenWidth, 50);
        self.backgroundColor = [UIColor customColorWithString:@"fafafa"];
        [self addSubview:self.vipInfoLabel];
        [self addSubview:self.openButton];
        [self addSubview:self.line];
        
    }
    
    return self;
}

-(UIView*)line
{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, KScreenWidth-90, 0.5)];
        _line.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
    }
    return _line;
}

-(UILabel*)vipInfoLabel
{
    if (!_vipInfoLabel) {
        _vipInfoLabel = [[UILabel alloc]init];
        _vipInfoLabel.frame = CGRectMake(14, 18.5, KScreenWidth-114, 21);
        _vipInfoLabel.textColor = [UIColor customColorWithString:@"000000"];
        
        UIFont * font = (KScreenWidth==320)?[UIFont systemFontOfSize:13]:[UIFont systemFontOfSize:15];
        
        NSMutableArray * array = [[NSUserDefaults standardUserDefaults] valueForKey:@"kSessionProductArray"];
        
        NSString * string;
        NSString * title;
        NSString * price;
        
        if (IS_ARRAY_CLASS(array)) {
            
            NSDictionary * dict = [array lastObject];
            
            title= [NSString stringWithFormat:@"%@",[dict valueForKey:@"title"]];
            price= [NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
            string = [NSString stringWithFormat:@"现在购买超值%@只需要%@元",title,price];
            
        }
        
        if (IsStrEmpty(string)==NO&&IsStrEmpty(price)==NO&&IsStrEmpty(title)==NO) {
     
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            NSDictionary * attributedDict = @{ NSFontAttributeName:font,NSForegroundColorAttributeName:HexRGBAlpha(0xFb389c, 1),};
            [attributedString setAttributes:attributedDict range:NSMakeRange(attributedString.length-[price length]-1,[price length])];
            
            _vipInfoLabel.attributedText = attributedString;
          
        }else
        {
            _vipInfoLabel.text = @"现在购买超值VIP只需要1298元";

        }
        

        _vipInfoLabel.font = font;
    }
    return _vipInfoLabel;
}

-(UIButton*)openButton
{
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.frame= CGRectMake(KScreenWidth-90, 0, 90, 50);
        _openButton.backgroundColor = kThemeColor;
        [_openButton setTitle:@"开通VIP" forState:UIControlStateNormal];
        [_openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _openButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
    }
    return _openButton;
}


@end
