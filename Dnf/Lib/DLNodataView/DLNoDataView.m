//
//  DLNoDataView.m
//  DreamLive
//
//  Created by GongXin on 16/11/30.
//  Copyright © 2016年 com.dreamer. All rights reserved.
//


#import "DLNoDataView.h"

@interface DLNoDataView (){
    
    UILabel            *dataLabel;
    UIView             *contentView;
    UIImageView        *loaderrImageView;
}

@end

@implementation DLNoDataView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initNodataView];
        
    }
    return self;
}

-(void)initNodataView

{
    loaderrImageView = [[UIImageView alloc]init];
    [self addSubview:loaderrImageView];
    
    dataLabel = [[UILabel alloc]init];
    dataLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
    dataLabel.textColor = [UIColor customColorWithString:@"999999"];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.numberOfLines = 0;
    [self addSubview:dataLabel];
    
}

-(void)showNoDataView:(UIView*)superView noDataString:(NSString *)noDataString noDataImage:(NSString*)imageName imageViewFrame:(CGRect)rect;
{
    
    if (!self.superview) {
        self.frame = CGRectMake(0,64, superView.frame.size.width, superView.frame.size.height);
        [superView addSubview:self];
    }
    
    dataLabel.text = IsStrEmpty(noDataString) ? @"暂无数据" : noDataString;
 
    loaderrImageView.image = [UIImage imageNamed:imageName];
    
    loaderrImageView.frame = rect;
    
    CGFloat labelHeight = 21;
    
    dataLabel.frame = CGRectMake(10, loaderrImageView.y+loaderrImageView.height+3, KScreenWidth-20, 20);
    if (labelHeight>20) {
        
        dataLabel.height = labelHeight+20;
    }
    
    
    
    
}



-(void)setContentViewFrame:(CGRect)rect
{
    self.frame = rect;
}

-(void)setColor:(UIColor*)color
{
    self.backgroundColor = color;
    contentView.backgroundColor = color;
}

-(void)hide
{
    [self removeFromSuperview];

}
-(void)dataAction:(id)sender{

    if(_delegate && [_delegate respondsToSelector:@selector(didClickedNoDataButton)])
        {
            [_delegate didClickedNoDataButton];
        }
 
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

