//
//  DNLoginViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNLoginViewController.h"
#import "DNPhoneInputViewController.h"
#import "DNEmailRegisterViewController.h"
#import "DNEmailViewController.h"
#import "UIUnderlinedButton.h"
#import "DNTextField.h"
#import "DNThirdLoginManager.h"
@interface DNLoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel * accountLabel;

@property(nonatomic,strong)UILabel * passwordLabel;

@property(nonatomic,strong)DNTextField * accoutTextField;

@property(nonatomic,strong)DNTextField * passwordTextField;

@property(nonatomic,strong)UIButton * showPasswordButton;

@property(nonatomic,strong)UIButton * loginButton;

@property(nonatomic,strong)UIButton * registerButton;

@property(nonatomic,strong)UIUnderlinedButton * forgetButton;

@property(nonatomic,strong)UIView * linea,*lineb;

@property(nonatomic,strong)UILabel * otherLoginLabel;

@property(nonatomic,strong)UICollectionView * collectionView;

@end

@implementation DNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
    
    [self textFieldDidChange:nil];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self setNavTitle:@"大妞范登录"];
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.accoutTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.linea];
    [self.view addSubview:self.lineb];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.otherLoginLabel];
    [self initOtherLoginButton];
    
}

-(void)initOtherLoginButton
{
    NSArray * normalImage = @[@"login_wechat_normal",@"login_weibo_normal",@"login_qq_normal"];
    NSArray * pressImage  = @[@"login_wechat_press",@"login_weibo_press",@"login_qq_press"];
    
    CGFloat btnWidth = 36;
    CGFloat spacing  = 39;
    CGFloat xw = 36*3+39*2;
    
    for (int i = 0 ; i<3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(otherLoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake((KScreenWidth-xw)/2+(36+spacing)*i, KScreenHeight-86, btnWidth, btnWidth);
        [btn setImage:[UIImage imageNamed:normalImage[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:pressImage[i]] forState:UIControlStateSelected];
 
        [self.view addSubview:btn];
    }
}

- (void)textFieldDidChange:(id)sender {
    
    
    if (self.accoutTextField.text.length&&[self.passwordTextField.text isValidPassword])
    {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = kThemeColor;
        
    }else
    {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = [kThemeColor colorWithAlphaComponent:0.3];
    }
    

}


-(void)showPassWord:(UIButton*)sender
{
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    
    if (self.passwordTextField.secureTextEntry) {
    
        [self.showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
    }else
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"login_password_open"] forState:UIControlStateNormal];
        
    }
}

-(void)loginButtonClick:(UIButton*)sender
{

    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory userLoginUserName:self.accoutTextField.text
                                                                    passwoed:self.passwordTextField.text
                                                                     captcha:nil];

    request.requestSuccess = ^(id response)
    {

        [DNSession sharedSession].userAccount = self.accoutTextField.text;
        
        
        DLJSONObject *object = response;
        
        NSInteger resultCode = [object getInteger:@"errno"];
        [DNSession sharedSession].loginServerTime = [object getLong:@"time"];
        
        DLJSONObject *resultData = [object getJSONObject:@"data"];
        
        [DNSession sharedSession].uid  = [resultData getString:@"uid"];
        
        [DNSession sharedSession].token = [resultData getString:@"token"];
        
        [DNSession sharedSession].birthday = [resultData getString:@"birth"];
        
        [DNSession sharedSession].avatar  = [resultData getString:@"avatar"];
        
        [DNSession sharedSession].nickname = [resultData getString:@"nickname"];
        
        [DNSession sharedSession].sex  = [resultData getString:@"gender"];
        
        [self cheakIsVip];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DNUserInfoChange" object:nil];
        
        
        if (0 == resultCode) {
 

            if ([[resultData getString:@"channel"] length]) {
                [DNSession sharedSession].channel = [resultData getString:@"channel"];
            }else{
                [DNSession sharedSession].channel = @"0";
            }
        

                [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
    };
    
    request.requestFaile = ^(NSError *error)
    {
        // 登录请求失败
        if (error.code == 1001) {
            
            [[UIApplication sharedApplication].keyWindow makeToast:@"您输入账号或者密码错误"                                                          duration:1.5
                                                          position:CSToastPositionCenter];
            
            
        }else if (error.code == 1114)
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"您输入账号或者密码错误"
                                                          duration:1.5
                                                          position:CSToastPositionCenter];
        }else if (error.code == 1301)
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"您输入账号或者密码错误"
                                                          duration:1.5
                                                          position:CSToastPositionCenter];
            
        }else
        {
            NSString *str = [error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
            
            if (!str) return;
            
            [[UIApplication sharedApplication].keyWindow makeToast:str
                                                          duration:1.5
                                                          position:CSToastPositionCenter];
            
        }
        
        // 登录失败
     
        
    };
    
    [request excute];
    
}


-(void)cheakIsVip
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory checkIsVip];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        NSString * isvip = [dataObject getString:@"isvip"];
        
        [DNSession sharedSession].vip = ([isvip isEqualToString:@"Y"])?YES:NO;
        
        NSString * state = ([isvip isEqualToString:@"Y"])?@"1":@"0";
        
        NSDictionary * dict =[NSDictionary dictionaryWithObjectsAndKeys:state,@"state", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DNRefreshVipState" object:dict];
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
}


