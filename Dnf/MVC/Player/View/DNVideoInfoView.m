//
//  DNVideoInfoView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNVideoInfoView.h"

@implementation DNVideoInfoView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
 
       CGFloat y = KScreenWidth*(9.0/16.0);
       self.frame = CGRectMake(0, y, KScreenWidth, 110);
       
        [self addSubview:self.videoTitleLabel];
        [self addSubview:self.watchCountLabel];
        [self addSubview:self.collectionButton];
        [self addSubview:self.shareButton];
        [self addSubview:self.vipInfoLabel];
        [self addSubview:self.lineA];
        [self addSubview:self.lineB];
        [self addSubview:self.openButton];
    
        self.collection = NO;
    }
    
    return self;
}



-(void)setvideoTitle:(NSString *)videoTitle
{
    _videoTitle = videoTitle;
    [self.videoTitleLabel setText:videoTitle];
}

-(void)setWatchCount:(NSString *)watchCount
{
    _watchCount = watchCount;
    [self.watchCountLabel setText:watchCount];
}

-(void)setCollection:(BOOL)collection
{
    _collection = collection;
    
    NSString * btnTitle = (collection==YES)?@"已收":@"收藏";
    
    UIColor * color = (collection==YES)?kThemeColor:[UIColor customColorWithString:@"999999"];
    
    UIImage * image = (collection==YES)?[UIImage imageNamed:@"video_collectioned_normal"]:[UIImage imageNamed:@"video_collection_normal"];
    
    [_collectionButton setTitle:btnTitle forState:UIControlStateNormal];
    
    [_collectionButton setTitleColor:color forState:UIControlStateNormal];
    
    [_collectionButton setImage:image forState:UIControlStateNormal];
}


-(UIView*)lineA
{
    if (!_lineA) {
        _lineA = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, KScreenWidth-90, 0.5)];
        _lineA.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
    }
    return _lineA;
}

-(UIView*)lineB
{
    if (!_lineB) {
        _lineB = [[UIView alloc]initWithFrame:CGRectMake(0, 109.5, KScreenWidth-90, 0.5)];
        _lineB.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
    }
    return _lineB;
}

-(UILabel*)videoTitleLabel
{
    if (!_videoTitleLabel) {
        _videoTitleLabel = [[UILabel alloc]init];
        _videoTitleLabel.frame = CGRectMake(14, 10, KScreenWidth-114, 21);
        _videoTitleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _videoTitleLabel.textColor = [UIColor customColorWithString:@"000000"];
        _videoTitleLabel.text = @"标题最多显示八个字";
    }
    return _videoTitleLabel;
}

-(UILabel*)watchCountLabel
{
    if (!_watchCountLabel) {
        _watchCountLabel = [[UILabel alloc]init];
        _watchCountLabel.frame = CGRectMake(14, 34, KScreenWidth-114, 21);
        _watchCountLabel.font = [UIFont fontWithName:TextFontName_Light size:13];
        _watchCountLabel.textColor = [UIColor customColorWithString:@"999999"];
        _watchCountLabel.text = @"1234567890次播放";
    }
    return _watchCountLabel;
}

-(UIButton*)collectionButton
{
    if (!_collectionButton) {
        _collectionButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionButton.frame = CGRectMake(KScreenWidth-100, 0, 50, 60);
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:10];
        
        [_collectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, -30, 0)];
        [_collectionButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        _collectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
     
    }
    return _collectionButton;
}

-(UIButton*)shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(KScreenWidth-50, 0, 50, 60);
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"video_share_normal"] forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:10];
        
        [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, -30, 0)];
        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        _shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
    }
    return _shareButton;
}

-(UILabel*)vipInfoLabel
{
    if (!_vipInfoLabel) {
        _vipInfoLabel = [[UILabel alloc]init];
        _vipInfoLabel.frame = CGRectMake(14, 78.5, KScreenWidth-114, 21);
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
        

        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary * attributedDict = @{ NSFontAttributeName:font,NSForegroundColorAttributeName:HexRGBAlpha(0xFb389c, 1),};
        [attributedString setAttributes:attributedDict range:NSMakeRange(attributedString.length-[price length]-1,[price length])];

        _vipInfoLabel.attributedText = attributedString;
        _vipInfoLabel.font = font;
    }
    return _vipInfoLabel;
}

-(UIButton*)openButton
{
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.frame= CGRectMake(KScreenWidth-90, 60, 90, 50);
        _openButton.backgroundColor = kThemeColor;
        [_openButton setTitle:@"开通VIP" forState:UIControlStateNormal];
        [_openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _openButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
    }
    return _openButton;
}


@end
