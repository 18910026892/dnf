//
//  DNTabBarItem.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTabBarItem.h"

@implementation Item

-(instancetype)initItemWithDictionary:(NSDictionary *)dict;
{
    self = [super init];
    if(self){
        self.title = dict[@"title"];
        self.imageString = dict[@"imageStr"];
        self.imageString_select = dict[@"imageStr_s"];
    }
    return self;
}
@end


@implementation DNTabBarItem
{
    
    Item *subItem;
}
#pragma mark - Life cycle
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        [self CreatUserInterface];
        
    }
    return self;
}
#pragma mark - Interface
-(void)CreatUserInterface
{
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
}

#pragma mark - Getters and Setters
-(UILabel*)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-17, self.frame.size.width, 15)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:TextFontName size:10];
    }
    return _titleLabel;
}

-(UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView =[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-10,9, 20,20)];
        _iconImageView.userInteractionEnabled = NO;
        
    }
    return _iconImageView;
}

-(void)setItem:(Item *)item
{
    _iconImageView.image = [UIImage imageNamed:item.imageString];
    _titleLabel.text = item.title;
    subItem = item;
}


-(void)setItemNomal;
{
    _titleLabel.textColor = [UIColor customColorWithString:@"484848"];
    self.iconImageView.image = [UIImage imageNamed:subItem.imageString];
}

-(void)setItemSlected:(Complete)finish;
{
    _titleLabel.textColor = [UIColor customColorWithString:@"FB389C"];
    self.iconImageView.image = [UIImage imageNamed:subItem.imageString_select];
    finish();
}


@end
