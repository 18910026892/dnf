//
//  DLRecordListView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/20.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DLRecordListView.h"

@implementation DLRecordListView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
      
        [self addSubview:self.collectionView];
        
        
    }
    return self;
    
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
    
    if(!cell)
    {
        cell= ( DNRecordCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DNRecordCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.backgroundColor = DNRandomColor;
    cell.selectImageView.hidden = !self.isEdit;
    
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


@end
