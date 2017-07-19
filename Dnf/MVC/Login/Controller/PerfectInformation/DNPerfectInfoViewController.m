//
//  DNPerfectInfoViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/18.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPerfectInfoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "DNTextField.h"
#import "FullTimeView.h"
@interface DNPerfectInfoViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,FinishPickView>

@property(nonatomic,strong)UIButton * passButton;

@property(nonatomic,strong)UILabel * welcomeLabel;

@property(nonatomic,strong)UILabel * promptLabel;

@property(nonatomic,strong)UIButton * avatarButton;

@property(nonatomic,strong)UIImageView * accountImageView;

@property(nonatomic,strong)DNTextField * nickNameTextField;

@property(nonatomic,strong)UIImageView * sexImageView;

@property(nonatomic,strong)UIButton * manButton;

@property(nonatomic,strong)UIButton * womanButton;

@property(nonatomic,strong)UIImageView * birthdayImageView;

@property(nonatomic,strong)UIButton * birthdayButton;

@property(nonatomic,strong)UIImageView * arrowImageView;

@property(nonatomic,strong)UIButton * nextBtn;

@property(nonatomic,strong)FullTimeView*pickView;

@property(nonatomic,assign)BOOL isWoman;

@end

@implementation DNPerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
    [self operationData];
}

-(void)operationData
{
    self.isWoman = YES;
}

-(void)creatUserInterface
{
    [self setNavigationBarHide:YES];
    [self.view addSubview:self.passButton];
    [self.view addSubview:self.welcomeLabel];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.avatarButton];
    [self.view addSubview:self.accountImageView];
    [self.view addSubview:self.nickNameTextField];
    [self.view addSubview:self.sexImageView];
    [self.view addSubview:self.womanButton];
    [self.view addSubview:self.manButton];
    [self.view addSubview:self.birthdayImageView];
    [self.view addSubview:self.birthdayButton];
    [self.view addSubview:self.arrowImageView];
    [self.view addSubview:self.nextBtn];
    [self initLines];
}

-(void)initLines
{
    for (int i=0; i<2; i++) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(80, 332+i*133.5, KScreenWidth-130, 0.5)];
        lineView.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
        [self.view addSubview:lineView];
    }
}

-(void)avatarButtonClick:(UIButton*)sender
{
    UIActionSheet*photoActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    photoActionSheet.delegate = self;
    photoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    photoActionSheet.tag = 9001;
    [[UIView appearance] setTintColor:[UIColor blackColor]];
    [photoActionSheet showInView:self.view];
}


-(void)womanButtonClick:(UIButton*)sender
{
    self.isWoman = YES;
}
-(void)manButtonClick:(UIButton*)sender
{
    self.isWoman = NO;
}

-(void)birthdayButtonClick:(UIButton*)sender
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
        if ([DNSession sharedSession].birthday.length) {
            NSDate * date = [NSDate dateWithTimeIntervalSince1970: [[DNSession sharedSession].birthday dateStringWithFormateStyle:@"yyyy-MM-dd"]/1000];
            self.pickView.curDate = date;
        }else{
            NSString * birthday=@"1990-01-01";
            self.pickView.curDate=[NSDate dateWithTimeIntervalSince1970: [birthday dateStringWithFormateStyle:@"yyyy-MM-dd"]/1000];
        }
        self.pickView.delegate = self;
    }
}

-(void)passButtonClick:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)nextButtonClick:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)didFinishPickView:(NSDate*)date {
    NSDateFormatter * formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString * gradeTime=[formate stringFromDate:date];
    [DNSession sharedSession].birthday = gradeTime;
 
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

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
    
    [self.avatarButton setImage:avatarImage forState:UIControlStateNormal];
    NSData * data = UIImageJPEGRepresentation(avatarImage, 1.0);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}



