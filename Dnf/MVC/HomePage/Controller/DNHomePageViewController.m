//
//  DNHomePageViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNHomePageViewController.h"
#import "DNPlayerViewController.h"
@interface DNHomePageViewController ()

@end

@implementation DNHomePageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabBarHide:NO];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.url = @"http://www.baidu.com";

    [self setupUI];
}

-(void)setupUI;
{
    [self setNavTitle:@"大妞范"];
    
    [self.rightButton setImage:[UIImage imageNamed:@"nav_search_normal"] forState:UIControlStateNormal];
    
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.leftButton setImage:[UIImage imageNamed:@"nav_menu_normal"] forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)rightButtonClick:(UIButton*)sender
{
//    DNSearchViewController * searchVc = [DNSearchViewController viewController];
//    [self.navigationController pushViewController:searchVc animated:YES];
    
    DNPlayerViewController * playerVc = [DNPlayerViewController viewController];
    [self.navigationController pushViewController:playerVc animated:YES];
    
}

-(void)leftButtonClick:(UIButton*)sender
{
    
     [self.xl_sldeMenu showLeftViewControllerAnimated:true];
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
