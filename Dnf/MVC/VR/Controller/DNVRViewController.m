//
//  DNVRViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNVRViewController.h"
#import "DNSearchViewController.h"
#import "DNLoginViewController.h"
@interface DNVRViewController ()

@property(nonatomic,strong)UIImageView * navlogoView;

@end

@implementation DNVRViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.url = MainUrl(@"vr");
    [self setupUI];
}

-(void)setupUI
{
    [self.customNavigationBar addSubview:self.navlogoView];
    
    [self.rightButton setImage:[UIImage imageNamed:@"nav_search_normal"] forState:UIControlStateNormal];
    
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.leftButton setImage:[UIImage imageNamed:@"nav_menu_normal"] forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)rightButtonClick:(UIButton*)sender
{
    DNSearchViewController * searchVc = [DNSearchViewController viewController];
    [self.navigationController pushViewController:searchVc animated:YES];
    
}

-(void)leftButtonClick:(UIButton*)sender
{
    
    if ([[DNSession sharedSession] isLogin]==YES) {
        
        [self.xl_sldeMenu showLeftViewControllerAnimated:true];
        
    }else
    {
        DNLoginViewController * loginVc = [DNLoginViewController viewController];
        [self.navigationController pushViewController:loginVc animated:YES];
    }
    
    
}

-(UIImageView*)navlogoView
{
    if (!_navlogoView) {
        _navlogoView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-36,32, 72, 20)];
        _navlogoView.image = [UIImage imageNamed:@"nav_logo"];
    }
    return _navlogoView;
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
