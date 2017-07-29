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


-(UIImageView*)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    return _coverImageView;
}


@end
