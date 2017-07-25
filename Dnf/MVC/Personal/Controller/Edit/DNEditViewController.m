//
//  DNEditViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/14.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNEditViewController.h"
#import "UIImage+Compress.h"
@interface DNEditViewController ()

@end

@implementation DNEditViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initData];

    [self setupUI];
}

- (void)initData
{
    infoModel = [[DLMineUserInfoModel alloc]init];
    infoModel.avatar   =  [DNSession sharedSession].avatar;
    infoModel.uid      =  [DNSession sharedSession].uid;
    infoModel.nickName =  [DNSession sharedSession].nickname;
    infoModel.gender   =  [DNSession sharedSession].sex;
    infoModel.birth    =  [DNSession sharedSession].birthday;

}


//初始化设置 添加设置UI
- (void)setupUI {
    
    [self setNavigationBarHide:NO];;
    [self showBackButton:YES];
    
    [self setNavTitle:@"个人信息"];
    
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(saveMyInfo) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.tableView];
    
    [self refreshUI];
}



//下载头像更新 tableView
-(void)refreshUI
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[DNSession sharedSession].avatar] placeholderImage:[UIImage imageNamed:@"personalcenter_avatar_normal"]];
    
    [self.tableView reloadData];
}



-(void)creatUserInterface
{
    [self.view addSubview:self.tableView];
}


//保存逻辑（右上角按钮） (待处理)
// MARK: save
-(void)saveMyInfo
{
    [self.view endEditing:YES];
    
    profile = [[DLJSONObject alloc]initWithMutableDictionary:[[NSMutableDictionary alloc]init]];
    
    
    // nickname
    if (!IsStrEmpty(infoModel.nickName)&& infoModel.nickName !=  [DNSession sharedSession].nickname) { // 昵称不为空 且 发生变化
        
        [profile putWithString:infoModel.nickName key:@"nickname"];
        
    }
    //性别
    
    if (!IsStrEmpty(infoModel.gender)&& infoModel.gender !=  [DNSession sharedSession].sex) { // 性别发生变化
        
        [profile putWithString:infoModel.gender key:@"gender"];
        
    }
    

    
    // 生日
    
    if (!IsStrEmpty(infoModel.birth)&& infoModel.birth !=  [DNSession sharedSession].birthday) {
        
        [profile putWithString:infoModel.birth key:@"birth"];
        
    }

    
    // 头像
    
    if (!IsStrEmpty(infoModel.avatar)&& infoModel.avatar !=  [DNSession sharedSession].avatar) {
        
        [profile putWithString:infoModel.avatar key:@"avatar"];
        
    }
    
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:profile.dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (parseError) {
        
        [self.view makeToast:@"你输入的昵称或者签名含有非法字符" duration:1.5 position:CSToastPositionCenter];
        
        return;
    }
    
    NSString *profileStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //   NSLog(@"profileStr == %@",profileStr);
    
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory synchUserInfoWithToken: [DNSession sharedSession].token
                                                                          profile:profileStr];
    
    
    request.requestSuccess = ^(id response)
    {
        
        
         [DNSession sharedSession].avatar = infoModel.avatar;
         [DNSession sharedSession].uid      = infoModel.uid ;
         [DNSession sharedSession].nickname     = infoModel.nickName;
         [DNSession sharedSession].sex       = infoModel.gender;
         [DNSession sharedSession].birthday     = infoModel.birth;
         [self.view makeToast:@"保存成功" duration:3.0 position:CSToastPositionCenter];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"DNUserInfoChange" object:nil];

    };
    
    request.requestFaile  = ^(NSError *error)
    {
        NSLog(@"修改失败。。。");
    };
    
    [request excute];
    
}



