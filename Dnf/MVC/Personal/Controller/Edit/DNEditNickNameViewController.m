//
//  DNEditNickNameViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/14.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNEditNickNameViewController.h"

@interface DNEditNickNameViewController ()

@end

@implementation DNEditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"昵称"];
    [self setupViews];
 
}

-(void)setupViews
{
    
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.textFieldBackground];
    
    self.inputTextField.text = [DNSession sharedSession].nickname;
    
    [self editTextChange];
}

-(UIView*)textFieldBackground
{
    if (!_textFieldBackground) {
        _textFieldBackground = [[UIView alloc]init];
        _textFieldBackground.frame = CGRectMake(0, 74, KScreenWidth, 60);
        _textFieldBackground.backgroundColor = [UIColor whiteColor];
        _textFieldBackground.layer.cornerRadius = 2;
        _textFieldBackground.layer.borderWidth = 0.5;
        _textFieldBackground.layer.borderColor = HexRGBAlpha(0xfffefe, .5).CGColor;
        [_textFieldBackground addSubview:self.inputTextField];
    }
    return _textFieldBackground;
}


-(UITextField*)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(20,20, KScreenWidth-40,20)];
        _inputTextField.placeholder = @"请输入昵称";
        _inputTextField.font = [UIFont fontWithName:TextFontName_Light size:16];
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
        _inputTextField.returnKeyType = UIReturnKeyDone;
        _inputTextField.delegate = self;
        _inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTextField.textColor = [UIColor blackColor];
        _inputTextField.tintColor = [UIColor customColorWithString:@"1495eb"];
        
        [_inputTextField addTarget:self action:@selector(editTextChange) forControlEvents:UIControlEventEditingChanged];
        
        [_inputTextField becomeFirstResponder];
        
    }
    return _inputTextField;
    
}

-(void)editTextChange
{
   
    
    if (IsStrEmpty(self.inputTextField.text)) {
        self.rightButton.layer.opacity = 0.5;
        self.rightButton.userInteractionEnabled = NO;
    }else
    {
        self.rightButton.layer.opacity = 1;
        self.rightButton.userInteractionEnabled = YES;
    }

}

#pragma  save methods
-(void)saveButtonClick:(UIButton*)sender
{
     [self updateUserInfo];
 
}

-(void)backEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma textViewDelegate
-(NSString *)removespace:(UITextField *)textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextField resignFirstResponder];
    [self updateUserInfo];
    
    return YES;
    
}
-(void)updateUserInfo
{
    
    [[DNSession sharedSession] setNickname:self.inputTextField.text];
    
    self.block(self.inputTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
    
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
