//
//  DNSearchPhotoView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSearchPhotoView.h"

@implementation DNSearchPhotoView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        
        [self addSubview:self.collectionView];
        
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
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DNPhotoCollectionViewCell * cell;
    if(!cell)
    {
        cell= (DNPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DNPhotoCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.photoModel = self.dataArray[indexPath.row];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DNPhotoModel * photoModel = self.dataArray[indexPath.row];
  
    if (self.delegate) {
        [self.delegate selectPhoto:photoModel];
    }
    
    
}



//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12,15,0,15);
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 7.5;
        layout.minimumInteritemSpacing = 7.5;
        
        CGFloat itemWidth = (KScreenWidth-45)/3;
        CGFloat itemHeight = itemWidth/110*217;
        
        layout.itemSize = CGSizeMake(itemWidth,itemHeight);
        
        _collectionView =[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DNPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"DNPhotoCollectionViewCell"];

  
        
    }
    return _collectionView;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

@end
