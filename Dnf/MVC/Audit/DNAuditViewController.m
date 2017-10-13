//
//  DNAuditViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/8.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNAuditViewController.h"

#import "DNSearchViewController.h"
#import "DNLoginViewController.h"
@interface DNAuditViewController ()

@property(nonatomic,strong)UIImageView * navlogoView;
@end

@implementation DNAuditViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.url = MainUrl(@"green");
    [self setupUI];
}

-(void)setupUI
{
    [self.customNavigationBar addSubview:self.navlogoView];

    [self.leftButton setImage:[UIImage imageNamed:@"nav_menu_normal"] forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64);
}



-(void)leftButtonClick:(UIButton*)sender
{
    [self.xl_sldeMenu showLeftViewControllerAnimated:true];

}



-(UIImageView*)navlogoView
{
    if (!_navlogoView) {
        _navlogoView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-36,32, 72, 20)];
        _navlogoView.image = [UIImage imageNamed:@"nav_logo"];
    }
    return _navlogoView;
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
