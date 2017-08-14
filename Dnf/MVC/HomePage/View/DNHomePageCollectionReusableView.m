//
//  DNHomePageCollectionReusableView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/8/12.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNHomePageCollectionReusableView.h"

@implementation DNHomePageCollectionReusableView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        
        [self addSubview:self.flowView];
        [self addSubview:self.pageControl];
        [self addSubview:self.upCircleView];
        [self addSubview:self.videoTitle];
        [self addSubview:self.collectionView];
        [self addSubview:self.downCircleView];
        [self addSubview:self.photoTitle];
        
        [self addSubview:self.upMoreButton];
        [self addSubview:self.downMoreButton];
    }
    
    return self;
    
}


#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(SBPageFlowView *)flowView{
    return [_bannerImageArray count];
}

- (CGSize)sizeForPageInFlowView:(SBPageFlowView *)flowView;{
    
    CGFloat width = KScreenWidth-30;
    CGFloat height = width/345*194;
    
    return CGSizeMake(width, height);
}

//返回给某列使用的View
- (UIView *)flowView:(SBPageFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [[UIColor customColorWithString:@"000000"] colorWithAlphaComponent:0.12].CGColor;

    }

    NSURL * imageUrl = [NSURL URLWithString:self.bannerImageArray[index]];
    [imageView sd_setImageWithURL:imageUrl];
    return imageView;
}

#pragma mark - PagedFlowView Delegate
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)cell;
    NSURL * imageUrl = [NSURL URLWithString:self.bannerImageArray[index]];
    [imageView sd_setImageWithURL:imageUrl];
    

}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(SBPageFlowView *)flowView {
    NSLog(@"Scrolled to page # %ld", (long)pageNumber);
    _currentPage = pageNumber;
    // 设置页码
    self.pageControl.currentPage = pageNumber;
}

- (void)didSelectItemAtIndex:(NSInteger)index inFlowView:(SBPageFlowView *)flowView
{
    NSLog(@"didSelectItemAtIndex: %ld", (long)index);
    DNVideoModel * videoModel = self.bannerArray[index];
    
    if (self.videoDelegate) {
        
        [self.videoDelegate selectVideo:videoModel];
    }
    
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,15,0,15);
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
    DNVideoCollectionViewCell * cell;
    if(!cell)
    {
        cell= (DNVideoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DNVideoCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.videoModel = self.dataArray[indexPath.row];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DNVideoModel * videoModel = self.dataArray[indexPath.row];

    if (self.videoDelegate) {
        
        [self.videoDelegate selectVideo:videoModel];
    }
    
}


-(UIView*)upCircleView
{
    if (!_upCircleView) {
        _upCircleView = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(self.flowView.frame)+18, 10, 10)];
        _upCircleView.layer.cornerRadius = 5;
        _upCircleView.layer.borderWidth = 1;
        _upCircleView.layer.borderColor = kThemeColor.CGColor;
        
    }
    return _upCircleView;
}

-(UILabel*)videoTitle
{
    if (!_videoTitle) {
        _videoTitle = [[UILabel alloc]initWithFrame:CGRectMake(34,CGRectGetMaxY(self.flowView.frame)+12, 200, 24)];
        _videoTitle.text = @"推荐视频";
        _videoTitle.textAlignment = NSTextAlignmentLeft;
        _videoTitle.textColor = [UIColor blackColor];
        _videoTitle.font = [UIFont fontWithName:TextFontName_Light size:17];
        
    }
    return _videoTitle;
}



-(UIView*)downCircleView
{
    if (!_downCircleView) {
        _downCircleView = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(self.collectionView.frame)+18, 10, 10)];
        _downCircleView.layer.cornerRadius = 5;
        _downCircleView.layer.borderWidth = 1;
        _downCircleView.layer.borderColor = kThemeColor.CGColor;
        
    }
    return _downCircleView;
}

-(UILabel*)photoTitle
{
    if (!_photoTitle) {
        _photoTitle = [[UILabel alloc]initWithFrame:CGRectMake(34,CGRectGetMaxY(self.collectionView.frame)+12, 200, 24)];
        _photoTitle.text = @"推荐图片";
        _photoTitle.textAlignment = NSTextAlignmentLeft;
        _photoTitle.textColor = [UIColor blackColor];
        _photoTitle.font = [UIFont fontWithName:TextFontName_Light size:17];
        
    }
    return _photoTitle;
}


-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 7.5;
        layout.minimumInteritemSpacing = 7.5;
        
        CGFloat itemWidth = 169;
        CGFloat itemHeight = 95;
        
        layout.itemSize = CGSizeMake(itemWidth,itemHeight);
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.flowView.frame)+43,KScreenWidth,198) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DNVideoCollectionViewCell class] forCellWithReuseIdentifier:@"DNVideoCollectionViewCell"];
        
     
        
    }
    return _collectionView;
}




-(SBPageFlowView*)flowView
{
    if (!_flowView) {
        
        _flowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth,KScreenWidth/345*194)];
        _flowView.delegate = self;
        _flowView.dataSource = self;
        _flowView.minimumPageAlpha = 0.6;
        _flowView.minimumPageScale = 0.96;
        
    }
    return _flowView;
}

-(UIPageControl*)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(KScreenWidth/2-10,CGRectGetMaxY(self.flowView.frame)-30, 20, 20);//指定位置大小
        _pageControl.pageIndicatorTintColor = [[UIColor customColorWithString:@"ffffff"] colorWithAlphaComponent:0.26];
        _pageControl.currentPageIndicatorTintColor = [UIColor customColorWithString:@"ffffff"];
        
    }
    return _pageControl;
}

-(UIButton*)upMoreButton
{
    if (!_upMoreButton) {
      
        _upMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upMoreButton.frame= CGRectMake(KScreenWidth-75,CGRectGetMaxY(self.flowView.frame),75, 43);
        [_upMoreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_upMoreButton setTitleColor:[UIColor customColorWithString:@"BBBBBB"] forState:UIControlStateNormal];
        _upMoreButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:13];
        
        [_upMoreButton setImage:[UIImage imageNamed:@"home_into_normal"] forState:UIControlStateNormal];
        
        
        [_upMoreButton setTitleEdgeInsets:UIEdgeInsetsMake(5, -20, 0, 0)];
        [_upMoreButton setImageEdgeInsets:UIEdgeInsetsMake(5,44, 0, 0)];
        _upMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
    }
    return _upMoreButton;
}


-(UIButton*)downMoreButton
{
    if (!_downMoreButton) {
        
        _downMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downMoreButton.frame= CGRectMake(KScreenWidth-75,CGRectGetMaxY(self.collectionView.frame),75, 43);
        [_downMoreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_downMoreButton setTitleColor:[UIColor customColorWithString:@"BBBBBB"] forState:UIControlStateNormal];
        _downMoreButton.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:13];
        
        [_downMoreButton setImage:[UIImage imageNamed:@"home_into_normal"] forState:UIControlStateNormal];
        
        
        [_downMoreButton setTitleEdgeInsets:UIEdgeInsetsMake(5, -20, 0, 0)];
        [_downMoreButton setImageEdgeInsets:UIEdgeInsetsMake(5,44, 0, 0)];
        _downMoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
    }
    return _downMoreButton;
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

-(void)setBannerImageArray:(NSMutableArray *)bannerImageArray
{
    _bannerImageArray = bannerImageArray;
    
    [self.flowView reloadData];
    
    self.pageControl.numberOfPages = [bannerImageArray count];
    self.pageControl.currentPage = 0;
}


@end
