//
//  DNTopUpModel.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNTopUpModel : NSObject

@property(nonatomic,copy)NSString * detail;

@property(nonatomic,assign)NSInteger weight;

@property(nonatomic,assign)NSInteger expire;

@property(nonatomic,assign)NSInteger id;

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * price;

@property(nonatomic,copy)NSString * effect;

@property(nonatomic,copy)NSString * addtime;

@property(nonatomic,copy)NSString * modtime;

@property(nonatomic,copy)NSString * type;


@end
