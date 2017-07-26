//
//  DNRecordHeaderView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNRecordHeaderView.h"

@implementation DNRecordHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        
        [self addSubview:self.clearButton];
        [self addSubview:self.circleView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.selectLabel];

    }
    return self;
    
}

-(void)setSelectCount:(NSInteger)selectCount
{
    _selectCount = selectCount;
    
    if(_selectCount==0)
    {
       self.selectLabel.text = @"";
    }else
    {
        self.selectLabel.text = [NSString stringWithFormat:@"已选择%ld个",(long)selectCount];
        [self.selectLabel sizeToFit];
        self.selectLabel.x = KScreenWidth -14 -self.selectLabel.width;
    }

}


-(UIButton*)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(0, 0, KScreenWidth, 43);
        _clearButton.backgroundColor = [UIColor whiteColor];
        [_clearButton setTitle:@"一键清空" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clearButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _clearButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 13);
    }
    return _clearButton;
}


-(UIView*)circleView
{
    if (!_circleView) {
        _circleView = [[UIView alloc]initWithFrame:CGRectMake(15, 29+43, 10, 10)];
        _circleView.layer.cornerRadius = 5;
        _circleView.layer.borderWidth = 1;
        _circleView.layer.borderColor = kThemeColor.CGColor;
  
    }
    return _circleView;
}

-(UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(34, 22+43, 100, 24)];
        _titleLabel.text = @"视频";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:TextFontName_Light size:17];
        
    }
    return _titleLabel;
}

-(UILabel*)selectLabel
{
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-114, 24+43, 100, 20)];
        _selectLabel.textAlignment = NSTextAlignmentRight;
        _selectLabel.textColor = kThemeColor;
        _selectLabel.font = [UIFont fontWithName:TextFontName_Light size:14];
    }
    return _selectLabel;
}

@end
