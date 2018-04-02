////
//  DNTopUpViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTopUpViewController.h"
#import "DNLoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#import <StoreKit/StoreKit.h>
@interface DNTopUpViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,SKRequestDelegate>

@property(nonatomic,copy)NSString * orderid;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * productid;
@property (nonatomic,copy)NSString * notify_url;

@property(nonatomic,strong)NSArray * appleArray;

//加载视图
@property (nonatomic,strong)UIView * loadingView;

//菊花
@property(nonatomic,strong)UIActivityIndicatorView * loadingActivityIndicator;


@end

@implementation DNTopUpViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.appleArray = @[@"com.dnfe.00a",@"com.dnfe.00b",@"com.dnfe.00c",@"com.dnfe.00d"];
    [self creatUserInterface];
    [self getProductList];
}



-(void)getProductList
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getProduct];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray *  productArray = [dataObject getJSONArray:@"product"];
        
        self.dataArray = [DNTopUpModel mj_objectArrayWithKeyValuesArray:productArray.array];
        
        [self.tableView reloadData];
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
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
    if ([DNConfig sharedConfig].audit==NO) {
        
        DLHttpsBusinesRequest *request = [DLHttpRequestFactory userLoginUserName:@"18910026892"
                                                                        passwoed:@"123456"
                                                                         captcha:nil];
        request.isShowLoading = NO;
        
        request.requestSuccess = ^(id response)
        {
            
            [DNSession sharedSession].userAccount = @"18910026892";
 
            DLJSONObject *object = response;
            
            NSInteger resultCode = [object getInteger:@"errno"];
            [DNSession sharedSession].loginServerTime = [object getLong:@"time"];
            
            DLJSONObject *resultData = [object getJSONObject:@"data"];
            
            [DNSession sharedSession].uid  = [resultData getString:@"uid"];
            
            [DNSession sharedSession].token = [resultData getString:@"token"];
            
            [DNSession sharedSession].birthday = [resultData getString:@"birth"];
            
            [DNSession sharedSession].avatar  = [resultData getString:@"avatar"];
            
            [DNSession sharedSession].nickname = [resultData getString:@"nickname"];
            
            [DNSession sharedSession].sex  = [resultData getString:@"gender"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DNUserInfoChange" object:nil];

             [self applePay:topUpModel];
        };
        
        request.requestFaile = ^(NSError *error)
        {
         
        };
        
        [request excute];
        
    
    }else
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
            
            [self alipay:topUpModel];
            
        }
    }
    
    
    
}


-(void)alipay:(DNTopUpModel*)topUpModel
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

-(void)applePay:(DNTopUpModel*)topUpModel
{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self completeTransaction:transaction];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            return;
        }
    }
    
    _money = [NSString stringWithFormat:@"%@",topUpModel.price];
    _productid = [NSString stringWithFormat:@"%ld",(long)topUpModel.id];
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"允许程序内付费购买");
        
        [self loadingViewShow];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        
        DLHttpsBusinesRequest *request = [DLHttpRequestFactory topUpWithSource:@"apple" amount:_money userid:[DNSession sharedSession].token currency:@"CNY" productid:_productid];
        
        request.requestSuccess = ^(id response){
            
            DLJSONObject * object = response;
            
            DLJSONObject * dataObject = [object getJSONObject:@"data"];
            
            _orderid = [dataObject getString:@"orderid"];
            _notify_url = [dataObject getString:@"notify_url"];
            
            [user setObject:_orderid forKey:@"Last_orderId"];
            
            NSArray *product = nil;
            
            NSInteger index = topUpModel.id -10001;
            
            if ([self.appleArray count]>index) {
                NSString * productid = self.appleArray[index];
                
                product = [[NSArray alloc] initWithObjects:productid,nil];
                NSSet *nsset = [NSSet setWithArray:product];
                
                SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
                request.delegate = self;
                [request start];
            }
            
            
        };
        
        request.requestFaile = ^(NSError *error)
        {
            [self loadingViewHide];
        };
        
        [request excute];
        
    }else
    {
        [self canclePay];
        
        [self loadingViewHide];
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您禁止了应用内购买权限,请到设置中开启"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        
        [alerView show];
        
    }
}



