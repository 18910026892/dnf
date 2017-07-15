//
//  DNSearchViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"

@interface DNSearchViewController : DNWebViewController<UITextFieldDelegate>


@property(nonatomic,strong)UIImageView * searchImageView;

@property(nonatomic,strong)UIButton * cancleButton;

@property(nonatomic,strong)UITextField * searchTextField;

@end
