//
//  DNValidationViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/18.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNValidationViewController.h"
#import "DNChangePasswordViewController.h"
#import "DNTextField.h"
@interface DNValidationViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel * infoLabel;

@property(nonatomic,strong)UIImageView * validationImageView;

@property(nonatomic,strong)DNTextField * validationTextField;

@property(nonatomic,strong)UIView * line;

@property(nonatomic,strong)UIButton * countdownButton;

@property(nonatomic,strong)UIButton * nextBtn;

@end

@implementation DNValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
    [self startTime];
    [self validationChange];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.infoLabel.text = [NSString stringWithFormat:@"验证码已传送至您的手机\n%@ %@",self.countryCode,self.phoneNumber];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self setNavTitle:@"验证"];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.validationImageView];
    [self.view addSubview:self.validationTextField];
    [self.view addSubview:self.line];
    [self.view addSubview:self.countdownButton];
    [self.view addSubview:self.nextBtn];
    
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
    
    if (self.validationTextField .text.length)
    {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = kThemeColor;
        
    }else
    {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = [kThemeColor colorWithAlphaComponent:0.3];

    }
    
}


-(void)nextBtnClick:(UIButton*)sender
{
    DNChangePasswordViewController * changePassWordVc = [DNChangePasswordViewController viewController];
    changePassWordVc.phoneNumber = self.phoneNumber;
    changePassWordVc.countryCode = self.countryCode;
    changePassWordVc.code  = self.validationTextField.text;
    [self.navigationController pushViewController:changePassWordVc animated:YES];
}

-(void)countdownButtonClick:(UIButton*)sender
{
    [self startTime];

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
        _validationTextField = [[DNTextField alloc]initWithFrame:CGRectMake(80,151 , KScreenWidth-190,40)];
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


-(UIView*)line
{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(80, 194, KScreenWidth-130, 1)];
        _line.backgroundColor = [UIColor customColorWithString:@"eeeeee"];
        
    }
    return _line;
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
