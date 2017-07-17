//
//  DNChosseCountryViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNChosseCountryViewController.h"
#import "DNChosseCountryTableViewCell.h"

static NSString *const reusedId = @"DNChosseCountryTableViewCell";

@interface DNChosseCountryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;

@end

@implementation DNChosseCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInterface];
}

-(void)creatUserInterface
{
    [self setNavTitle:@"选择国家"];
    [self showBackButton:YES];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DNChosseCountryTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:reusedId];
    
    if (!cell) {
        cell = [[DNChosseCountryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
  
    NSArray *countrys = @[@"中国", @"U.S. Virgin lslands"];
    NSArray *countryCound = @[@"86",@"1"];
    cell.country = countrys[indexPath.row];
    cell.countryNum = [countryCound[indexPath.row] integerValue];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DNChosseCountryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.selectBlock != nil) {
        self.selectBlock([NSString stringWithFormat:@"+%ld", cell.countryNum]);
    }
}


-(UITableView*)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor= [UIColor whiteColor];
    }
    return _tableView;
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
