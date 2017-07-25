//
//  DNMessageViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import "DNMessageModel.h"
#import "DNMessageTableViewCell.h"
#import "DNSendTimeTableViewCell.h"
#import "DNTopUpViewController.h"
@interface DNMessageViewController : DNBaseViewController<UITableViewDelegate,UITableViewDataSource>

//消息
@property(nonatomic,strong)NSMutableArray<DNMessageModel *> *messageArray;

//消息列表
@property(nonatomic,strong)UITableView * messageTableView;

//消息id
@property(nonatomic,copy)NSString * messageid;


@end
