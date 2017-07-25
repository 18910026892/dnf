//
//  MJPhotoCollectionViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/20.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "MJPhotoCollectionViewCell.h"

@implementation MJPhotoCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;

        [self addSubview:self.coverImageView];
      
    }
    return self;
    
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        //选中时
        self.layer.borderWidth = 1;
        self.layer.borderColor = kThemeColor.CGColor;
        self.layer.masksToBounds = YES;
    }else{
        //非选中
        self.layer.borderWidth = 0;
    }
    
    // Configure the view for the selected state
}

-(UIImageView*)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    return _coverImageView;
}


@end
