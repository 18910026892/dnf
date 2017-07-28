//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"
#import "MJPhotoCollectionViewCell.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "DLShareView.h"
#import "NSString+DLPictureChoice.h"
#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface MJPhotoBrowser () <MJPhotoViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UIButton * closeButton;
@property (strong,nonatomic) UIButton * shareButton;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIScrollView *photoScrollView;
@property (strong, nonatomic) NSMutableSet *visiblePhotoViews, *reusablePhotoViews;
@property (strong, nonatomic) MJPhotoToolbar *toolbar;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (nonatomic, assign) BOOL isBarShowing;

@end

@implementation MJPhotoBrowser

#pragma mark - init M

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showSaveBtn = YES;
        
        
    }
    return self;
}



- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
     
        self.closeButton.alpha = 0.0;
        self.shareButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.closeButton.alpha = 1.0;
        self.shareButton.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:5];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}


-(void)closeButtonClick:(UIButton*)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    // 移除工具条
    [self.toolbar removeFromSuperview];
    [self.closeButton removeFromSuperview];
    [self.shareButton removeFromSuperview];
    [self.collectionView removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

-(void)shareButtonClick:(UIButton*)sender
{

    NSDictionary * shareDict = [NSDictionary dictionaryWithObjectsAndKeys:self.relationid,@"relationid",nil];
    
    [DLShareView showMyShareViewWothSuperView:self.view
                                  isShowLaHei:NO
                                       userId:nil
                                      andType:10
                                resourcesType:@"photo"
                                    andRoomID:@"1"
                                 andShareDict:shareDict
                                    backColor:nil];
}

#pragma mark - get M

-(UIButton*)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(15, 27, 30, 30);
        _closeButton.alpha = 0.0;
        [_closeButton setImage:[UIImage imageNamed:@"photo_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


-(UIButton*)shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(KScreenWidth-45, 27, 30, 30);
        _shareButton.alpha = 0.0;
        [_shareButton setImage:[UIImage imageNamed:@"photo_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIView *)view{
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _view.backgroundColor = [UIColor blackColor];
     
    }
    return _view;
}

- (UIScrollView *)photoScrollView{
    if (!_photoScrollView) {
        CGRect frame = self.view.bounds;
        frame.origin.x -= kPadding;
        frame.size.width += (2 * kPadding);
        _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _photoScrollView.pagingEnabled = YES;
        _photoScrollView.delegate = self;
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.showsVerticalScrollIndicator = NO;
        _photoScrollView.backgroundColor = [UIColor clearColor];
    }
    return _photoScrollView;
}

- (MJPhotoToolbar *)toolbar{
    if (!_toolbar) {
        CGFloat barHeight = 27;
    
        CGFloat barY = self.view.frame.size.height - barHeight;
        _toolbar = [[MJPhotoToolbar alloc] init];
        _toolbar.showSaveBtn = _showSaveBtn;
        _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

        
    }
    return _toolbar;
}
-(UICollectionView*)collectionView
{
    if (!_collectionView) {

        //普通集合视图布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(71,114);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,KScreenHeight,KScreenWidth, 114) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = NO;
        [_collectionView registerClass:[MJPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MJPhotoCollectionViewCell"];
    
    }
    return _collectionView;
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    //初始化数据
    {
        if (!_visiblePhotoViews) {
            _visiblePhotoViews = [NSMutableSet set];
        }
        if (!_reusablePhotoViews) {
            _reusablePhotoViews = [NSMutableSet set];
        }
        self.toolbar.photos = self.photos;
        
        
        CGRect frame = self.view.bounds;
        frame.origin.x -= kPadding;
        frame.size.width += (2 * kPadding);
        self.photoScrollView.contentSize = CGSizeMake(frame.size.width * self.photos.count, 0);
        self.photoScrollView.contentOffset = CGPointMake(self.currentPhotoIndex * frame.size.width, 0);
        
        [self.view addSubview:self.photoScrollView];
        [self.view addSubview:self.toolbar];
        [self.view addSubview:self.closeButton];
        [self.view addSubview:self.shareButton];
        [self.view addSubview:self.collectionView];
        [self updateTollbarState];
        [self showPhotos];
    }
    //渐变显示
    self.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

#pragma mark - set M
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    if (_photos.count <= 0) {
        return;
    }
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    _toolbar.currentPhotoIndex = _currentPhotoIndex;

    
    if (_photoScrollView) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - Show Photos
- (void)showPhotos
{
    CGRect visibleBounds = _photoScrollView.bounds;
    int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
    int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = (int)_photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = (int)_photos.count - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:(int)index];
        }
    }
    
}

//  显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当前页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    MJPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

//  加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    if (index > 0) {
        MJPhoto *photo = _photos[index - 1];
        [[SDWebImageManager sharedManager] downloadImageWithURL:photo.url options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //do nothing
        }];
    }
    
    if (index < _photos.count - 1) {
        MJPhoto *photo = _photos[index + 1];
        [[SDWebImageManager sharedManager] downloadImageWithURL:photo.url options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //do nothing
        }];
    }
}

//  index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (MJPhotoView *photoView in _visiblePhotoViews) {
        if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
    return  NO;
}
// 重用页面
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

#pragma mark - updateTollbarState
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentPhotoIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
}

#pragma mark - MJPhotoViewDelegate
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    if (self.isBarShowing) {
        [self animateHide];
    } else {
        [self animateShow];
    }
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    [self updateTollbarState];
}
- (void)showPhotoCollectionView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.collectionView.y = KScreenHeight-114;
        self.toolbar.y = self.view.frame.size.height - 27-114;

        
    } completion:^(BOOL finished) {

    }];
}
- (void)hidePhotoCollectionView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.collectionView.y = KScreenHeight;
        self.toolbar.y = self.view.frame.size.height - 27;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if([scrollView isKindOfClass:[UICollectionView class]])
    {
        return;
    }

     [self showPhotos];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    //当滑动collecionView的时候暂时不需要处理任何事
    if([scrollView isKindOfClass:[UICollectionView class]])
    {
        return;
    }
    [self updateTollbarState];
}


# pragma CollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [_photos count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    MJPhotoCollectionViewCell * cell;
    
    if(!cell)
    {
        cell= (MJPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"MJPhotoCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.tag = 1000+indexPath.row;
    
    if (indexPath.row==_currentPhotoIndex) {
        cell.selected = YES;
    }else
    {
         cell.selected = NO;
    }
    
  

    MJPhoto *photo= _photos[indexPath.row];
    [cell.coverImageView sd_setImageWithURL:photo.url];
 
    return cell;
    
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //野方法
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    MJPhotoCollectionViewCell * cell = (MJPhotoCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:index];
    cell.selected = NO;
 
    
    
    self.toolbar.currentPhotoIndex = indexPath.row;
    [self setCurrentPhotoIndex:indexPath.row];
    
    

}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
