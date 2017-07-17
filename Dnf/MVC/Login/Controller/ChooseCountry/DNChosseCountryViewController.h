//
//  DNChosseCountryViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"

@interface DNChosseCountryViewController : DNBaseViewController
@property (nonatomic, copy) void(^selectBlock)(NSString *);
@end
