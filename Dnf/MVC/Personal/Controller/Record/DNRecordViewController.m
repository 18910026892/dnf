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
@interface DNRecordViewController ()<DLTopBarViewDelegate,DLPageViewDelegate>

@property (nonatomic,strong) DLTopBarView *topbar; // 标题
@property (nonatomic,strong) DLPageView *pageView; // 切换用
@property (nonatomic,strong) UIButton * clearButton;
@property (nonatomic,strong) NSMutableArray * viewArray;
@property (nonatomic,assign) BOOL isEdit;

@end

@implementation DNRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isEdit = NO;
    [self creatUserInterface];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.clearButton];
   
    [self initTopBar];
    [self initPageView];
}

-(void)rightButtonClick:(UIButton*)sender
{
    _isEdit = !_isEdit;
    
    self.pageView.isNeedScroll =!_isEdit;
    self.topbar.userInteractionEnabled = !_isEdit;
    
    DLRecordListView * listView = self.viewArray[self.topbar.selectIndex];
    listView.isEdit = _isEdit;
    [listView.collectionView reloadData];
}

-(void)clearButtonClick:(UIButton*)sender
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
        
        NSLog(@"delete");
    
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
    
    _topbar.selectIndex = 0;
    
    [self.view addSubview:_topbar];
}

-(void)initPageView
{
    
    CGRect pageRect = CGRectMake(0, 43+64,KScreenWidth,KScreenHeight-64-43);
    
    _pageView = [[DLPageView alloc]initWithFrame:pageRect];
    _pageView.delegate = self;
    [self.view addSubview:_pageView];

    
    CGFloat listHeight = KScreenHeight-64-43;

    for (int i=0; i<2; i++) {
        DLRecordListView * listView = [[DLRecordListView alloc]initWithFrame:CGRectMake(0, 107, KScreenWidth,listHeight)];
        listView.tag = 1000+i;
        [self.viewArray addObject:listView];
    }
    
    
    [self.pageView addSubviews:self.viewArray];

}


/**
 *  视图的item被选中时的回调函数
 *
 *  @param index 视图item的索引
 */
-(void)topTabBarDidSelectedWithIndex:(NSInteger)index
{
    
    [_pageView moveToPageWithIndex:index];
    
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


-(UIButton*)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(13, 64, KScreenWidth-26, 43);
        _clearButton.backgroundColor = [UIColor whiteColor];
        [_clearButton setTitle:@"一键清空" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clearButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:15];
        _clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

-(NSMutableArray*)viewArray
{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
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
