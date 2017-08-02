//
//  DNPersonalViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPersonalViewController.h"
#import "DNPersonalTableViewCell.h"
#import "DNTopUpViewController.h"
#import "DNMessageViewController.h"
#import "DNRecordViewController.h"
#import "DNHelpViewController.h"
#import "DNEditViewController.h"
#import "DNLoginViewController.h"
#import "DNRecordModel.h"
@interface DNPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSString * messageId;
//个人中心
@property(nonatomic,strong)UITableView * tableView;

//顶部视图
@property(nonatomic,strong)UIView * headerView;


//关闭按钮
@property(nonatomic,strong)UIButton * closeButton;

//头像视图
@property(nonatomic,strong)UIButton * avatarButton;

//昵称
@property(nonatomic,strong)UILabel * nickNameLabel;

//底部视图
@property(nonatomic,strong)UIView * footerView;

//清除记录
@property(nonatomic,strong)UIButton * clearButton;

//消息提示红点
@property(nonatomic,strong)UIView * redView;

//记录图片数组
@property(nonatomic,strong)NSMutableArray * recordImageArray;

//收藏图片数组
@property(nonatomic,strong)NSMutableArray * collectionImageArray;


@property(nonatomic,strong)UIView * guideView;
@property(nonatomic,strong)UIImageView * guideImageView,*guideImageView1;
@property(nonatomic,strong)UILabel * guideLabel,*guideLabel1,*guideLabel2;

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
    [self operationData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:@"DNUserInfoChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftControllerShow) name:@"DNShowLeftViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationData) name:@"DNRecordListChange" object:nil];
}

-(void)operationData
{
    
    [self getRecordList];
    [self getCollecitonList];
    
}

-(void)getRecordList
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getRecordListWithNumber:@"3" offset:@"0"];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * accessArray  = [dataObject getJSONArray:@"access"];
        
        DNPersonalTableViewCell * cell =(DNPersonalTableViewCell * )[self.tableView viewWithTag:1002];
        for (UIView * v in cell.contentView.subviews) {
            
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
        

        [self.recordImageArray removeAllObjects];
        
        for (NSDictionary * dict in accessArray.array) {
            
            NSString * cover = [dict valueForKey:@"cover"];
            
             if(IsStrEmpty(cover)==NO)
            {
                
                [self.recordImageArray addObject:cover];
            }
            
     
        }
    
        [self.tableView reloadData];
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];

}

-(void)getCollecitonList
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory getCollectionListWithNumber:@"3" offset:@"0"];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        DLJSONArray * favoriteArray  = [dataObject getJSONArray:@"favorite"];
        
        DNPersonalTableViewCell * cell =(DNPersonalTableViewCell * )[self.tableView viewWithTag:1003];
        for (UIView * v in cell.contentView.subviews) {
            
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
        
        
        [self.collectionImageArray removeAllObjects];
        
        for (NSDictionary * dict in favoriteArray.array) {
            
            NSString * cover = [dict valueForKey:@"cover"];
            
            if(IsStrEmpty(cover)==NO)
            {
                 [self.collectionImageArray addObject:cover];
            }
            
          
        }
        [self.tableView reloadData];
        
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
}

-(void)userInfoChange
{
  
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:[DNSession sharedSession].avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"personalcenter_avatar_normal"]];
    
    self.nickNameLabel.text = [DNSession sharedSession].nickname;
}

-(void)leftControllerShow
{
    
    NSLog(@"left controller show");
    
   if ([[NSUserDefaults standardUserDefaults] valueForKey:@"DNPersonalGuide"]==NO) {
       
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DNPersonalGuide"];
       
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
   }
    
    [self checkHasMessage];
}

