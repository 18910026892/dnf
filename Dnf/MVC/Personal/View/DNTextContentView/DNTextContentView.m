//
//  DNTextContentView.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTextContentView.h"
#import "DNMessageModel.h"
@interface DNTextContentView ()
@property(nonatomic, strong)UILabel *text;
@property(nonatomic, strong)UIImageView *bubble;
@end

@implementation DNTextContentView

- (UILabel *)text {
    if (_text == nil) {
        _text = [[UILabel alloc] init];
    }
    return _text;
}

- (UIImageView *)bubble {
    if (_bubble == nil) {
        _bubble = [[UIImageView alloc] init];
    }
    return _bubble;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.bubble]; //先添加
        [self addSubview:self.text];
    }
    return self;
}
//内容相对气泡的间距
//#define CONTENT_HORIZONTAL_SPAC 8
//#define CONTENT_VERTICAL_SPAC 5
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    self.text.frame = CGRectMake(CONTENT_HORIZONTAL_SPAC, CONTENT_VERTICAL_SPAC, self.width - CONTENT_VERTICAL_SPAC * 2, self.height - CONTENT_HORIZONTAL_SPAC * 2);
    
    self.text.frame = CGRectMake(CONTENT_HORIZONTAL_SPAC, CONTENT_VERTICAL_SPAC, self.width - CONTENT_HORIZONTAL_SPAC * 2, self.height - CONTENT_VERTICAL_SPAC * 2);

    self.text.x += 13;

    self.bubble.frame = CGRectMake(10, 0, self.width, self.height);
    
    NSLog(@" bubble width %f \n bubble height %f",self.width,self.height);
    
    //    [self.text setContentOffset:CGPointMake(5, 10)];
    //    self.text.width += 10;
    
}

- (instancetype)setMessage:(NSString *)text frame:(CGRect)frame;{
    
    
    self.text.text = text;
    self.text.font = [UIFont systemFontOfSize:14];
    self.text.numberOfLines = 0;
    //设置是否可以编辑
    //    self.text.editable = NO;
    //    self.text.backgroundColor = [UIColor clearColor];
    self.frame = frame;
    
    //气泡方向
    self.bubble.image = [UIImage imageNamed:@"bubble_white"];
    [self.text setTextColor:[UIColor blackColor]];
    return self;
}


@end
