//
//  DNMessageModel.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

//气泡相对于cell 的间距
#define BACKGROUND_WITH_CELL_SPAC 10.0

//内容相对气泡的间距
#define CONTENT_HORIZONTAL_SPAC 18.7
#define CONTENT_VERTICAL_SPAC 9


//私信和系统消息都是一个模型
@interface DNMessageModel : NSObject

/* 基本信息都是决定根据发送人决定的 我的还是对方的*/
@property(nonatomic, copy)NSString *userId; //id
@property(nonatomic, copy)NSString *userIcon; //头像
@property(nonatomic, copy)NSString *userNick; //昵称

@property(nonatomic, assign)NSInteger messageId; //消息id
@property(nonatomic, copy)NSString *message;   //消息内容 现在只是文本

@property(nonatomic, copy)NSString *messageSender; //消息发送者
@property(nonatomic, assign)NSInteger sendTime; //消息发送时间

@property(nonatomic, assign)BOOL showSendTime; //这个模型表示是否这个模型只显示时间

@property(nonatomic, assign)float cellHeight;
@property(nonatomic, assign)CGSize contentSize;



@end
