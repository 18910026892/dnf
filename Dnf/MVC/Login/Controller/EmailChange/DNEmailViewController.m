//
//  DNEmailViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/19.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNEmailViewController.h"
#import "DNTextField.h"
@interface DNEmailViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel * infoLabel;

@property(nonatomic,strong)UIImageView * validationImageView;

@property(nonatomic,strong)DNTextField * validationTextField;

@property(nonatomic,strong)UIButton * countdownButton;

@property(nonatomic,strong)UIImageView * passwordImageView;

@property(nonatomic,strong)DNTextField * passWordTextField;

@property(nonatomic,strong)UILabel * promptLabel;

@property(nonatomic,strong)UIButton * showPasswordButton;

@property(nonatomic,strong)UIButton * nextBtn;

@end

@implementation DNEmailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
    [self validationChange];
    [self countdownButtonClick:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.infoLabel.text = [NSString stringWithFormat:@"验证码已传送至您的邮箱\n%@",self.email];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self setNavTitle:@"密码重置"];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.validationImageView];
    [self.view addSubview:self.validationTextField];
    [self.view addSubview:self.countdownButton];
    [self.view addSubview:self.passwordImageView];
    [self.view addSubview:self.passWordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.promptLabel];
    [self initLines];
    
}

-(void)initLines
{
    for (int i=0; i<2; i++) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(80, 200+i*80, KScreenWidth-130, 0.5)];
        lineView.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
        [self.view addSubview:lineView];
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

-(void)nextButtonClick:(UIButton*)sender
{
 
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory resetPassWordUserName:self.email
                                                                        passWord:self.passWordTextField.text
                                                                            code:self.validationTextField.text
                                                                            weak:nil];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        NSInteger resultCode = [object getInteger:@"errno"];
        
        if (0 == resultCode) {
            
              [[UIApplication sharedApplication].keyWindow makeToast:@"修改成功" duration:1.5 position:CSToastPositionCenter];
              [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
        
    };
    [request excute];
    
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

-(void)validationChange {
    
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


-(void)countdownButtonClick:(UIButton*)sender
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getEmailCodeWithEmail:self.email
                                                                            type:@"forgot"];
    request.requestSuccess = ^(id response)
    {
        
        [self startTime];
     
    };
    request.requestFaile = ^(NSError *error)
    {
        
    };
    [request excute];

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
        _validationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 168, 25, 25)];
        _validationImageView.image = [UIImage imageNamed:@"login_validation_icon"];
    }
    return _validationImageView;
}


-(DNTextField*)validationTextField
{
    if (!_validationTextField) {
        _validationTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,163, KScreenWidth-190,40)];
        _validationTextField.placeholder = @"验证码";
        _validationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _validationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _validationTextField.returnKeyType = UIReturnKeyDefault;
        _validationTextField.delegate = self;
        _validationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _validationTextField.textColor = [UIColor blackColor];
        [_validationTextField addTarget:self action:@selector(validationChange) forControlEvents:UIControlEventEditingChanged];
        [_validationTextField becomeFirstResponder];
        
    }
    return _validationTextField;
    
}

-(UIImageView*)passwordImageView
{
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 248, 25, 25)];
        _passwordImageView.image = [UIImage imageNamed:@"login_password_icon"];
        
    }
    return _passwordImageView;
}

-(DNTextField*)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,243, KScreenWidth-160,40)];
        _passWordTextField.placeholder = @"密码";
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passWordTextField.keyboardType = UIKeyboardTypeDefault;
        _passWordTextField.returnKeyType = UIReturnKeyDefault;
        _passWordTextField.delegate = self;
        _passWordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passWordTextField.textColor = [UIColor blackColor];
        _passWordTextField.secureTextEntry = YES;
         [_passWordTextField addTarget:self action:@selector(validationChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _passWordTextField;
    
}
-(UIButton*)showPasswordButton
{
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPasswordButton.frame= CGRectMake(KScreenWidth-79,243, 40, 40);
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
        [_showPasswordButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}


-(UIButton*)countdownButton
{
    if (!_countdownButton) {
        _countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countdownButton.frame = CGRectMake(KScreenWidth-47-62, 160, 62, 40);
        [_countdownButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        _countdownButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        [_countdownButton addTarget:self action:@selector(countdownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countdownButton;
}

-(UILabel*)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 285, KScreenWidth-100, 16)];
        _promptLabel.text = @"密码长度为6至20个字";
        _promptLabel.font = [UIFont fontWithName:TextFontName_Light size:12];
        _promptLabel.textColor = [UIColor customColorWithString:@"999999"];
    }
    return _promptLabel;
}


-(UIButton*)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.backgroundColor = kThemeColor;
        _nextBtn.frame = CGRectMake(38, 327, KScreenWidth-76, 36);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        _nextBtn.layer.cornerRadius = 18;
        [_nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _nextBtn;
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
