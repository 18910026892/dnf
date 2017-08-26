//
//  DNConfig.h
//  Dnf
//
//  Created by 巩鑫 on 2017/8/8.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNConfig : NSObject


+ (DNConfig *)sharedConfig;

//是否审核中 NO审核 YES过审核
@property(nonatomic,assign)BOOL audit;

//商店评价
@property(nonatomic,assign)BOOL store;

@end
