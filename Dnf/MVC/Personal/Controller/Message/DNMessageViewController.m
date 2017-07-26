//
//  DNMessageViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNMessageViewController.h"
#import "NSString+Date.h"
#define TEN_MINUTE (60*10)
#define TASK_USER_ID @"999"
@interface DNMessageViewController ()

@end

@implementation DNMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];

    //2拉取所有的数据
    [self requestMessageList];
    
    [self.leftButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showLeft
{
    [self.xl_sldeMenu showLeftViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
}

- (NSMutableArray<DNMessageModel *> *)messageArray {
    if (_messageArray == nil) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}

//获取消息列表 可以先获取20调， 下拉根据array0的第一条发送时间再去获取
- (void)requestMessageList {
    
    if(IsStrEmpty(self.messageid))
    {
        self.messageid = @"0";
    }
    
     [_noDataView hide];
     [_noNetWorkView hide];
    
    //掉接口获取数据
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getMessageListWithMessageid:self.messageid];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject *dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * messageArray = [dataObject getJSONArray:@"message"];
        
        for (int i=0; i<[messageArray.array count]; i++) {
            DNMessageModel *message = [[DNMessageModel alloc] init];
            
            NSString * addtime  = [messageArray.array[i] valueForKey:@"addtime"];
            
            message.sendTime =  [NSString timeSwitchTimestamp:addtime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
            message.showSendTime = NO;
            message.message  = [messageArray.array[i] valueForKey:@"message_text"];
           [self.messageArray addObject:message];
        }

        if ([self.messageArray count]==0) {
 
            CGRect rect  = CGRectMake(KScreenWidth/2-52, 165, 104, 80);
            
            [self showNoDataView:self.view noDataString:@"暂无消息" noDataImage:@"default_nomessage" imageViewFrame:rect];
            
        }else
        {
            [self intervalTime:self.messageArray];
            [self.messageTableView reloadData];
            [self scrollToEnd];
            
        }
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
        
         [self showNoNetWorkViewWithimageName:@"default_nonetwork"];
    };
    
    [request excute];
    
    

}


/**
 滚动到底部
 */
- (void)scrollToEnd {
    NSInteger s = [self.messageTableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.messageTableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.messageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO]; //滚动到最后一行
}


//每次请求完数据 都调用一下这个接口，
- (void)intervalTime:(NSMutableArray<DNMessageModel*> *)messageArray {
    if (messageArray.count < 1) return;
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < messageArray.count - 1; i++) {
        DNMessageModel *message1 = messageArray[i];
        DNMessageModel *message2 = messageArray[i + 1];
        if (message2.sendTime - message1.sendTime >= TEN_MINUTE) { //TEN_MINUTE
            [indexArray addObject:@(i + 1)];
        }
    }
    
    for (NSInteger i = indexArray.count - 1 ; i >= 0; i--) {
        DNMessageModel *message = [[DNMessageModel alloc] init];
        NSInteger index = [indexArray[i] unsignedIntegerValue];
        message.sendTime = messageArray[index].sendTime;
        message.showSendTime = YES;
        [messageArray insertObject:message atIndex:index];
    }
    
    //插入第一条的发送时间
    DNMessageModel *message = [[DNMessageModel alloc] init];
    message.sendTime = messageArray[0].sendTime;
    message.showSendTime = YES;
    [messageArray insertObject:message atIndex:0];
}


- (void)createUI {
    self.view.backgroundColor = [UIColor customColorWithString:@"fafafa"];

    [self showBackButton:YES];
    [self setNavTitle:@"系统消息"];
    [self initTableView];
}



-(void)initTableView {
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    self.messageTableView.backgroundColor = [UIColor customColorWithString:@"fafafa"];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.messageTableView];

}

#pragma mark - 消息来了 以及处理


- (void)currentSessionComingMessage:(DNMessageModel *)message {
    if (self.messageArray.count != 0) {
        [self addTimeModel:[self.messageArray lastObject] message:message];
    } else {
        [self addTimeModel:nil message:message];
    }
}

- (void)addTimeModel:(DNMessageModel *)message1 message:(DNMessageModel *)message2 {
    if (message1 == nil) {  //之前没有消息不要比较直接加入时间
        DNMessageModel *message = [[DNMessageModel alloc] init];
        message.sendTime = message2.sendTime;
        message.showSendTime = YES;
        [self.messageArray addObject:message];
    } else {
        if (message2.sendTime - message1.sendTime >= TEN_MINUTE) {
            DNMessageModel *message = [[DNMessageModel alloc] init];
            message.sendTime = message2.sendTime;
            message.showSendTime = YES;
            [self.messageArray addObject:message];
        }
    }
    
    //一定会把最后一条消息加到数组里， 刷新tableView
    [self.messageArray addObject:message2];
    [self.messageTableView reloadData];
}

#pragma mark - tableView

- (DNMessageModel *)fillmessageMode:(DNMessageModel *)messageModel {
    if (!messageModel) return nil;
    
    //对方发的
    messageModel.userId = TASK_USER_ID;
    messageModel.userIcon = @"messages_notice"; //不是url 而是本地图片
    messageModel.userNick = @"大妞范";
    
    return messageModel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", self.messageArray.count);
    return self.messageArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *showTimeCellID = @"showTimeCellID";
    static NSString *showMessageCellID = @"showMessageCellID";
    
    UITableViewCell *cell;
    
    DNMessageModel *messageModel = [self fillmessageMode:self.messageArray[indexPath.row]];
    
    if (messageModel.showSendTime) {
        //时间模型
        DNSendTimeTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:showTimeCellID];
        if (!timeCell) {
            timeCell = [[DNSendTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showTimeCellID];
        }
        [timeCell setSendTime:messageModel.sendTime];
        cell = timeCell;
    } else {
        DNMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:showMessageCellID];
        if (!messageCell) {
            messageCell = [[DNMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showMessageCellID];
        }
        [messageCell setMessageModel:messageModel];

        
        cell = messageCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cell的高度是 %f",self.messageArray[indexPath.row].cellHeight);
    
    return self.messageArray[indexPath.row].cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNTopUpViewController * topupVc = [DNTopUpViewController viewController];
    [self.navigationController pushViewController:topupVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
