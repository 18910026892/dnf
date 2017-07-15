//
//  DNRecordViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import "DNSegmentView.h"
#import "DNRecordListViewController.h"
@interface DNRecordViewController : DNBaseViewController<UIScrollViewDelegate>

@property (nonatomic,strong) DNSegmentView * segmentView;

@property (nonatomic,strong) UIButton * clearButton;

@property (nonatomic,strong) UIScrollView * bigScrollView;

@property (nonatomic,assign) NSInteger headerIndex;

@end
