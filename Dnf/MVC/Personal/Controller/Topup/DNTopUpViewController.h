//
//  DNTopUpViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import "DNTopUpModel.h"
#import "DNTopUpTableViewCell.h"
@interface DNTopUpViewController : DNBaseViewController<UITableViewDelegate,UITableViewDataSource>

//列表视图
@property(nonatomic,strong)UITableView * tableView;

//数据源
@property(nonatomic,strong)NSMutableArray * dataArray;

@end
