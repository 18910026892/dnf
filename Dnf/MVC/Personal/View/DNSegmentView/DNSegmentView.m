//
//  DNSegmentView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSegmentView.h"
#define SLiderHeight 3.0
static int Tag = 2000;

@interface DNSegmentView()

@property float SliderMargin;

@end

@implementation DNSegmentView

{
    UIButton *tempBtn;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.bounces = NO;
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
    }
    return self;
}

-(void)setTitleArr:(NSArray *)titles OneItemWidth:(NSInteger)Onewidth TitleFont:(UIFont *)font
{
    for(int i=0;i<titles.count;i++){
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(Onewidth*i, 0, Onewidth, self.frame.size.height);
        [btn1 setTitle:titles[i] forState:UIControlStateNormal];
        btn1.tag = i+Tag;
        [btn1 setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn1 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn1.titleLabel.font = font;
        [self addSubview:btn1];
        
        //设置默认选中第0个
        if(i==0){
            btn1.selected = YES;
            tempBtn = btn1;
        }
    }
    
    [self setContentSize:CGSizeMake(Onewidth*titles.count, 1)];
    //默认滑动条的宽度
    _SliderMargin = 15.0*320/KScreenWidth;
    _sliderWidth = Onewidth-_SliderMargin*2;
    
    _sliderView = [[UIView alloc]initWithFrame:CGRectMake((Onewidth-_sliderWidth)/2, self.frame.size.height-SLiderHeight-4, _sliderWidth, SLiderHeight)];
    _sliderView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_sliderView];
}

//重写滑动条的宽度
-(void)setSliderWidth:(float)sliderWidth
{
    if(_sliderView){
        _sliderView.frame = CGRectMake(_sliderView.origin.x+(_sliderWidth-sliderWidth)/2, _sliderView.origin.y, sliderWidth, SLiderHeight);
    }
    _SliderMargin = _SliderMargin+(_sliderWidth-sliderWidth)/2;
    _sliderWidth = sliderWidth;
}


-(void)ButtonClick:(UIButton *)btn
{
    if(btn != tempBtn){
        [self itemSelectIndex:btn.tag-Tag];
    }
}

-(void)itemSelectIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+Tag];
    tempBtn.selected = NO;
    btn.selected = YES;
    tempBtn=btn;
    

    if(_SegmentSelectedItemIndex){
        _SegmentSelectedItemIndex(index);
    }
}


/**
 *
 *根据scrollView的偏移量来移动滚动条的位置
 */
-(void)SegmentChangeWithScrollView:(UIScrollView *)scroll contentOffset:(float)offset;
{
    float sliderOffset = self.width * offset / scroll.contentSize.width;
    _sliderView.frame = CGRectMake(sliderOffset+_SliderMargin, self.frame.size.height-SLiderHeight-4, _sliderWidth, SLiderHeight);
}

/**
 *
 *item标题
 */
-(void)setTitle:(NSString *)title AtIndex:(NSInteger)index;
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+Tag];
    [btn setTitle:title forState:UIControlStateNormal];
}

@end
