//
//  DNRecordHeaderView.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNRecordHeaderView : UICollectionReusableView

@property(nonatomic,strong)UIView  * circleView;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UILabel * selectLabel;

@property(nonatomic,assign)NSInteger selectCount;



@end
