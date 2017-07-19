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
    [self textFieldDidChange:nil];
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
    [self.view addSubview:self.nickNameTextField];
    [self.view addSubview:self.nextBtn];
    
    [self initLines];

}
-(void)initLines
{
    for (int i=0; i<4; i++) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(80, 160+i*80, KScreenWidth-130, 0.5)];
        lineView.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
        [self.view addSubview:lineView];
    }
}

- (void)textFieldDidChange:(id)sender  {
    
    if (self.emailTextField.text.length&&self.validationTextField.text.length&&self.passWordTextField.text.length&&self.nickNameTextField)
    {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = kThemeColor;
        
    }else
    {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = [kThemeColor colorWithAlphaComponent:0.3];
        
    }
    
}


-(void)showPassWord:(UIButton*)sender
{
    self.passWordTextField.secureTextEntry = !self.passWordTextField.secureTextEntry;
    
    if (self.passWordTextField.secureTextEntry) {
        
        [self.showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
    }else
    {
        [self.showPasswordButton setImage:[UIImage imageNamed:@"login_password_open"] forState:UIControlStateNormal];
        
    }
}




-(void)countdownButtonClick:(UIButton*)sender
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.countdownButton setTitle:@"重新发送" forState:UIControlStateNormal];
                
                self.countdownButton.userInteractionEnabled = YES;
                [self.countdownButton setTitleColor:[UIColor customColorWithString:@"3897f0"] forState:UIControlStateNormal];
                
                
            });
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.countdownButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.countdownButton.userInteractionEnabled = NO;
                [self.countdownButton setTitleColor:[UIColor customColorWithString:@"262626"] forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);

}

-(void)nextBtnClick:(UIButton*)sender
{
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(UIImageView*)emailImageView
{
    if (!_emailImageView) {
        _emailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(46, 125, 25, 25)];
        _emailImageView.image = [UIImage imageNamed:@"login_mail"];
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
        [_emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
        _validationTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,209, KScreenWidth-200,27)];
        _validationTextField.placeholder = @"验证码";
        _validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _validationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _validationTextField.returnKeyType = UIReturnKeyDefault;
        _validationTextField.delegate = self;
        _validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _validationTextField.textColor = [UIColor blackColor];
        [_validationTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     
        
    }
    return _validationTextField;
    
}


-(UIButton*)countdownButton
{
    if (!_countdownButton) {
        _countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countdownButton.frame = CGRectMake(KScreenWidth-124, 200, 77, 40);
        [_countdownButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        _countdownButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        [_countdownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countdownButton setTitleColor:[UIColor customColorWithString:@"3897F0"] forState:UIControlStateNormal];
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
        [_passWordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _passWordTextField;
    
}

-(UIButton*)showPasswordButton
{
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPasswordButton.frame= CGRectMake(KScreenWidth-79,281, 40, 40);
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
        [_showPasswordButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

-(UIImageView*)accountImageView
{
    if (!_accountImageView) {
        _accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 368, 25, 25)];
        _accountImageView.image = [UIImage imageNamed:@"login_profile_icon"];
    }
    return _accountImageView;
}

-(DNTextField*)nickNameTextField
{
    if (!_nickNameTextField) {
        _nickNameTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,367, KScreenWidth-130,27)];
        _nickNameTextField.placeholder =@"昵称 (长度为3至8个字)";
        _nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nickNameTextField.keyboardType = UIKeyboardTypeDefault;
        _nickNameTextField.returnKeyType = UIReturnKeyDefault;
        _nickNameTextField.delegate = self;
        _nickNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _nickNameTextField.textColor = [UIColor blackColor];
        [_nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
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
