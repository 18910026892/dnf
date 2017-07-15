//
//  DNPersonalViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import "DNPersonalTableViewCell.h"
#import "DNTopUpViewController.h"
#import "DNMessageViewController.h"
#import "DNRecordViewController.h"
#import "DNHelpViewController.h"
#import "DNEditViewController.h"
@interface DNPersonalViewController :DNBaseViewController<UITableViewDelegate,UITableViewDataSource>

//个人中心
@property(nonatomic,strong)UITableView * tableView;

//顶部视图
@property(nonatomic,strong)UIView * headerView;

//头像视图
@property(nonatomic,strong)UIButton * avatarButton;

//昵称
@property(nonatomic,strong)UILabel * nickNameLabel;


@end