-(void)checkHasMessage
{
    
    
 
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory checkHasNewMessage];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        NSInteger messageid = [dataObject getInteger:@"messageid"];
    
        if (messageid==0) {
     
            self.redView.hidden = YES;
        }else
        {
            self.redView.hidden = NO;
        }
        
        self.messageId = [NSString stringWithFormat:@"%ld",(long)messageid];
        
    };
    
    request.requestFaile = ^(NSError *error)
    {

    };
    
    [request excute];
    
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
    return 74;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 240;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return self.headerView;
   
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString * cellID = @"DNPersonalTableViewCell";
    
    DNPersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DNPersonalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.tag = 1000+indexPath.row;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"加入VIP";
        }
            break;
            case 1:
        {
            cell.titleLabel.text = @"消息";
            
            [cell addSubview:self.redView];
        }
            break;
            case 2:
        {
            cell.titleLabel.text = @"浏览记录";
            
            for (int i=0; i<[self.recordImageArray count]; i++) {
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*0.8-55-25*i,18, 20, 20)];
                imageView.layer.cornerRadius = 10;
                imageView.layer.masksToBounds = YES;
                [cell.contentView  addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.recordImageArray[i]]];
            }
            
        }
            break;
            case 3:
        {
            cell.titleLabel.text = @"我的收藏";
            
            for (int i=0; i<[self.collectionImageArray count]; i++) {
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth*0.8-55-25*i,18, 20, 20)];
                imageView.layer.cornerRadius = 10;
                imageView.layer.masksToBounds = YES;
                [cell.contentView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.collectionImageArray[i]]];
            }
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
            topupViewController.formMenu = YES;
            [self pushController:topupViewController];
  
       
        }
            break;
            case 1:
        {
            DNMessageViewController * messageViewController = [DNMessageViewController viewController];
            messageViewController.messageid = self.messageId;
            [self pushController:messageViewController];
        }
            break;
            case 2:
        {
            DNRecordViewController * recordVc = [DNRecordViewController viewController];
    
            recordVc.index = 0;
            [self pushController:recordVc];
        }
            break;
            case 3:
        {
            DNRecordViewController * recordVc = [DNRecordViewController viewController];

            recordVc.index = 1;
            [self pushController:recordVc];
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
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"记得回来看我哦~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
            
            [alertView show];
            
            
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

-(void)close
{
    //显示主视图
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
}

-(void)clear
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除浏览记录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        
        
    }];
    
    NSString * deleteString = [NSString stringWithFormat:@"删除"];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:deleteString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        DLHttpsBusinesRequest *request = [DLHttpRequestFactory deleteRecordWithAccessidid:@"all"];
        
        request.requestSuccess = ^(id response)
        {
            
            DLJSONObject *object = response;
            
            DLJSONObject * dataObject = [object getJSONObject:@"data"];
  
            DNPersonalTableViewCell * cell =(DNPersonalTableViewCell * )[self.tableView viewWithTag:1002];
            for (UIView * v in cell.contentView.subviews) {
                
                if ([v isKindOfClass:[UIImageView class]]) {
                    [v removeFromSuperview];
                }
            }
            
            [self.recordImageArray removeAllObjects];
            [self.tableView reloadData];
            
            [self.view makeToast:@"删除成功" duration:3.0 position:CSToastPositionCenter];
        };
        
        request.requestFaile = ^(NSError *error)
        {
            
        };
        
        [request excute];
 
        
    }];
    
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [deleteAction setValue:[UIColor customColorWithString:@"fe3824"] forKey:@"_titleTextColor"];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)pushController:(DNBaseViewController*)controller
{
    //获取RootViewController
    UINavigationController *nav = (UINavigationController*)self.xl_sldeMenu.rootViewController;
    [nav pushViewController:controller animated:false];
    //显示主视图
    [self.xl_sldeMenu showRootViewControllerAnimated:true];
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {

        [[DNSession sharedSession] removeUserInfo];
        

        //显示主视图
        [self.xl_sldeMenu showRootViewControllerAnimated:true];
 
    }

}
-(void)guideOnTap:(UITapGestureRecognizer *)gesture
{
    

    [self.guideView removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DNPersonalGuide"];

    
}


-(UIView*)guideView
{
    if (!_guideView) {
        _guideView = [[UIView alloc]init];
        _guideView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _guideView.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideOnTap:)];
        [_guideView addGestureRecognizer:tapGesture];
        [_guideView addSubview:self.guideImageView];
        [_guideView addSubview:self.guideImageView1];
        [_guideView addSubview:self.guideLabel];
        [_guideView addSubview:self.guideLabel1];
        [_guideView addSubview:self.guideLabel2];
        
    }
    return _guideView;
}

