//
//  DNEditNickNameViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/14.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
typedef void (^inputblock)(NSString * nickName);
@interface DNEditNickNameViewController : DNBaseViewController<UITextFieldDelegate>
@property (nonatomic, copy)inputblock block;

@property(nonatomic,strong)UIView * textFieldBackground;
@property (nonatomic,strong)UITextField * inputTextField;

@property(nonatomic,copy)NSString * placeholderStr;

@end
