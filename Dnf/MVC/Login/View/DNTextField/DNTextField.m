//
//  DNTextField.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/17.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNTextField.h"

@implementation DNTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawPlaceholderInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, HexRGBAlpha(0x999999, .5).CGColor);
    
    CGRect inset;
    UIFont * font;
    
    inset = CGRectMake(0, self.bounds.origin.y+10, self.bounds.size.width , self.bounds.size.height);
    font = [UIFont fontWithName:TextFontName_Light size:15];
    
    [self.placeholder drawInRect:inset withFont:font];
}


@end
