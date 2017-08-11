//
//  DNVipSegmentView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DNVipSegmentViewType)
{
    photoFree=0,
    photoVip,
};


@interface DNVipSegmentView : UIView

@property(nonatomic,strong)UIButton * freeButton;

@property(nonatomic,strong)UIButton * vipButton;
//展示类型
@property(nonatomic,assign)DNVipSegmentViewType type;

@end
