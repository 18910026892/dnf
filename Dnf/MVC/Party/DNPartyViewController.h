//
//  DNPartyViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNHallBaseViewController.h"
#import "DNVideoTableViewCell.h"
#import "DNVideoModel.h"

@interface DNPartyViewController : DNHallBaseViewController<UITableViewDelegate,UITableViewDataSource>

//应用展示列表
@property(nonatomic,strong)UITableView * tableView;

//vr数据源
@property(nonatomic,strong)NSMutableArray * dataArray;

//偏移量参数（用来获取分页数据）
@property (nonatomic,assign) int offset;

@end
