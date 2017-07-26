//
//  DNRecordModel.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNRecordModel : NSObject

@property(nonatomic,copy)NSString * detail;

@property(nonatomic,copy)NSString * vip;

@property(nonatomic,assign)NSInteger videoid;

@property(nonatomic,assign)NSInteger vrid;

@property(nonatomic,assign)NSInteger accessid;

@property(nonatomic,assign)NSInteger uid;

@property(nonatomic,copy)NSString * resource;

@property(nonatomic,copy)NSString * modtime;

@property(nonatomic,assign)NSInteger width;

@property(nonatomic,assign)NSInteger watches;

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * deleted;

@property(nonatomic,copy)NSString * cover;

@property(nonatomic,assign)NSInteger height;

@property(nonatomic,assign)int duration;

@property(nonatomic,assign)NSInteger favoriteid;

@property(nonatomic,strong)NSDictionary * play;

@end