-(void)setIsWoman:(BOOL)isWoman
{
    _isWoman = isWoman;
    
    if (self.isWoman==YES) {
        self.womanButton.backgroundColor = kThemeColor;
        [self.womanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.womanButton.layer.borderWidth= 0;
        self.manButton.layer.borderWidth = 1;
        self.manButton.layer.borderColor = [UIColor customColorWithString:@"999999"].CGColor;
        [self.manButton setBackgroundColor:[UIColor whiteColor]];
        [self.manButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        
    }else
    {
        self.manButton.backgroundColor = kThemeColor;
        [self.manButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.manButton.layer.borderWidth= 0;
        self.womanButton.layer.borderWidth = 1;
        self.womanButton.layer.borderColor = [UIColor customColorWithString:@"999999"].CGColor;
        [self.womanButton setBackgroundColor:[UIColor whiteColor]];
        [self.womanButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
    }
}

-(UIButton*)passButton
{
    if (!_passButton) {
        _passButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passButton setFrame:CGRectMake(KScreenWidth-48,20,100,50)];
        _passButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        [_passButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _passButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_passButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_passButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -110, 0, 0)];
        [_passButton setImage:[UIImage imageNamed:@"settings_into_normal"] forState:UIControlStateNormal];
        [_passButton addTarget:self action:@selector(passButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _passButton;
}

-(UILabel*)welcomeLabel
{
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, KScreenWidth, 22)];
        _welcomeLabel.font = [UIFont fontWithName:TextFontName size:18];
        _welcomeLabel.textColor = [UIColor blackColor];
        _welcomeLabel.textAlignment = NSTextAlignmentCenter;
        _welcomeLabel.text = @"欢迎来到大妞范";
    }
    return _welcomeLabel;
}

-(UILabel*)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 81, KScreenWidth, 18)];
        _promptLabel.text = @"填写完整信息，以获得更多的粉丝";
        _promptLabel.textColor = [UIColor customColorWithString:@"999999"];
        _promptLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}

-(UIButton*)avatarButton
{
    if (!_avatarButton) {
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarButton.frame = CGRectMake(KScreenWidth/2-76, 132, 152, 152);
        [_avatarButton setImage:[UIImage imageNamed:@"login_addprofile_normal"] forState:UIControlStateNormal];
        [_avatarButton addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}


-(UIImageView*)accountImageView
{
    if (!_accountImageView) {
        _accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 300, 25, 25)];
        _accountImageView.image = [UIImage imageNamed:@"login_profile_icon"];
    }
    return _accountImageView;
}

-(DNTextField*)nickNameTextField
{
    if (!_nickNameTextField) {
        _nickNameTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,300, KScreenWidth-130,27)];
        _nickNameTextField.placeholder = @"昵称 (长度为3至8个字)";
        _nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nickNameTextField.keyboardType = UIKeyboardTypeDefault;
        _nickNameTextField.returnKeyType = UIReturnKeyDefault;
        _nickNameTextField.delegate = self;
        _nickNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _nickNameTextField.textColor = [UIColor blackColor];
        
    }
    return _nickNameTextField;
    
}

-(UIImageView*)sexImageView
{
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 374, 25, 25)];
        [_sexImageView setImage:[UIImage imageNamed:@"login_gender_icon"]];
    }
    return _sexImageView;
}

-(UIButton*)womanButton
{
    if (!_womanButton) {
        _womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _womanButton.frame = CGRectMake(73, 372, 88, 30);
        [_womanButton setTitle:@"女" forState:UIControlStateNormal];
        _womanButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        [_womanButton addTarget:self action:@selector(womanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _womanButton.layer.cornerRadius = 15;
    }
    return _womanButton;
}

-(UIButton*)manButton
{
    if (!_manButton) {
        _manButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _manButton.frame = CGRectMake(175, 372, 88, 30);
        [_manButton setTitle:@"男" forState:UIControlStateNormal];
        _manButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        [_manButton addTarget:self action:@selector(manButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _manButton.layer.cornerRadius = 15;
    }
    return _manButton;
}

-(UIImageView*)birthdayImageView
{
    if (!_birthdayImageView) {
        _birthdayImageView =[[UIImageView alloc]initWithFrame:CGRectMake(35, 438, 24, 21)];
        _birthdayImageView.image = [UIImage imageNamed:@"login_birthdayicon"];
    }
    return _birthdayImageView;
}

-(UIButton*)birthdayButton
{
    if (!_birthdayButton) {
        _birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _birthdayButton.frame = CGRectMake(73, 429, 200, 38);
        _birthdayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_birthdayButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        [_birthdayButton setTitle:@"请输入你的生日" forState:UIControlStateNormal];
        _birthdayButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _birthdayButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_birthdayButton addTarget:self action:@selector(birthdayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _birthdayButton;
}

-(UIImageView*)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-68, 437, 28, 28)];
        _arrowImageView.image = [UIImage imageNamed:@"settings_into_normal"];
    }
    return _arrowImageView;
}

-(UIButton*)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.backgroundColor = kThemeColor;
        _nextBtn.frame = CGRectMake(38, KScreenHeight-63, KScreenWidth-72, 36);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        _nextBtn.layer.cornerRadius = 18;
        [_nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _nextBtn;
}

-(FullTimeView*)pickView
{
    if (!_pickView) {
        _pickView = [[FullTimeView alloc]initWithFrame:CGRectMake(0, KScreenHeight-220, KScreenWidth, 220)];
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
