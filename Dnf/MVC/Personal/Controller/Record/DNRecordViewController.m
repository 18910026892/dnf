//
//  DNRecordViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNRecordViewController.h"
#import "DLTopBarView.h"
#import "DLPageView.h"
#import "DLTopBarConfig.h"
#import "DLRecordListView.h"
#import "DNPlayerViewController.h"
#import "DNTopUpViewController.h"
@interface DNRecordViewController ()<DLTopBarViewDelegate,DLPageViewDelegate,DNRecordListViewCellDelegate>

@property (nonatomic,strong) DLTopBarView *topbar; // 标题
@property (nonatomic,strong) DLPageView *pageView; // 切换用
@property (nonatomic,strong) UIButton * clearButton;
@property (nonatomic,strong) UIButton * deleteButton;
@property (nonatomic,strong) NSMutableArray * viewArray;
@property (nonatomic,assign) BOOL isEdit;

@end

@implementation DNRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit = NO;
    [self creatUserInterface];
    [self.leftButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showLeft
{
    [self.xl_sldeMenu showLeftViewControllerAnimated:YES];
    
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    
    [self setNavTitle:@"选择项目"];
    self.titleLabel.hidden = YES;
    [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.clearButton];
   
    [self initTopBar];
    
    [self initPageView];
    [self.view addSubview:self.deleteButton];
    

    
    
}



-(void)rightButtonClick:(UIButton*)sender
{
    self.isEdit = !self.isEdit;
    
}

-(void)deleteButtonClick:(UIButton*)sender
{
    DLRecordListView * listView = self.viewArray[self.topbar.selectIndex];

     NSInteger  dataCount = [listView.videoIdArray count];
    
    if (dataCount==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先选择要删除的对象" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            
            
        }];

        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
       
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"这些项目将从您的收藏中删除" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            
            
        }];
        
        NSString * deleteString = [NSString stringWithFormat:@"删除%ld个项目",dataCount];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:deleteString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString * idString = [listView.videoIdArray componentsJoinedByString:@","];
            
            NSLog(@" 将要删除的对象是 %@",idString);
            switch (self.topbar.selectIndex) {
                case 0:
                {
                    [self deleteRecordWithIdString:idString];
                }
                    break;
                case 1:
                {
                    [self deleteCollectionWithIdString:idString];
                }
                    break;
                default:
                    break;
            }
            
            
        }];
        
        [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
        [deleteAction setValue:[UIColor customColorWithString:@"fe3824"] forKey:@"_titleTextColor"];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

-(void)deleteRecordWithIdString:(NSString*)idString
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory deleteRecordWithAccessidid:idString];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        self.isEdit = NO;
        
        DLRecordListView * listView = self.viewArray[0];
      
        [listView  retryToGetData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DNRecordListChange" object:nil];
       
        [self.view makeToast:@"删除成功" duration:3.0 position:CSToastPositionCenter];
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
}
-(void)deleteCollectionWithIdString:(NSString*)idString
{
    DLHttpsBusinesRequest *request = [DLHttpRequestFactory deleteCollectionWithFavoriteid:idString];
    
    request.requestSuccess = ^(id response)
    {
        
        DLJSONObject *object = response;
        
        DLJSONObject * dataObject = [object getJSONObject:@"data"];
        
        self.isEdit = NO;
        
        DLRecordListView * listView = self.viewArray[1];
        
        [listView  retryToGetData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DNRecordListChange" object:nil];
         
        [self.view makeToast:@"删除成功" duration:3.0 position:CSToastPositionCenter];
         
    };
    
    request.requestFaile = ^(NSError *error)
    {
        
    };
    
    [request excute];
}

-(void)clear
{
   
    DLRecordListView * listView = self.viewArray[self.topbar.selectIndex];
    
    NSInteger  dataCount = [listView.dataArray count];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"这些项目将从您的收藏中删除" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        
     
    }];
    
    NSString * deleteString = [NSString stringWithFormat:@"删除%ld个项目",dataCount];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:deleteString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
 
        
        switch (self.topbar.selectIndex) {
            case 0:
            {
                [self deleteRecordWithIdString:@"all"];
            }
                break;
            case 1:
            {
                [self deleteCollectionWithIdString:@"all"];
            }
                break;
            default:
                break;
        }
        
    
    }];

    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [deleteAction setValue:[UIColor customColorWithString:@"fe3824"] forKey:@"_titleTextColor"];

    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];

    [self presentViewController:alertController animated:YES completion:nil];
    
    
}



