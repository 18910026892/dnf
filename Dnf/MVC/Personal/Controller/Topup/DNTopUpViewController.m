//
//  DNTopUpViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTopUpViewController.h"
#import "DNLoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
@interface DNTopUpViewController ()

@property(nonatomic,copy)NSString * orderid;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * productid;
@end

@implementation DNTopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
    [self operationData];

}


-(void)setFormMenu:(BOOL)formMenu
{
    _formMenu = formMenu;
    
    if (formMenu==YES) {
        
        [self.leftButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)showLeft
{
    [self.xl_sldeMenu showLeftViewControllerAnimated:YES];
    
}


-(void)creatUserInterface
{
    [self setNavTitle:@"充值会员"];
    [self showBackButton:YES];
    [self.view addSubview:self.tableView];
}

-(void)operationData
{

    NSMutableArray * array = [[NSUserDefaults standardUserDefaults] valueForKey:@"kSessionProductArray"];
    
    self.dataArray = [DNTopUpModel mj_objectArrayWithKeyValuesArray:array];
    
    [self.tableView reloadData];

}

#pragma mark - Delegate 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString * cellID = @"DNTopUpTableViewCell";
    DNTopUpModel * topUpModel = self.dataArray[indexPath.row];
    DNTopUpTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DNTopUpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    cell.topUpModel = topUpModel;
    
    return cell;
    
}
-(void)didSelectPriceButton:(DNTopUpModel*)topUpModel;
{
    if ([[DNSession sharedSession] isLogin]==NO) {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录，请先完成登录" preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        }];
        
        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
            DNLoginViewController * login = [DNLoginViewController viewController];
            [self.navigationController pushViewController:login animated:YES];
            
        }];
        
        [otherAction setValue:kThemeColor forKey:@"_titleTextColor"];
        
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else
    {
        NSLog(@"购买");
        [self creatOrder:topUpModel];
        
    }
}

-(void)creatOrder:(DNTopUpModel*)topUpModel
{
    _money = [NSString stringWithFormat:@"%@",topUpModel.price];
    _productid = [NSString stringWithFormat:@"%ld",(long)topUpModel.id];
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory topUpWithSource:@"alipay" amount:_money userid:[DNSession sharedSession].token currency:@"CNY" productid:_productid];
    
    request.requestSuccess = ^(id response){
        
        
        DLJSONObject * object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        _orderid = [dataObject getString:@"orderid"];
        
        NSString * orderStr = [dataObject getString:@"alipayStr"];
        
        [self zhifubaoMethod:orderStr];
        

    };
    
    request.requestFaile = ^(NSError *error)
    {
        
        
    };
    
    [request excute];
}

#pragma mark
#pragma mark ===========AliPay=============
//支付宝
-(void)zhifubaoMethod:(NSString*)payorder;
{
    NSLog(@"调起支付宝");
    
    BOOL hadInstalledAlipay = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
    
    if (hadInstalledAlipay) {
        NSString *appScheme = @"dnfAliPay";
        

        [[AlipaySDK defaultService] payOrder:payorder fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic = %@",resultDic);
  
            [self alipayResult:resultDic];
         
        }];
    }else if (!hadInstalledAlipay)
    {
        NSLog(@"没安装支付宝");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的手机未安装支付宝客户端，请先安装" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
 
}


-(void)alipayResult:(NSDictionary*)resultDic
{
    NSString *message = @"";
    switch([[resultDic objectForKey:@"resultStatus"] integerValue])
    {
        case 9000:message = @"订单支付成功";break;
        case 8000:message = @"正在处理中";break;
        case 4000:message = @"订单支付失败";break;
        case 6001:message = @"用户中途取消";break;
        case 6002:message = @"网络连接错误";break;
        default:message = @"未知错误";

            
    }
    
    if ([[resultDic objectForKey:@"resultStatus"] integerValue] ==9000) {
        [DNSession sharedSession].vip = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DNReloadWebView" object:nil];
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];

    
    
}


-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.separatorColor = [UIColor customColorWithString:@"eeeeee"];
        
    }
    return _tableView;
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
