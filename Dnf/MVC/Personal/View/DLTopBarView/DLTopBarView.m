//
//  DLTopBarView.m
//  Dreamer-ios-client
//
//  Created by Ant on 17/2/21.
//  Copyright © 2017年 Beijing Dreamer. All rights reserved.
//

#import "DLTopBarView.h"
#import "DLTopBarConfig.h"

@interface DLTopBarView ()

@property (nonatomic, strong) UIColor *titleNormalCorlor;

@property (nonatomic, strong) UIColor *titleSelectCorlor;

@property (nonatomic, strong) UIColor *underLineColor;

@property (nonatomic, assign) DLTopBarUderlineType lineType;

/**
 *  视图的滑动层
 */
@property(nonatomic, strong) UIScrollView *scrollView;

/**
 *  视图中Item的集合
 */
@property(nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic,strong) NSArray *titleArray;

/**
 *  视图Item的宽度
 */
@property(nonatomic, assign) CGFloat itemWidth;

/**
 *  视图的下划线
 */
@property(nonatomic, strong) UIView *underline;

/**
 *  下划线的高度
 */
@property(nonatomic, assign) CGFloat underlineHeight;
/**
 *  箭头视图
 */
@property (nonatomic, strong) UIImageView *arrowView;

-(void)initData;
-(void)initView;

/**
 *  初始化UIScrollView
 */
-(void)initScrollView;

/**
 *  清空itemArray并删除子试图
 */
-(void)clearItemArray;

/**
 *  初始化下划线
 */
-(void)initUnderline;

/**
 *  重置下划线的位置
 *
 *  @param index item的索引
 *
 *  @param animated 是否有动画
 */
-(void)resetUnderlinePositionWithIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  重置下划线的位置
 *
 *  @param index item的索引
 */
-(void)setSelectItemWithIndex:(NSInteger)index;

@end

@implementation DLTopBarView

{
    CGFloat _pading;
}

-(id)initWithFrame:(CGRect)frame config:(DLTopBarConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleNormalCorlor = config.titleNormalColor;
        _titleSelectCorlor = config.titleSelectColor;
        _underLineColor    = config.underLineColor;
        _underlineHeight   = config.uderLineHeight;
        _lineType          = config.lineType;
        
        
        [self initData];
        [self initView];
    }
    return self;
}

-(void)addTabBarItemWithTitles:(NSArray *)titles
{
    [self clearItemArray];
    self.titleArray = titles;
    NSInteger count = titles.count;
    CGFloat x = 0, y = 0;
    self.itemWidth = (CGRectGetWidth(self.frame))  / count;
    CGFloat height = CGRectGetHeight(self.frame);
    for (NSInteger i = 0; i < count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont fontWithName:TextFontName_Light size:14];
        [button setFrame:CGRectMake(x, y, self.itemWidth, height)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:_titleNormalCorlor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.scrollView addSubview:button];
        [self.itemArray addObject:button];
        x += self.itemWidth;
    }
    
    self.scrollView.contentSize = CGSizeMake(x, 0);
    UIButton *button = [self.itemArray objectAtIndex:0];
    [self selectButtonPressed:button];
    
    self.arrowView = [[UIImageView alloc]initWithFrame:CGRectMake((self.itemWidth - 21/2)/2 , 0, 21/2, self.underlineHeight)];
    
    [self initUnderline];
    
    
//    self.arrowView.image  = [self getImage:@"arrows.png"];
    
    //********* 打开以后是箭头 不打开是下划线 **********//
    // ========>>>> [self.underline addSubview:self.arrowView];
    
    //关闭
    //[self.underline addSubview:self.arrowView];
    
    
}

-(void)setSelectIndex:(NSInteger)index
{
    if (_selectIndex != index) {
        _selectIndex  = index;
        
        [self setSelectItemWithIndex:_selectIndex];
        [self resetUnderlinePositionWithIndex:_selectIndex animated:YES];
    }
}

-(void)moveUnderlineWithPercent:(CGFloat)percentage
{
    CGFloat tempX = self.scrollView.contentSize.width * percentage;
    
    NSInteger index = tempX/self.itemWidth;
    
    CGFloat w = [self getUderLineWeidth:self.titleArray[index]];
    CGFloat x = tempX + (self.itemWidth - w)/2;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        [self.underline setFrame:CGRectMake(x, self.underline.frame.origin.y, w, CGRectGetHeight(self.underline.frame))];
    }];
}

#pragma mark - private

-(void)initData
{
    self.selectIndex     = -1;
    self.itemWidth       = 0;
    self.underlineHeight = _underlineHeight;
    self.itemArray       = [NSMutableArray array];
    self.titleArray      = [NSArray array];
   
    _pading = 0;
    
}

-(void)initView
{
    [self initScrollView];
}

-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    [self addSubview:self.scrollView];
}

-(void)clearItemArray
{
    if (self.itemArray && self.itemArray.count > 0) {
        for (UIView *view in self.itemArray) {
            [view removeFromSuperview];
        }
        [self.itemArray removeAllObjects];
    }
}

-(void)selectButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    
    if (self.selectIndex == index) {
        
        return;
    }
    
    self.selectIndex = index;
    
    if (_delegate && [_delegate respondsToSelector:@selector(topTabBarDidSelectedWithIndex:)]) {
        [_delegate topTabBarDidSelectedWithIndex:index];
    }
}

-(void)initUnderline
{
    CGFloat w = [self getUderLineWeidth:self.titleArray[0]];
    CGFloat x = (self.itemWidth - w)/2;
    
    self.underline = [[UIView alloc] initWithFrame:CGRectMake(x , CGRectGetHeight(self.frame) - self.underlineHeight-2, w, self.underlineHeight)];
    self.underline.backgroundColor = _underLineColor;
    [self addSubview:self.underline];
}

-(void)resetUnderlinePositionWithIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!self.underline) return;
    
    CGFloat w = [self getUderLineWeidth:self.titleArray[index]];
    
    CGFloat x = index * self.itemWidth + (self.itemWidth - w)/2;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.underline setFrame:CGRectMake(x , self.underline.frame.origin.y, w, CGRectGetHeight(self.underline.frame))];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.underline setFrame:CGRectMake(x , self.underline.frame.origin.y, w, CGRectGetHeight(self.underline.frame))];
    }
}

-(void)setSelectItemWithIndex:(NSInteger)index
{
    NSInteger count = self.itemArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        UIButton *item = self.itemArray[i];
        if (i == index) {
            [item setTitleColor:_titleSelectCorlor forState:UIControlStateNormal];
        } else {
            [item setTitleColor:_titleNormalCorlor forState:UIControlStateNormal];
        }
    }
}

- (CGFloat)getUderLineWeidth:(NSString *)title
{
    if (self.lineType == DLTopBarUderlineType_equBtnWidth) {
        
        return self.itemWidth;
    }else
    {
       return [self getTitleWeidth:title];
    }
}

- (CGFloat)getTitleWeidth:(NSString *)title
{

    //设置字体的大小
    UIFont *myFont = [UIFont fontWithName:TextFontName size:17];
    NSDictionary *dict = @{NSFontAttributeName:myFont};
    //设置文本能占用的最大宽高
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    CGRect rect =  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    
    return rect.size.width;
    
}

@end
