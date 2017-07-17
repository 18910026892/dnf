//
//  DNLoginViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNLoginViewController.h"
#import "UIUnderlinedButton.h"
#import "DNTextField.h"
#import "DNPhoneRegisterViewController.h"
#import "DNEmailRegisterViewController.h"
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

-(void)loginButtonClick:(UIButton*)sender
{
    
}

-(void)forgetButtonClick:(UIButton*)sender
{
    
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
        
        DNPhoneRegisterViewController * phoneRegisterVc = [DNPhoneRegisterViewController viewController];
        [self.navigationController pushViewController:phoneRegisterVc animated:YES];
    }];
    
    UIAlertAction *emailAction = [UIAlertAction actionWithTitle:@"邮箱注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        
        DNEmailRegisterViewController * emailRegisterVc = [DNEmailRegisterViewController viewController];
        [self.navigationController pushViewController:emailRegisterVc animated:YES];
    }];
    
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:phoneAction];
    [alertController addAction:emailAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)otherLoginButtonClick:(UIButton*)sender
{
    UIButton * btn = (UIButton*)sender;
    
    NSLog(@" btn.tag %ld",(long)btn.tag);
    
    switch (btn.tag) {
        case 1000:
        {
            
        }
            break;
            case 1001:
        {
            
        }
            break;
            case 1002:
        {
            
        }
            break;
 
        default:
            break;
    }
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
        _accoutTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,66+64, KScreenWidth-160,20)];
        _accoutTextField.placeholder = @"ID/邮箱/手机号";
        _accoutTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accoutTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _accoutTextField.keyboardType = UIKeyboardTypeDefault;
        _accoutTextField.returnKeyType = UIReturnKeyDefault;
        _accoutTextField.delegate = self;
        _accoutTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _accoutTextField.textColor = [UIColor blackColor];
        _accoutTextField.tintColor = kThemeColor;
        _accoutTextField.tag = 0;

    }
    return _accoutTextField;
    
}
-(DNTextField*)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,148+64,KScreenWidth-160,20)];
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
        _passwordTextField.tag = 1;
    
  
    }
    return _passwordTextField;
    
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
