//
//  DNPersonalViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPersonalViewController.h"

@interface DNPersonalViewController ()

@end

@implementation DNPersonalViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self preferredStatusBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarHide:YES];
    [self creatUserInterface];
}

-(void)creatUserInterface
{
  
    [self.view addSubview:self.tableView];
    
}
#pragma mark - TabelView delegate 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 56;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 240;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return self.headerView;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString * cellID = @"DNPersonalTableViewCell";
    
    DNPersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DNPersonalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"加入VIP";
        }
            break;
            case 1:
        {
            cell.titleLabel.text = @"消息";
        }
            break;
            case 2:
        {
            cell.titleLabel.text = @"浏览记录";
        }
            break;
            case 3:
        {
            cell.titleLabel.text = @"我的收藏";
        }
            break;
            case 4:
        {
            cell.titleLabel.text = @"帮助与反馈";
        }
            break;
            case 5:
        {
            cell.titleLabel.text = @"退出";
        }
            break;
        default:
            break;
    }
    
    
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            case 0:
        {
            DNTopUpViewController * topupViewController = [DNTopUpViewController viewController];
           
            [self pushController:topupViewController];
  
       
        }
            break;
            case 1:
        {
            DNMessageViewController * messageViewController = [DNMessageViewController viewController];
            [self pushController:messageViewController];
        }
            break;
            case 2:
        {
           
        }
            break;
            case 3:
        {
           
        }
            break;
            case 4:
        {
            DNHelpViewController * helpViewController = [DNHelpViewController viewController];
            [self pushController:helpViewController];
        }
            break;
            case 5:
        {
         
        }
            break;
        default:
            break;
    }
}


-(void)avatarButtonClick:(UIButton*)sender
{
    DNEditViewController * editVc = [DNEditViewController viewController];
    [self pushController:editVc];
}

-(void)pushController:(DNBaseViewController*)controller
{
    //获取RootViewController
    UINavigationController *nav = (UINavigationController*)self.xl_sldeMenu.rootViewController;
    [nav pushViewController:controller animated:false];
    //显示主视图
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
}

-(UITableView*)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth*0.8, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor= [UIColor whiteColor];   
    }
    return _tableView;
}

-(UIView*)headerView
{
    if (!_headerView) {
        
        CGFloat width = KScreenWidth*0.8;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 240)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:self.avatarButton];
        [_headerView addSubview:self.nickNameLabel];
    }
    return _headerView;
}


-(UIButton*)avatarButton
{
    if (!_avatarButton) {
        //中心点的x坐标
        CGFloat centerX = KScreenWidth*0.4;
        CGFloat width   = 75;
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarButton.frame = CGRectMake(centerX-width/2, width, width, width);
        _avatarButton.layer.cornerRadius = width/2;
        _avatarButton.layer.masksToBounds = YES;
        [_avatarButton sd_setImageWithURL:[NSURL URLWithString:[DNSession sharedSession].avatar] forState:UIControlStateNormal];
        [_avatarButton addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _avatarButton;
}

-(UILabel*)nickNameLabel
{
    if (!_nickNameLabel) {
        CGFloat width = KScreenWidth*0.8;
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.avatarButton.frame)+16, width, 21)];
        _nickNameLabel.textColor = [UIColor customColorWithString:@"484848"];
        _nickNameLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _nickNameLabel.textAlignment= NSTextAlignmentCenter;
        _nickNameLabel.text = @"昵称最多八个汉子";
    
    }
    return _nickNameLabel;
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