-(void)forgetButtonClick:(UIButton*)sender
{
    if ([self.accoutTextField.text isValidEmail]) {
        
        DNEmailViewController * emailVc = [DNEmailViewController viewController];
        emailVc.email = self.accoutTextField.text;
        [self.navigationController pushViewController:emailVc animated:YES];
        
    }else
    {
        DNPhoneInputViewController * phoneInputVc = [DNPhoneInputViewController viewController];
        phoneInputVc.enterType = forgetPassWord;
        [self.navigationController pushViewController:phoneInputVc animated:YES];
    }
    
}

-(void)registerButtonClick:(UIButton*)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");

        
    }];
    
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"手机注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        
        DNPhoneInputViewController * phoneInputVc = [DNPhoneInputViewController viewController];
        phoneInputVc.enterType = phoneRegister;
        [self.navigationController pushViewController:phoneInputVc animated:YES];
    }];
    
    UIAlertAction *emailAction = [UIAlertAction actionWithTitle:@"邮箱注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        
        DNEmailRegisterViewController * emailRegisterVc = [DNEmailRegisterViewController viewController];
        [self.navigationController pushViewController:emailRegisterVc animated:YES];
    }];
    
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [phoneAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [emailAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:phoneAction];
    [alertController addAction:emailAction];

    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)otherLoginButtonClick:(UIButton*)sender
{
    UIButton * btn = (UIButton*)sender;
    [DNThirdLoginManager shareInstance].viewController = self;
    
    switch (btn.tag) {
        case 1000:
        {
            [[DNThirdLoginManager shareInstance]threeLoginWithPlatform:SSDKPlatformTypeWechat];
            
        }
            break;
            case 1001:
        {
            [[DNThirdLoginManager shareInstance]threeLoginWithPlatform:SSDKPlatformTypeSinaWeibo];
        }
            break;
            case 1002:
        {
            [[DNThirdLoginManager shareInstance]threeLoginWithPlatform:SSDKPlatformTypeQQ];
        }
            break;
 
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(UILabel*)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 66+64, 35, 21)];
        _accountLabel.text = @"账号";
        _accountLabel.textAlignment = NSTextAlignmentLeft;
        _accountLabel.textColor = [UIColor blackColor];
        _accountLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
    }
    return _accountLabel;
}

-(UILabel*)passwordLabel
{
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 148+64, 35, 21)];
        _passwordLabel.text = @"密码";
        _passwordLabel.textAlignment = NSTextAlignmentLeft;
        _passwordLabel.textColor = [UIColor blackColor];
        _passwordLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
    }
    return _passwordLabel;
}

-(DNTextField*)accoutTextField
{
    if (!_accoutTextField) {
        _accoutTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,66+54, KScreenWidth-130,40)];
        _accoutTextField.placeholder = @"ID/邮箱/手机号";
        _accoutTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accoutTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _accoutTextField.keyboardType = UIKeyboardTypeDefault;
        _accoutTextField.returnKeyType = UIReturnKeyDefault;
        _accoutTextField.delegate = self;
        _accoutTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _accoutTextField.textColor = [UIColor blackColor];
        _accoutTextField.tintColor = kThemeColor;
        [_accoutTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        if (IsStrEmpty([DNSession sharedSession].userAccount)==NO) {
            _accoutTextField.text = [DNSession sharedSession].userAccount;
        }
    }
    return _accoutTextField;
    
}
-(DNTextField*)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,148+54,KScreenWidth-160,40)];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.returnKeyType = UIReturnKeyDefault;
        _passwordTextField.delegate = self;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.textColor = [UIColor blackColor];
        _passwordTextField.tintColor = kThemeColor;
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
  
    }
    return _passwordTextField;
    
}

-(UIButton*)showPasswordButton
{
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPasswordButton.frame= CGRectMake(KScreenWidth-79,200, 40, 40);
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
        [_showPasswordButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

-(UIView*)linea
{
    if (!_linea) {
        _linea = [[UIView alloc]initWithFrame:CGRectMake(80,96+64,KScreenWidth-130,1)];
        _linea.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
    }
    return _linea;
}

-(UIView*)lineb
{
    if (!_lineb) {
        _lineb = [[UIView alloc]initWithFrame:CGRectMake(80,176+64,KScreenWidth-130,1)];
        _lineb.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
    }
    return _lineb;
}

-(UIButton*)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame= CGRectMake(38, 290, KScreenWidth-76, 36);
        _loginButton.layer.cornerRadius = 18;
        _loginButton.backgroundColor = kThemeColor;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton*)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(38, 346, KScreenWidth-76, 36);
        _registerButton.layer.borderWidth = 1;
        _registerButton.layer.borderColor = kThemeColor.CGColor;
        _registerButton.layer.cornerRadius = 18;
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerButton;
}


-(UIUnderlinedButton*)forgetButton
{
    if (!_forgetButton) {
        _forgetButton = [UIUnderlinedButton underlinedButton];
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:12];
        _forgetButton.frame = CGRectMake(KScreenWidth/2-25, CGRectGetMaxY(self.registerButton.frame)+10, 50, 34);
        [_forgetButton addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

-(UILabel*)otherLoginLabel
{
    if (!_otherLoginLabel) {
        _otherLoginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight-108-21, KScreenWidth, 21)];
        _otherLoginLabel.text = @"其他登录方式";
        _otherLoginLabel.textColor = [UIColor customColorWithString:@"999999"];
        _otherLoginLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _otherLoginLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _otherLoginLabel;
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
