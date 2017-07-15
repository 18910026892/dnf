//
//  DNRecordListViewController.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNRecordListViewController.h"

@interface DNRecordListViewController ()

@end

@implementation DNRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarHide:YES];
    [self.view addSubview:self.collectionView];
}

# pragma CollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 10;//[_dataArray count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{

    DNRecordCollectionViewCell * cell;

    if (!cell) {
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"DNRecordCollectionViewCell" forIndexPath:indexPath];
    }
    

    return cell;
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
   
    return CGSizeMake(KScreenWidth,52);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if (kind == UICollectionElementKindSectionFooter) {
        NSLog(@"footer");
    }
    DNRecordHeaderView * collectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DNRecordHeaderView" forIndexPath:indexPath];
    collectionHeader.backgroundColor = [UIColor customColorWithString:@"fafafa"];
 
    return collectionHeader;
}


#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,15,0,15);
}


-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
       
        CGFloat cellWidth = KScreenWidth/2-15-3.5;
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 7;
        layout.minimumInteritemSpacing = 7;
        layout.itemSize = CGSizeMake(cellWidth, cellWidth*9/16);
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth, KScreenHeight-107) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DNRecordCollectionViewCell class] forCellWithReuseIdentifier:@"DNRecordCollectionViewCell"];
        [_collectionView registerClass:[DNRecordHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNRecordHeaderView"];
        
    }
    return _collectionView;
}

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
