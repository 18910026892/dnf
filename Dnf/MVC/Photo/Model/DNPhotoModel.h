//
//  DNPhotoModel.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNPhotoModel : NSObject

@property(nonatomic,assign)NSInteger photonumber;

@property(nonatomic,strong)NSDictionary * play;

@property(nonatomic,copy)NSString * vip;

@property(nonatomic,assign)NSInteger uid;

@property(nonatomic,copy)NSString * resource;

@property(nonatomic,copy)NSString * modtime;

@property(nonatomic,assign)NSInteger width;

@property(nonatomic,copy)NSString * addtime;

@property(nonatomic,assign)NSInteger watch;

@property(nonatomic,copy)NSString * title;

@property(nonatomic,assign)NSInteger albumid;

@property(nonatomic,assign)NSInteger height;

@property(nonatomic,assign)NSInteger favoriteid;

@property(nonatomic,copy)NSString * cover;

@property(nonatomic,copy)NSString * status;

@property(nonatomic,assign)int duration;



@end