#pragma mark request delegate
///<> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray   *products = response.products;
    SKProduct *product  = [products count] > 0 ? [products objectAtIndex:0] : nil;
    
    if (product) {
        
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        payment.applicationUsername = self.orderid;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        NSLog(@"---------发送购买请求------------");
        
    } else {
        
        [self canclePay];
        
        //无法获取商品信息
        NSLog(@"无法获取商品信息");
        [self loadingViewHide];
    }
    
}

//请求商品错误
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    [self canclePay];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadingViewHide];
    });
    
    [self canclePay];
    
    
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",nil) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}
-(void)requestDidFinish:(SKRequest *)request
{
    
}


#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadingViewHide];
                });
                [self completeTransaction:transaction];
                
                NSLog(@"-----交易完成 --------");
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                NSLog(@"transaction.error = %ld",transaction.error.code);
                
                
                [self failedTransaction:transaction];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self loadingViewHide];
                    
                });
                
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                
                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
            {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self loadingViewHide];
                    
                });
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                //商品添加进列表
                
                NSLog(@"-----商品添加进列表 --------");
                
                
                break;
            default:
                break;
        }
    }
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
}

#pragma mark end

-(void)PurchasedTransaction: (SKPaymentTransaction *)transaction{
    
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction

{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadingViewHide];
    });
    
    NSLog(@"交易结束");
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        
        
    }
    
    
    NSError *error;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (!self.orderid.length) {
        
        if ([[user objectForKey:@"Last_orderId"]  length]) {
            self.orderid = [user objectForKey:@"Last_orderId"] ;
        }else{
            self.orderid = @"0";
        }
    }
    
    NSDictionary *requestContents = @{
                                      @"orderid":self.orderid, @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    NSString *requestStr = [[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
    
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory applePayWithUrl:_notify_url ReceiptString:requestStr OrderId:_orderid];
    
    request.requestSuccess = ^(id response){
        
        NSLog(@"支付成功");
        
        [DNSession sharedSession].vip = YES;
        NSDictionary * dict =[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"state", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DNRefreshVipState" object:dict];
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


//记录交易
-(void)recordTransaction:(NSString *)product{
    
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [self canclePay];
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
}

//用户取消付款
-(void)canclePay
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory applePayWithOrderId:self.orderid
                                                                     andStatus:@"cancel"];
    
    request.requestSuccess = ^(id response){
        
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    [request excute];
}




-(UIView*)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _loadingView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_loadingView addSubview:self.loadingActivityIndicator];
    }
    return _loadingView;
}

-(UIActivityIndicatorView*)loadingActivityIndicator
{
    if (!_loadingActivityIndicator) {
        _loadingActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingActivityIndicator.center = CGPointMake(KScreenWidth/2,KScreenHeight/2-64);//只能设置中心，不能设置大小
        _loadingActivityIndicator.color = [UIColor whiteColor];
        [_loadingActivityIndicator setHidesWhenStopped:YES];
        
    }
    return _loadingActivityIndicator;
}
-(void)loadingViewShow
{
    [self.loadingActivityIndicator startAnimating];
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
    
    
}
-(void)loadingViewHide
{
    [self.loadingActivityIndicator stopAnimating];
    [self.loadingView removeFromSuperview];
}




#pragma mark
#pragma mark ===========AliPay=============
//支付宝
-(void)zhifubaoMethod:(NSString*)payorder;
{
    NSLog(@"调起支付宝");
    
    
    if (![[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"alipay:"]]) {
        //支付宝网页支付设置，显示UIWindow窗口
        
        NSArray *array = [[UIApplication sharedApplication] windows];
        
        UIWindow* win=[array objectAtIndex:0];
        
        
        [win setHidden:NO];
        
    }
    
    
    NSString *appScheme = @"dnfAliPay";
    [[AlipaySDK defaultService] payOrder:payorder fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"resultDic = %@",resultDic);
        
        [self alipayResult:resultDic];
        
    }];
    
    
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
        NSDictionary * dict =[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"state", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DNRefreshVipState" object:dict];
        
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

