//
//  DNChangePasswordViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/18.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNChangePasswordViewController.h"
#import "DNTextField.h"
@interface DNChangePasswordViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel * infoLabel;

@property(nonatomic,strong)UIImageView * passwordImageView;

@property(nonatomic,strong)DNTextField * passWordTextField;

@property(nonatomic,strong)UILabel * promptLabel;

@property(nonatomic,strong)UIButton * showPasswordButton;

@property(nonatomic,strong)UIView * line;

@property(nonatomic,strong)UIButton * nextBtn;

@end

@implementation DNChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.infoLabel.text = [NSString stringWithFormat:@"请重新设定\n%@ %@的新密码",self.countryCode,self.phoneNumber];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self setNavTitle:@"重设密码"];
    
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.passwordImageView];
    [self.view addSubview:self.passWordTextField];
    [self.view addSubview:self.showPasswordButton];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.line];
    [self.view addSubview:self.nextBtn];
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
    [self.navigationController popToRootViewControllerAnimated:NO];
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

-(UIImageView*)passwordImageView
{
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 158, 25, 25)];
        _passwordImageView.image = [UIImage imageNamed:@"login_password_icon"];
        
    }
    return _passwordImageView;
}

-(DNTextField*)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,157, KScreenWidth-160,27)];
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
        _showPasswordButton.frame= CGRectMake(KScreenWidth-79,150, 40, 40);
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_password_close"] forState:UIControlStateNormal];
        [_showPasswordButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

-(UILabel*)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 203, KScreenWidth-100, 16)];
        _promptLabel.text = @"密码长度为6至20个字";
        _promptLabel.font = [UIFont fontWithName:TextFontName_Light size:12];
        _promptLabel.textColor = [UIColor customColorWithString:@"999999"];
    }
    return _promptLabel;
}

-(UIView*)line
{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(80, 194, KScreenWidth-130, 0.5)];
        _line.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
    }
    return _line;
}


-(UIButton*)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.backgroundColor = kThemeColor;
        _nextBtn.frame = CGRectMake(38,264, KScreenWidth-76, 36);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        _nextBtn.layer.cornerRadius = 18;
        [_nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
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
