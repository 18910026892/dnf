//
//  DNHomePageViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNHomePageViewController.h"

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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    [self fastlogin];
    [self getProductList];
    [self setupUI];


}


-(void)fastlogin
{
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory fastLogin:[DNSession sharedSession].token];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        NSInteger resultCode = [object getInteger:@"errno"];
        
        [DNSession sharedSession].loginServerTime = [object getLong:@"time"];
     
        
        if (0 == resultCode) {
     
            DLJSONObject *resultData = [object getJSONObject:@"data"];
       
            [DNSession sharedSession].uid  = [resultData getString:@"uid"];
            
            [DNSession sharedSession].token = [resultData getString:@"token"];
            
            [DNSession sharedSession].birthday = [resultData getString:@"birth"];
            
            [DNSession sharedSession].avatar  = [resultData getString:@"avatar"];
            
            [DNSession sharedSession].nickname = [resultData getString:@"nickname"];
            
            [DNSession sharedSession].sex  = [resultData getString:@"gender"];
            
            [DNSession sharedSession].token = [resultData getString:@"token"];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DNUserInfoChange" object:nil];
            
            //获取vip信息
           [self cheakIsVip];
            
        }else
            
        {
           
            [[DNSession sharedSession] removeUserInfo];
        }
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
        [[DNSession sharedSession] removeUserInfo];
    };
    
    [request excute];
}

-(void)cheakIsVip
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory checkIsVip];
    
    request.requestSuccess = ^(id response)
    {
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        NSString * isvip = [dataObject getString:@"isvip"];
        
        [DNSession sharedSession].vip = ([isvip isEqualToString:@"Y"])?YES:NO;
      
    };
    
    request.requestFaile   = ^(NSError *error)
    {
        
      
    };
    
    [request excute];
}


-(void)getProductList
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getProduct];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray *  productArray = [dataObject getJSONArray:@"product"];

        [[NSUserDefaults standardUserDefaults] setObject:productArray.array forKey:@"kSessionProductArray"];
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
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
