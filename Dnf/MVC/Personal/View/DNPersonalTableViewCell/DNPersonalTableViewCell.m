//
//  DNPersonalTableViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPersonalTableViewCell.h"

@implementation DNPersonalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 16, 100, 24)];
        _titleLabel.font = [UIFont fontWithName:TextFontName_Light size:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor customColorWithString:@"484848"];
    }
    return _titleLabel;
}

@end
