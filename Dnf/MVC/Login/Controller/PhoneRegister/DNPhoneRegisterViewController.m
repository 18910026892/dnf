//
//  DNPhoneRegisterViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPhoneRegisterViewController.h"
#import "DNPerfectInfoViewController.h"
#import "DNTextField.h"
@interface DNPhoneRegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel * infoLabel;

@property(nonatomic,strong)UIImageView * validationImageView;

@property(nonatomic,strong)DNTextField * validationTextField;

@property(nonatomic,strong)UIButton * countdownButton;

@property(nonatomic,strong)UIImageView * passwordImageView;

@property(nonatomic,strong)DNTextField * passWordTextField;

@property(nonatomic,strong)UILabel * promptLabel;

@property(nonatomic,strong)UIButton * showPasswordButton;

@property(nonatomic,strong)UIImageView * accountImageView;

@property(nonatomic,strong)DNTextField * nickNameTextField;

@property(nonatomic,strong)UIButton * nextBtn;

@end

@implementation DNPhoneRegisterViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUserInterface];
    [self initLines];
    [self startTime];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.infoLabel.text = [NSString stringWithFormat:@"验证码已传送至您的手机\n%@ %@",self.countryCode,self.phoneNumber];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self setNavTitle:@"使用手机号注册"];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.validationImageView];
    [self.view addSubview:self.validationTextField];
    [self.view addSubview:self.countdownButton];
    [self.view addSubview:self.passwordImageView];
    [self.view addSubview:self.passWordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.accountImageView];
    [self.view addSubview:self.nickNameTextField];
    [self.view addSubview:self.nextBtn];
    
}

-(void)initLines
{
    for (int i=0; i<3; i++) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(80, 198+i*81.5, KScreenWidth-130, 0.5)];
        lineView.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
        [self.view addSubview:lineView];
    }
}

-(void)checkRegisterInfo{
    
    if (self.validationTextField.text.length&&[self.passWordTextField.text isValidPassword])
    {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = kThemeColor;
        
    }else
    {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = [kThemeColor colorWithAlphaComponent:0.3];
        
    }
    
}
#pragma 开启时间线程
-(void)startTime{
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
    DNPerfectInfoViewController * perfectinfoVc = [DNPerfectInfoViewController viewController];
    [self.navigationController pushViewController:perfectinfoVc animated:YES];
 
}

-(void)countdownButtonClick:(UIButton*)sender
{
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(UILabel*)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 92, KScreenWidth, 48)];
        _infoLabel.textColor =[UIColor customColorWithString:@"999999"];
        _infoLabel.font = [UIFont fontWithName:TextFontName_Light size:17];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}


-(UIImageView*)validationImageView
{
    if (!_validationImageView) {
        _validationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 158, 25, 25)];
        _validationImageView.image = [UIImage imageNamed:@"login_validation_icon"];
    }
    return _validationImageView;
}


-(DNTextField*)validationTextField
{
    if (!_validationTextField) {
        _validationTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,158, KScreenWidth-150,27)];
        _validationTextField.placeholder = @"验证码";
        _validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _validationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _validationTextField.returnKeyType = UIReturnKeyDefault;
        _validationTextField.delegate = self;
        _validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _validationTextField.textColor = [UIColor blackColor];
        [_validationTextField becomeFirstResponder];
        [_validationTextField addTarget:self action:@selector(checkRegisterInfo) forControlEvents:UIControlEventEditingChanged];
        
     
    }
    return _validationTextField;
    
}

-(UIButton*)countdownButton
{
    if (!_countdownButton) {
        _countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countdownButton.frame = CGRectMake(KScreenWidth-47-62, 150, 62, 40);
        [_countdownButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        _countdownButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        [_countdownButton addTarget:self action:@selector(countdownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countdownButton;
}


-(UIImageView*)passwordImageView
{
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 247, 25, 25)];
        _passwordImageView.image = [UIImage imageNamed:@"login_password_icon"];
        
    }
    return _passwordImageView;
}

-(DNTextField*)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,246, KScreenWidth-150,27)];
        _passWordTextField.placeholder = @"密码";
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passWordTextField.keyboardType = UIKeyboardTypeDefault;
        _passWordTextField.returnKeyType = UIReturnKeyDefault;
        _passWordTextField.delegate = self;
        _passWordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passWordTextField.textColor = [UIColor blackColor];
        _passWordTextField.secureTextEntry = YES;
        [_passWordTextField addTarget:self action:@selector(checkRegisterInfo) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _passWordTextField;
    
}

-(UIButton*)showPasswordButton
{
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPasswordButton.frame= CGRectMake(KScreenWidth-79,240, 40, 40);
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
        [_showPasswordButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}


-(UILabel*)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 282, KScreenWidth-100, 16)];
        _promptLabel.text = @"密码长度为6至20个字";
        _promptLabel.font = [UIFont fontWithName:TextFontName_Light size:12];
        _promptLabel.textColor = [UIColor customColorWithString:@"999999"];
    }
    return _promptLabel;
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
        _nickNameTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,328, KScreenWidth-130,27)];
        _nickNameTextField.placeholder =@"昵称 (长度为3至8个字)";
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
        _nextBtn.frame = CGRectMake(38, CGRectGetMaxY(self.nickNameTextField.frame)+44, KScreenWidth-76, 36);
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
