//
//  DNEmailRegisterViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNEmailRegisterViewController.h"
#import "DNTextField.h"
@interface DNEmailRegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView * emailImageView;

@property(nonatomic,strong)DNTextField * emailTextField;

@property(nonatomic,strong)UIImageView * validationImageView;

@property(nonatomic,strong)DNTextField * validationTextField;

@property(nonatomic,strong)UIButton    *countdownButton;

@property(nonatomic,strong)UIImageView * passwordImageView;

@property(nonatomic,strong)DNTextField * passWordTextField;

@property(nonatomic,strong)UIButton * showPasswordButton;

@property(nonatomic,strong)UIImageView * accountImageView;

@property(nonatomic,strong)DNTextField * nickNameTextField;

@property(nonatomic,strong)UIButton * nextBtn;

@end

@implementation DNEmailRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self setNavTitle:@"使用电子邮箱注册"];
    
    [self.view addSubview:self.emailImageView];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.validationImageView];
    [self.view addSubview:self.validationTextField];
    [self.view addSubview:self.countdownButton];
    [self.view addSubview:self.passwordImageView];
    [self.view addSubview:self.passWordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.accountImageView];
    [self.view addSubview:self.nextBtn];
    

}

-(UIImageView*)emailImageView
{
    if (!_emailImageView) {
        _emailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(46, 127, 20, 16)];
        _emailImageView.image = [UIImage imageNamed:@"login_email"];
    }
    return _emailImageView;
}

-(DNTextField*)emailTextField
{
    if (!_emailTextField) {
        _emailTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,122, KScreenWidth-130,27)];
        _emailTextField.placeholder = @"请输入您的电子邮箱地址";
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.keyboardType = UIKeyboardTypeDefault;
        _emailTextField.returnKeyType = UIReturnKeyDefault;
        _emailTextField.delegate = self;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.textColor = [UIColor blackColor];
    
    }
    return _emailTextField;
}


-(UIImageView*)validationImageView
{
    if (!_validationImageView) {
        _validationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 208, 25, 25)];
        _validationImageView.image = [UIImage imageNamed:@"login_validation_icon"];
    }
    return _validationImageView;
}


-(DNTextField*)validationTextField
{
    if (!_validationTextField) {
        _validationTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,209, KScreenWidth-180,27)];
        _validationTextField.placeholder = @"验证码";
        _validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _validationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _validationTextField.returnKeyType = UIReturnKeyDefault;
        _validationTextField.delegate = self;
        _validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _validationTextField.textColor = [UIColor blackColor];
        [_validationTextField addTarget:self action:@selector(validationChange) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _validationTextField;
    
}



-(UIButton*)countdownButton
{
    if (!_countdownButton) {
        _countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countdownButton.frame = CGRectMake(KScreenWidth-47-62, 200, 62, 40);
        [_countdownButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        _countdownButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        [_countdownButton addTarget:self action:@selector(countdownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countdownButton;
}



-(UIImageView*)passwordImageView
{
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 288, 25, 25)];
        _passwordImageView.image = [UIImage imageNamed:@"login_password_icon"];
        
    }
    return _passwordImageView;
}

-(DNTextField*)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,287, KScreenWidth-150,27)];
        _passWordTextField.placeholder = @"密码";
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passWordTextField.keyboardType = UIKeyboardTypeDefault;
        _passWordTextField.returnKeyType = UIReturnKeyDefault;
        _passWordTextField.delegate = self;
        _passWordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passWordTextField.textColor = [UIColor blackColor];
        _passWordTextField.secureTextEntry = YES;
        
    }
    return _passWordTextField;
    
}

-(UIButton*)showPasswordButton
{
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPasswordButton.frame= CGRectMake(KScreenWidth-79,368, 40, 40);
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
        [_showPasswordButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

-(UIImageView*)accountImageView
{
    if (!_accountImageView) {
        _accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 327, 25, 25)];
        _accountImageView.image = [UIImage imageNamed:@"login_profile_icon"];
    }
    return _accountImageView;
}

-(DNTextField*)nickNameTextField
{
    if (!_nickNameTextField) {
        _nickNameTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,367, KScreenWidth-130,27)];
        _nickNameTextField.placeholder =@"昵称 (长度为3至20个字)";
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


-(UIButton*)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.backgroundColor = kThemeColor;
        _nextBtn.frame = CGRectMake(38, 451, KScreenWidth-76, 36);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        _nextBtn.layer.cornerRadius = 18;
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _nextBtn;
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
