//
//  DNPlayerViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPlayerViewController.h"

@interface DNPlayerViewController ()


@end

@implementation DNPlayerViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 
    [self.videoController dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self playVideo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:YES];
    [self setupUI];

}

-(void)setupUI
{
    [self setTabBarHide:YES];
    
    [self.view addSubview:self.videoInfoView];
    
    CGFloat y = KScreenWidth*(9.0/16.0)+110;
    self.webView.frame = CGRectMake(0, y, KScreenWidth, KScreenHeight-y);
    
    self.url = @"http://www.baidu.com";
}

-(void)playVideo{
    NSURL *url = [NSURL URLWithString:@"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4"];
    [self addVideoPlayerWithURL:url];
}

-(void)addVideoPlayerWithURL:(NSURL *)url{
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
    [self.videoController showInView:self
         .view];
    self.videoController.contentURL = url;
    
    [self.videoController.videoControl.closeButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backButtonClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)openButtonClick:(UIButton*)sender
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"VIP购买" message:@"非VIP用户，无法查看以下内容\n请购买VIP后再来观看" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        DNTopUpViewController * topupVC = [DNTopUpViewController viewController];
        [self.navigationController pushViewController:topupVC animated:YES];
        
    }];
    
    [otherAction setValue:kThemeColor forKey:@"_titleTextColor"];

    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}


-(void)collectButtonClick:(UIButton*)sender
{
    NSLog(@"collection");
    self.videoInfoView.collection = !self.videoInfoView.collection;
}

-(void)shareButtonClick:(UIButton*)sender
{
    NSLog(@"share");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        DNTopUpViewController * topUp = [DNTopUpViewController viewController];
        [self.navigationController pushViewController:topUp animated:YES];
    }
}


-(DNVideoInfoView*)videoInfoView
{
    if (!_videoInfoView) {
    
        _videoInfoView = [[DNVideoInfoView alloc]init];
        
        [_videoInfoView.openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView.collectionButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoInfoView;
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
