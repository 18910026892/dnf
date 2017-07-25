//
//  DLPageView.m
//  Dreamer-ios-client
//
//  Created by Ant on 17/2/21.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import "DLPageView.h"

@interface DLPageView ()

@property(nonatomic, strong) NSMutableArray *subViewArray;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) NSInteger selectIndex;

-(void)initData;
-(void)initView;

/**
 *  初始化UIScrollView
 */
-(void)initScrollView;

/**
 *  清空itemArray并删除子试图
 */
-(void)clearSubViewArray;

/**
 *  滑动层滑动的逻辑
 *
 *  @param scrollView 滑动层的对象
 */
-(void)pageMoveToIndexProcess:(UIScrollView *)scrollView;

@end

@implementation DLPageView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

-(void)addSubviews:(NSArray *)viewArray
{
    [self clearSubViewArray];
    
    NSInteger count = viewArray.count;
    CGFloat x = 0, y = 0;
    CGFloat width = 0, height = 0;
    for (int i = 0; i < count; i ++)
    {
        UIView *view = viewArray[i];
        
        width = CGRectGetWidth(view.frame);
        height = CGRectGetHeight(view.frame);
        
        view.frame = CGRectMake(x, y, width, height);
        view.tag = i;
        
        [self.scrollView addSubview:view];
        [self.subViewArray addObject:view];
        
        x += width;
    }
    
    self.scrollView.contentSize = CGSizeMake(x, 0);
}

-(void)moveToPageWithIndex:(NSInteger)index
{
    self.selectIndex = index;
    [self.scrollView setContentOffset:CGPointMake(index * CGRectGetWidth(self.frame), self.scrollView.contentOffset.y)];
}

- (void)setIsNeedScroll:(BOOL)isNeedScroll
{
    if (!isNeedScroll) {
        
        self.scrollView.scrollEnabled = NO;
    }else
    {
        self.scrollView.scrollEnabled = YES;
    }
}

#pragma mark - private

-(void)initData
{
    self.selectIndex = 0;
    self.subViewArray = [NSMutableArray array];
}

-(void)initView
{
    [self initScrollView];
}

-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    [self addSubview:self.scrollView];
}

-(void)clearSubViewArray
{
    if (self.subViewArray && self.subViewArray.count > 0) {
        for (UIView *view in self.subViewArray) {
            [view removeFromSuperview];
        }
        [self.subViewArray removeAllObjects];
    }
}

-(void)pageMoveToIndexProcess:(UIScrollView *)scrollView
{
    self.selectIndex = scrollView.contentOffset.x / CGRectGetWidth(self.frame);
    //    NSInteger count = self.subViewArray.count;
    //    for (NSInteger i = 0; i < count; i ++) {
    //        UIView *view = self.subViewArray[i];
    //        if ([viewController respondsToSelector:@selector(setViewShowState:)]) {
    //            [(BaseTableViewController *)viewController setViewShowState:i == self.selectIndex];
    //        }
    //    }
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewDidMoveToIndex:)]) {
        [_delegate pageViewDidMoveToIndex:self.selectIndex];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGSize contentSize = scrollView.contentSize;
    CGFloat percentage = contentOffset.x / contentSize.width;
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewDidScroll:)]) {
        [_delegate pageViewDidScroll:percentage];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {   //OK,真正停止了，do something
        [self pageMoveToIndexProcess:scrollView];
    }
}

- ( void )scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //OK,真正停止了,do something
    [self pageMoveToIndexProcess:scrollView];
}


@end