-(UIImageView*)guideImageView
{
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc]init];
        _guideImageView.frame = CGRectMake(KScreenWidth*0.8/2-40, 123, 80, 80);
        _guideImageView.image = [UIImage imageNamed:@"guide_click_on"];
        
    }
    return _guideImageView;
}

-(UIImageView*)guideImageView1
{
    if (!_guideImageView1) {
        _guideImageView1 = [[UIImageView alloc]init];
        _guideImageView1.frame = CGRectMake((KScreenWidth-293)/2,KScreenHeight-82-50-16,293, 82);
        _guideImageView1.image = [UIImage imageNamed:@"guide_bubble"];
    }
    return _guideImageView1;
}


-(UILabel*)guideLabel
{
    if (!_guideLabel) {
        _guideLabel = [[UILabel alloc]init];
        _guideLabel.frame = CGRectMake(KScreenWidth/2-100, KScreenHeight-98-21-16, 201, 21);
        _guideLabel.text = @"点击头像更换封面，编辑资料";
        _guideLabel.font = [UIFont systemFontOfSize:15];
        _guideLabel.textAlignment = NSTextAlignmentCenter;
        _guideLabel.textColor = [UIColor whiteColor];
        
    }
    return _guideLabel;
}


-(UILabel*)guideLabel1
{
    if (!_guideLabel1) {
        _guideLabel1 = [[UILabel alloc]init];
        _guideLabel1.frame = CGRectMake(KScreenWidth/2-131, 213, 262, 21);
        _guideLabel1.text = @"点击头像更换封面，编辑资料";
        _guideLabel1.font = [UIFont systemFontOfSize:15];
        _guideLabel1.textAlignment = NSTextAlignmentCenter;
        _guideLabel1.textColor = [UIColor whiteColor];
        
    }
    return _guideLabel1;
}

-(UILabel*)guideLabel2
{
    if (!_guideLabel2) {
        _guideLabel2 = [[UILabel alloc]init];
        _guideLabel2.frame = CGRectMake(50,KScreenHeight-28-34,100, 18);
        _guideLabel2.text = @"清空浏览记录";
        _guideLabel2.font = [UIFont systemFontOfSize:13];
        _guideLabel2.textAlignment = NSTextAlignmentLeft;
        _guideLabel2.textColor = [UIColor whiteColor];
        
    }
    return _guideLabel2;
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

-(UIView*)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth*0.8, 74)];
        [_footerView addSubview:self.clearButton];
    }
    return _footerView;
}

-(UIButton*)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame= CGRectMake(50, 0, 200, 76);
        [_clearButton setTitle:@"清空浏览记录" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor customColorWithString:@"999999"] forState:UIControlStateNormal];
        _clearButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:13];
        _clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

-(UIView*)headerView
{
    if (!_headerView) {
        
        CGFloat width = KScreenWidth*0.8;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 240)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:self.closeButton];
        [_headerView addSubview:self.avatarButton];
        [_headerView addSubview:self.nickNameLabel];
    }
    return _headerView;
}

-(UIButton*)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(2, 20, 44, 44);
        [_closeButton setImage:[UIImage imageNamed:@"nav_close_normal"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
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
        [_avatarButton setImage:[UIImage imageNamed:@"personalcenter_avatar_normal"] forState:UIControlStateNormal];
        [_avatarButton addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_avatarButton sd_setImageWithURL:[NSURL URLWithString:[DNSession sharedSession].avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"personalcenter_avatar_normal"]];
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
        _nickNameLabel.text = [DNSession sharedSession].nickname;
    
    }
    return _nickNameLabel;
}

-(UIView*)redView
{
    if(!_redView)
    {
        _redView = [[UIView alloc]initWithFrame:CGRectMake(90,15, 8,8)];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = 4;
        _redView.hidden = YES;
    }
    return _redView;
}

-(NSMutableArray*)recordImageArray
{
    if (!_recordImageArray) {
        _recordImageArray = [NSMutableArray array];
    }
    return _recordImageArray;
}


-(NSMutableArray*)collectionImageArray
{
    if (!_collectionImageArray) {
        _collectionImageArray = [NSMutableArray array];
    }
    return _collectionImageArray;
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