-(void)initTopBar
{
    DLTopBarConfig *topbarConfig = [[DLTopBarConfig alloc]init];
    
    topbarConfig.titleSelectColor = [[UIColor customColorWithString:@"#ffffff"] colorWithAlphaComponent:0.9];
    topbarConfig.titleNormalColor = [[UIColor customColorWithString:@"#ffffff"] colorWithAlphaComponent:0.5];
    topbarConfig.underLineColor   = [UIColor customColorWithString:@"#ffffff"];
    
    topbarConfig.uderLineHeight   = 2;
    topbarConfig.lineType         = DLTopBarUderlineType_equTitleWidth;
    
    _topbar = [[DLTopBarView alloc]initWithFrame:CGRectMake(KScreenWidth/2-90,20,180,44) config:topbarConfig];
    _topbar.backgroundColor = [UIColor clearColor];
    
    NSArray * arr = @[@"浏览记录",@"我的收藏"];
    [_topbar addTabBarItemWithTitles:arr];
    _topbar.delegate = self;
    _topbar.selectIndex = self.index;
    [self.view addSubview:_topbar];
}


-(void)initPageView
{

    [self.view addSubview:self.pageView];
    
    [self.pageView addSubviews:self.viewArray];

}

-(void)selectRecordModel:(DNRecordModel*)recordModel
{
 
    if ([recordModel.vip isEqualToString:@"N"]) {
        DNPlayerViewController * player = [DNPlayerViewController viewController];
        player.enterType = record;
        player.recordModel = recordModel;
        [self.navigationController pushViewController:player animated:YES];
    }else
    {
        if ([DNSession sharedSession].vip==NO) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"VIP购买" message:@"非VIP用户，无法查看以下内容\n请购买VIP后再来观看" preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            }];
            
            [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                DNTopUpViewController * topUp = [DNTopUpViewController viewController];
                [self.navigationController pushViewController:topUp animated:YES];
                
            }];
            
            [otherAction setValue:kThemeColor forKey:@"_titleTextColor"];
            
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else
            
        {
            DNPlayerViewController * player = [DNPlayerViewController viewController];
            player.enterType = record;
            player.recordModel = recordModel;
            [self.navigationController pushViewController:player animated:YES];
        }
    }
 

}

/**
 *  视图的item被选中时的回调函数
 *
 *  @param index 视图item的索引
 */
-(void)topTabBarDidSelectedWithIndex:(NSInteger)index
{
    
    [self.pageView moveToPageWithIndex:index];

}

#pragma mark -- pageViewDelegate

/**
 *  滑动时的回调函数
 *
 *  @param index 子视图的索引
 */
- (void)pageViewDidMoveToIndex:(NSInteger)index
{
    _topbar.selectIndex = index;

    DLRecordListView * listView = self.viewArray[index];
    NSInteger  dataCount = [listView.dataArray count];
    self.rightButton.hidden = (dataCount==0)?YES:NO;
}

/**
 *  滑动时的回调函数
 *
 *  @param percentage 滑动层的偏移量
 */
- (void)pageViewDidScroll:(CGFloat)percentage
{
    NSLog(@"%f",percentage);
    [_topbar moveUnderlineWithPercent:percentage];
    
    
}


-(void)setIndex:(NSInteger)index
{
    _index = index;
    
    [self.pageView moveToPageWithIndex:index];

    DLRecordListView * listView = self.viewArray[index];
    NSInteger  dataCount = [listView.dataArray count];
    self.rightButton.hidden = (dataCount==0)?YES:NO;

}

-(void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    self.pageView.isNeedScroll =!_isEdit;
    self.topbar.hidden = _isEdit;
    self.titleLabel.hidden = !_isEdit;
    self.leftButton.hidden = _isEdit;
    self.clearButton.hidden = _isEdit;
    self.deleteButton.hidden = !_isEdit;
    
    [self.rightButton setTitle:(_isEdit==NO)?@"管理":@"取消" forState:UIControlStateNormal];

    DLRecordListView * listView = self.viewArray[self.topbar.selectIndex];
    listView.isEdit = _isEdit;
    

}


-(UIButton*)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0,KScreenHeight-43, KScreenWidth, 43);
        _deleteButton.backgroundColor = [[UIColor customColorWithString:@"fafafa"] colorWithAlphaComponent:0.9];
        [_deleteButton setImage:[UIImage imageNamed:@"record_delete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(NSMutableArray*)viewArray
{
    if (!_viewArray) {
        _viewArray = [NSMutableArray arrayWithCapacity:2];
        
        CGFloat listHeight = KScreenHeight-64;
        
        for (int i=0; i<2; i++) {
            DLRecordListView * listView = [[DLRecordListView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth,listHeight)];
            listView.tag = 1000+i;
            listView.delegate = self;
            
            if (i==0) {
                
                listView.type  = @"record";
                
            }else
            {
                
                listView.type = @"collection";
            }
            
            [_viewArray addObject:listView];
        }
        
    }
    return _viewArray;
}

-(DLPageView*)pageView
{
    if(!_pageView)
    {
        CGRect pageRect = CGRectMake(0, 64,KScreenWidth,KScreenHeight-64);
        
        _pageView = [[DLPageView alloc]initWithFrame:pageRect];
        _pageView.delegate = self;
    
    }
    return _pageView;
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
