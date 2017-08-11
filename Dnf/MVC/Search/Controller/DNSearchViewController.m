//
//  DNSearchViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSearchViewController.h"

@interface DNSearchViewController ()

@end

@implementation DNSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    
    [self.customNavigationBar addSubview:self.searchTextField];
    
    [self.customNavigationBar addSubview:self.cancleButton];
    
    UISwipeGestureRecognizer *swipeGestureTop = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureTop.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureTop];
    

}


-(void)swipeGesture:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        
        [self.searchTextField resignFirstResponder];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //用来区分点击搜索和模糊搜索
    [_searchTextField resignFirstResponder];
    [self startSearch:textField.text];
    
    return YES;
}

-(void)startSearch:(NSString*)keyword
{
    NSString * searchUrl = MainUrl(@"search");

   
}
-(UIImageView*)searchImageView
{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc]init];
        _searchImageView.frame = CGRectMake(9,9, 14, 14);
        
        _searchImageView.image = [UIImage imageNamed:@"search_icon"];
    }
    return _searchImageView;
}

-(UIButton*)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(KScreenWidth-62, 22, 60, 40);
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:14];
        [_cancleButton addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

-(UITextField*)searchTextField
{
    if (!_searchTextField) {
        _searchTextField                    = [[UITextField alloc] init];
        _searchTextField.backgroundColor     = [UIColor whiteColor];
        _searchTextField.frame = CGRectMake(47, 26, KScreenWidth-47-64, 32);
        _searchTextField.layer.cornerRadius  = 16;
        _searchTextField.layer.shadowColor = [UIColor customColorWithString:@"38528a"].CGColor;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.placeholder = @"搜索";
        _searchTextField.delegate = self;
        _searchTextField.font = [UIFont fontWithName:TextFontName size:14];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];

        [leftView addSubview:self.searchImageView];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;

 
    }
    return _searchTextField;
    

}

-(void)backEvent
{
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
