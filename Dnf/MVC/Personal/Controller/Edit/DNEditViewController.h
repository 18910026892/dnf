//
//  DNEditViewController.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/14.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "DNEditTableViewCell.h"
#import "DNEditNickNameViewController.h"
//#import "FullTimeView.h"
//#import "NSString+Date.h"
#import "DLJSONObject.h"
#import "DLMineUserInfoModel.h"

typedef void (^editblock)(NSString * nickName,NSString*avatar);


@interface DNEditViewController : DNBaseViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

{
    DLMineUserInfoModel *infoModel; //用户模型
    DLJSONObject *profile;
}
@property (nonatomic, copy)editblock block;

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UIImageView * avatarImageView;

//@property(nonatomic,strong)FullTimeView*pickView;

@end
