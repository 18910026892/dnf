//
//  DNRecordViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/13.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNRecordViewController.h"

const static CGFloat headerHeight = 44.0f;

@interface DNRecordViewController ()

@end

@implementation DNRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUserInterface];
}

-(void)creatUserInterface
{
    [self showBackButton:YES];
    [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.bigScrollView];
}

-(void)addSubView
{
    //数组的count
    for (int i=0 ; i<2;i++){
        DNRecordListViewController* listViewController = [DNRecordListViewController viewController];
         listViewController.view.frame = CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight-107);
        [self.bigScrollView addSubview:listViewController.view];
        
    }

}

-(void)clearButtonClick:(UIButton*)sender
{
    
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float page = self.bigScrollView.contentOffset.x/self.bigScrollView.width;

    if(page-(int)page==0){
        self.headerIndex= (int)page;
        [self.segmentView itemSelectIndex:page];
    }else{
        [self.segmentView SegmentChangeWithScrollView:scrollView contentOffset:self.bigScrollView.contentOffset.x];
    }
}

-(void)setHeaderIndex:(NSInteger)headerIndex
{
    [self.segmentView itemSelectIndex:headerIndex];
    [self.segmentView SegmentChangeWithScrollView:self.bigScrollView contentOffset:self.bigScrollView.contentOffset.x];
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

-(UIScrollView*)bigScrollView
{
    if (!_bigScrollView)
    {
        _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,107, KScreenWidth, KScreenHeight-107)];
        _bigScrollView.delegate = self;
        _bigScrollView.bounces = NO;
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.showsHorizontalScrollIndicator = NO;
        _bigScrollView.scrollEnabled=  YES;
        _bigScrollView.contentSize = CGSizeMake(KScreenWidth*2, 0);
        [self addSubView];
    }
    return _bigScrollView;
}

- (DNSegmentView*)segmentView
{
    if(!_segmentView){
        
        CGFloat headerWidth = 220;
        CGFloat oneItemWidth = 110;
  
        _segmentView = [[DNSegmentView alloc]initWithFrame:CGRectMake(KScreenWidth/2-headerWidth/2,22,headerWidth, headerHeight)];

        [_segmentView setTitleArr:@[@"浏览记录",@"我的收藏"] OneItemWidth:oneItemWidth TitleFont: [UIFont fontWithName:TextFontName_Light size:17]];
        _segmentView.sliderWidth = 60;
        __weak DNRecordViewController * weakSelf = self;
        _segmentView.SegmentSelectedItemIndex = ^(NSInteger index){
            _headerIndex = index;
            
        [weakSelf.bigScrollView setContentOffset:CGPointMake(weakSelf.bigScrollView.width*index,0) animated:YES];
        [weakSelf.segmentView SegmentChangeWithScrollView:weakSelf.bigScrollView contentOffset:weakSelf.bigScrollView.contentOffset.x];
            
          
        };
        _segmentView.backgroundColor = [UIColor clearColor];

        
    }
    return _segmentView;
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
