//
//  DNChosseCountryTableViewCell.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNChosseCountryTableViewCell : UITableViewCell
@property (strong, nonatomic)UILabel *countryLbl;
@property (strong, nonatomic)UILabel *numLbl;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, assign) NSInteger countryNum;
@end
