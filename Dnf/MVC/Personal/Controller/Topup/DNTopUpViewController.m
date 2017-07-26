//
//  DNTopUpViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTopUpViewController.h"

@interface DNTopUpViewController ()

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
