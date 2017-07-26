//
//  DLNoNetView.m
//  DreamLive
//
//  Created by GongXin on 16/11/30.
//  Copyright © 2016年 com.dreamer. All rights reserved.
//


#import "DLNoNetView.h"


@interface DLNoNetView(){
    BOOL _isLastNoNetwork; //上次是否无网
}

@property (strong, nonatomic)  UIImageView *flagImageView;
@property (strong, nonatomic)  UILabel *touchScrrenLabel;
@property (strong, nonatomic)  UIActivityIndicatorView *aiv;

@end

@implementation DLNoNetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadBtnClicked:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)initNoNetView
{
    [self addSubview:self.flagImageView];
    [self addSubview:self.touchScrrenLabel];
}

-(UIImageView*)flagImageView
{
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc]init];
        _flagImageView.frame = CGRectMake((KScreenWidth - 72) / 2, (self.height - 72) / 2 - 64, 72, 72);
        _flagImageView.image = [UIImage imageNamed:@"empty_wifi"];
    }
    return _flagImageView;
}


-(UILabel*)touchScrrenLabel
{
    if (!_touchScrrenLabel) {
        _touchScrrenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.flagImageView.frame)+14, KScreenWidth, 17)];
        _touchScrrenLabel.textColor = [UIColor customColorWithString:@"#B2B2B2"];
        _touchScrrenLabel.font = [UIFont fontWithName:TextFontName_Light size:14];
        _touchScrrenLabel.textAlignment = NSTextAlignmentCenter;
        _touchScrrenLabel.text = @"哎呀！网络出问题啦！\n请检查后重试～";
        _touchScrrenLabel.numberOfLines = 0;
    }
    return _touchScrrenLabel;
}

- (void)reloadBtnClicked:(id)sender
{
    
        _aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        _aiv.frame = CGRectMake(KScreenWidth/2.f-50, (self.height-150-18-14)/5.f, 100, 0);
        
        [self addSubview:_aiv];
    

    //开始转动
    [_aiv startAnimating];
   
    
    
    if (_reloadDataBlock) {
        _reloadDataBlock();
    }else if(_delegate && [_delegate respondsToSelector:@selector(retryToGetData)]){
        [_delegate retryToGetData];
    }
}

#pragma mark public method

-(void)showInView:(UIView*)superView style:(NoNetWorkViewStyle)style imageName:(NSString*)imageName;
{
    [superView addSubview:self];

    self.height = superView.height;
    
    [self initNoNetView];

    if (style==NoNetWorkViewStyle_No_NetWork) {
        _flagImageView.image = [UIImage imageNamed:imageName];
   
        
    }else if(style==NoNetWorkViewStyle_Load_Fail){
        
        _flagImageView.image = [UIImage imageNamed:imageName];

    }
    
    //如果上次无网络，则闪烁文字
    if(_isLastNoNetwork){
     
        _touchScrrenLabel.alpha = 0;
        [UIView animateWithDuration:.1 animations:^{
   
            _touchScrrenLabel.alpha = 1.0;
        }];
    }
    _isLastNoNetwork = YES;
}
-(void)hide
{
    _isLastNoNetwork = NO;
    [self removeFromSuperview];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
//连网小菊花停止转动
-(void)stopAiv
{
    [_aiv stopAnimating];
    self.userInteractionEnabled = YES;
}

@end



