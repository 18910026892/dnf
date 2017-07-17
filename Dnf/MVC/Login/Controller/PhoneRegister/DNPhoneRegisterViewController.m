//
//  DNPhoneRegisterViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPhoneRegisterViewController.h"
#import "DNChosseCountryViewController.h"
#import "DNTextField.h"
@interface DNPhoneRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView * linea,*lineb;
@property (strong, nonatomic) UILabel *noticeLbl;
@property (strong, nonatomic) UIImageView * phoneImageView;
@property (strong, nonatomic) UIButton *countryBtn;
@property (strong, nonatomic) UILabel *countryNum;
@property (strong, nonatomic) UITextField *phone;
@property (strong, nonatomic) UILabel *infoLbl;
@property (strong, nonatomic) UIButton *nextBtn;
@property (strong,nonatomic)DNTextField * phoneTextField;
@end

@implementation DNPhoneRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self setNavTitle:@"使用手机注册"];
    [self.view addSubview:self.noticeLbl];
    [self.view addSubview:self.phoneImageView];
    [self.view addSubview:self.countryBtn];
    [self.view addSubview:self.countryNum];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.linea];
    [self.view addSubview:self.lineb];
    [self.view addSubview:self.infoLbl];
    [self.view addSubview:self.nextBtn];
    
}

-(void)nextButtonClick:(UIButton*)sender
{
    
}
-(void)countryButtonClick:(UIButton*)sender
{
    DNChosseCountryViewController *vc = [[DNChosseCountryViewController alloc] init];
    __weak typeof(self) wself = self;
    __weak typeof(vc) wvc = vc;
    vc.selectBlock = ^(NSString * num)
    {
        wself.countryNum.text = num;
        if ([num isEqualToString:@"+86"]) {
            [wself.countryBtn setTitle:@"CN" forState:UIControlStateNormal];
            
        }else{
            [wself.countryBtn setTitle:@"VI" forState:UIControlStateNormal];
        }
        
        
        [wvc dismissViewControllerAnimated:YES completion:nil];
        
    };
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


-(DNTextField*)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[DNTextField alloc]initWithFrame:CGRectMake(178.5,158, KScreenWidth-178.5-50,27)];
        _phoneTextField.placeholder = @"手机号";
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.returnKeyType = UIReturnKeyDefault;
        _phoneTextField.delegate = self;
        _phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phoneTextField.textColor = [UIColor blackColor];

    }
    return _phoneTextField;
    
}

-(UILabel*)noticeLbl
{
    if (!_noticeLbl) {
        _noticeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 37+64, KScreenWidth, 24)];
        _noticeLbl.textColor = [UIColor customColorWithString:@"999999"];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        _noticeLbl.font = [UIFont fontWithName:TextFontName_Light size:17];
        _noticeLbl.text = @"请输入您的手机号";
    }
    return _noticeLbl;
}

-(UIImageView*)phoneImageView
{
    if (!_phoneImageView) {
        _phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 64+94, 25, 25)];
        _phoneImageView.image = [UIImage imageNamed:@"login_phone_icon"];
    }
    return _phoneImageView;
}

-(UIButton*)countryBtn
{
    if (!_countryBtn) {
        _countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryBtn.frame = CGRectMake(75, 150, 45, 40);
        [_countryBtn setTitle:@"CN" forState:UIControlStateNormal];
        [_countryBtn setTitleColor:[UIColor customColorWithString:@"262626"] forState:UIControlStateNormal];
        _countryBtn.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        [_countryBtn setImage:[UIImage imageNamed:@"login_dropdown_icon"] forState:UIControlStateNormal];
        [_countryBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_countryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
        [_countryBtn addTarget:self action:@selector(countryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countryBtn;
}

-(UILabel*)countryNum
{
    if (!_countryNum) {
        _countryNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.countryBtn.frame), 160, 40, 21)];
        _countryNum.text = @"+86";
        _countryNum.textColor = [UIColor blackColor];
        _countryNum.font = [UIFont fontWithName:TextFontName_Light size:15];
    }
    return _countryNum;
}


-(UIView*)linea
{
    if (!_linea) {
        _linea = [[UIView alloc]initWithFrame:CGRectMake(80, 194, KScreenWidth-130, 1)];
        _linea.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
        
    }
    return _linea;
}

-(UIView*)lineb
{
    if (!_lineb) {
        _lineb = [[UIView alloc]initWithFrame:CGRectMake(165, 163, 1, 16)];
        _lineb.backgroundColor = [UIColor customColorWithString:@"262626"];
    }
    return _lineb;
}

-(UILabel*)infoLbl
{
    if (!_infoLbl) {
        _infoLbl = [[UILabel alloc]initWithFrame:CGRectMake(78, 138+64, 124, 17)];
        _infoLbl.text = @"您的手机号码不会泄漏";
        _infoLbl.textColor = [UIColor customColorWithString:@"a5a7aa"];
        _infoLbl.font = [UIFont fontWithName:TextFontName_Light size:12];
        
    }
    return _infoLbl;
}

-(UIButton*)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.backgroundColor = kThemeColor;
        _nextBtn.frame = CGRectMake(38, 264, KScreenWidth-76, 36);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:16];
        _nextBtn.layer.cornerRadius = 18;
        
        
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
