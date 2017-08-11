//
//  DNVideoModel.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNVideoModel : NSObject

@property(nonatomic,copy)NSString * detail;

@property(nonatomic,strong)NSDictionary * play;

@property(nonatomic,copy)NSString * vip;

@property(nonatomic,assign)NSInteger uid;

@property(nonatomic,copy)NSString * resource;

@property(nonatomic,copy)NSString * modtime;

@property(nonatomic,copy)NSString * addtime;

@property(nonatomic,assign)NSInteger width;

@property(nonatomic,assign)NSInteger watches;

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * cover;

@property(nonatomic,copy)NSString * status;

@property(nonatomic,assign)NSInteger height;

@property(nonatomic,assign)int duration;

@property(nonatomic,assign)NSInteger favoriteid;


//加项
@property(nonatomic,assign)NSInteger accessid;

@property(nonatomic,assign)NSInteger vrid;

@property(nonatomic,assign)NSInteger partyid;

@property(nonatomic,assign)NSInteger videoid;

@end
