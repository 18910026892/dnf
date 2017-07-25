//
//  DLMineUserInfoModel.h
//  Dreamer-ios-client
//
//  Created by Ant on 17/1/11.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import "DLBaseUserModel.h"

@interface DLMineUserInfoModel : DLBaseUserModel

/** 星票余额 */
@property (nonatomic, assign) long long ticket;

/**星钻余额*/
@property (nonatomic, assign) long long diamond;

@end
