//
//  DNPhotoCollectionReusableView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNPhotoCollectionReusableView.h"

@implementation DNPhotoCollectionReusableView


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        
        [self addSubview:self.collectionView];
        [self addSubview:self.segMentView];
    }
    return self;
    
}
#pragma mark - collectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//设置一组有多少item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.recommedArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DNTopPhotoCollectionViewCell * cell;
    if(!cell)
    {
        cell= (DNTopPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DNTopPhotoCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.photoModel = self.recommedArray[indexPath.row];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.photoDelegate) {
        [self.photoDelegate  didSelectPhoto:self.recommedArray[indexPath.row]];
    }
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20,15,0,15);
}

-(void)setRecommedArray:(NSMutableArray *)recommedArray
{
    _recommedArray = recommedArray;
    
    [self.collectionView reloadData];
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing =8;
        
        CGFloat itemWidth = 200;
        CGFloat itemHeight = 320;
        
        layout.itemSize = CGSizeMake(itemWidth,itemHeight);
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,KScreenWidth,340) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DNTopPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"DNTopPhotoCollectionViewCell"];

    }
    return _collectionView;
}


-(DNVipSegmentView*)segMentView
{
    if (!_segMentView) {
        _segMentView = [[DNVipSegmentView alloc]initWithFrame:CGRectMake(0, 340, KScreenWidth, 44)];
    }
    return _segMentView;
}

@end