#pragma mark - tableViewSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //在这个里面控制每组返回多少行
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
 
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"DNEditTableViewCell";
    
    DNEditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell)
    {
        cell = [[DNEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
 
    cell.accessoryType =(indexPath.section==0&&indexPath.row==2)?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
  
    
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.cellTitle.frame = CGRectMake(20, 20, 100, 60);
                    cell.cellTitle.text= @"头像";
                    
                    [cell addSubview:self.avatarImageView];
          
  
                }
                    break;
                    case 1:
                {
                    cell.cellTitle.text= @"昵称";
                    cell.cellDesc.text = infoModel.nickName;
                }
                    break;
                    case 2:
                {
                    cell.cellTitle.text= @"ID";
                    cell.cellDesc.text = [DNSession sharedSession].uid;
                }
                    break;
                default:
                    break;
            }
        }
            break;
            case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.cellTitle.text= @"生日";
                    cell.cellDesc.text = infoModel.birth;
                }
                    break;
                    case 1:
                {
                    cell.cellTitle.text= @"性别";
 
                    cell.cellDesc.text = ([infoModel.gender isEqualToString:@"M"])?@"男":@"女";
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section==0&&indexPath.row==0) {
        return 100;
    }
    return 60;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
        
                    UIActionSheet*photoActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
                    photoActionSheet.delegate = self;
                    photoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                    photoActionSheet.tag = 9001;
                    [[UIView appearance] setTintColor:[UIColor blackColor]];
                    [photoActionSheet showInView:self.view];
                
                }
                    break;
                case 1:
                {
                    DNEditNickNameViewController * editNickNameVc = [DNEditNickNameViewController viewController];
                    
                    [self.navigationController pushViewController:editNickNameVc animated:YES];
                    
                    //逆向传值
                    editNickNameVc.block = ^(NSString *nickName){
                        
    
                        infoModel.nickName = nickName;
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        
                        
                    };
                }
                    break;
                case 2:
                {
               
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
        

                    BOOL isHavePick = NO;
                    for (UIView * view in self.view.subviews) {
                        if ([[view  class] isSubclassOfClass:[FullTimeView class]]) {
                            isHavePick = YES;
                            return;
                        }
                    }
                    if (!isHavePick) {
                      

                        [self.view addSubview:self.pickView];
                        if ([DNSession sharedSession].birthday.length&&[[DNSession sharedSession].birthday isEqualToString:@"0000-00-00"]==NO) {
                            NSDate * date = [NSDate dateWithTimeIntervalSince1970: [[DNSession sharedSession].birthday dateStringWithFormateStyle:@"yyyy-MM-dd"]/1000];
                            self.pickView.curDate = date;
                        }else{
                            NSString * birthday=@"1990-01-01";
                            self.pickView.curDate=[NSDate dateWithTimeIntervalSince1970: [birthday dateStringWithFormateStyle:@"yyyy-MM-dd"]/1000];
                        }
                        self.pickView.delegate = self;
                    }

                }
                    break;
                case 1:
                {
                    UIActionSheet * userSexActionSheet =[[UIActionSheet alloc] initWithTitle:@"性别修改" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                    userSexActionSheet.delegate = self;
                    userSexActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                    userSexActionSheet.tag = 9002;
             
                    [[UIView appearance] setTintColor:[UIColor blackColor]];
                    [userSexActionSheet showInView:self.view];

                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
}


-(void)didFinishPickView:(NSDate*)date {
    NSDateFormatter * formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString * gradeTime=[formate stringFromDate:date];

    infoModel.birth = gradeTime;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (actionSheet.tag) {
        case 9001:
            
        {
            UIImagePickerController *imgpicker = [[UIImagePickerController alloc]init];
            switch (buttonIndex) {
                case 0:
                {
                    NSLog(@"点击了照相");
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
                        {
                            //无权限
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }else{
                            UIImagePickerController *imgpicker = [[UIImagePickerController alloc]init];
                            imgpicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                            imgpicker.allowsEditing = YES;
                            imgpicker.delegate = self;
                            [[imgpicker navigationBar] setTintColor:[UIColor blackColor]];
                            [self presentViewController:imgpicker animated:YES completion:nil];
                        }
                    }
                    else
                    {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本设备不支持相机模式" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                        [alert show];
                        return;
                    }
                }
                    break;
                case 1:{
                    NSLog(@"相册");
                    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
                    {
                        //无权限
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在隐私中设置相册权限" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                        [alert show];
                        
                    }else{
                        imgpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        imgpicker.allowsEditing = YES;
                        imgpicker.delegate = self;
                        [[imgpicker navigationBar] setTintColor:[UIColor blackColor]];
                        [self presentViewController:imgpicker animated:YES completion:nil];
                    }
                    
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    
                    
                    
                }
                    break;
            
                default:
                    break;
            }
            
        }
            break;
        case 9002:
        {
       
            switch (buttonIndex) {
                case 0:
                {
                    infoModel.gender = @"M";
                }
                    break;
                    case 1:
                {
                    infoModel.gender = @"F";
                }
                    break;
                default:
                    break;
            }
            
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        }
            break;
        default:
            break;
    }

}

#pragma mark imagePickerController methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0,3_0)
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self UploadimageWithImage:image];
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self UploadimageWithImage:image];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//上传头像
-(void)UploadimageWithImage:(UIImage*)avatarImage
{



    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 
    if (avatarImage.size.width > 1000 || avatarImage.size.height >1000) { // 大于1000 则只处理尺寸
        
        avatarImage = [avatarImage imageByScalingAndCroppingForSize:CGSizeMake(1000,1000)];
    }
    
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory uplodImage:avatarImage kind:@"avatar"];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject  *object = response;
        
        DLJSONObject *resultData = [object getJSONObject:@"data"];
    
        self.avatarImageView.image = avatarImage;
        infoModel.avatar = [resultData getString:@"path"];
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    
    [request excute];
    
}





-(UITableView*)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,KScreenWidth,KScreenHeight - 64)
                                                 style:UITableViewStyleGrouped];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate     = self;
        _tableView.dataSource   = self;
    }
    return _tableView;
}

-(UIImageView*)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-90, 25, 50 , 50) ];
        _avatarImageView.layer.cornerRadius = 25;
        _avatarImageView.layer.masksToBounds = YES;
        
    }
    return _avatarImageView;
}

-(FullTimeView*)pickView
{
    if (!_pickView) {
        _pickView = [[FullTimeView alloc]initWithFrame:CGRectMake(0, KScreenHeight-220, KScreenWidth, 220)];
        _pickView.delegate = self;
    }
    return _pickView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
