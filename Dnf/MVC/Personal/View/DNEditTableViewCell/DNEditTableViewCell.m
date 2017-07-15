//
//  DNEditTableViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/14.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNEditTableViewCell.h"

@implementation DNEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.cellTitle];
        [self.contentView addSubview:self.cellDesc];
     
    }
    return self;
}


-(UILabel*)cellTitle
{
    if (!_cellTitle) {
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 60)];
        _cellTitle.font = [UIFont fontWithName:TextFontName_Light size:17];
        _cellTitle.textColor = [UIColor customColorWithString:@"484848"];
        
        
    }
    return _cellTitle;
}

-(UILabel*)cellDesc
{
    if (!_cellDesc) {
        _cellDesc = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, KScreenWidth-40-120, 60)];
        _cellDesc.textColor = [UIColor customColorWithString:@"999999"];
        _cellDesc.font = [UIFont fontWithName:TextFontName_Light size:15];
        _cellDesc.textAlignment = NSTextAlignmentRight;
    }
    return _cellDesc;
}



@end
