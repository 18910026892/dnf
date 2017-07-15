//
//  DNMessageModel.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNMessageModel.h"

@implementation DNMessageModel
- (float)cellHeight {
    if (_cellHeight == 0) {
        //    获取文本高度
        if (self.message == nil || ![self.message isKindOfClass:[NSString class]] || [self.message isEqualToString:@""])
            self.message = @" ";
        
        CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(KScreenWidth * 0.6, 10000) textString:self.message];
        
        _cellHeight = size.height + (CONTENT_VERTICAL_SPAC * 2) + (BACKGROUND_WITH_CELL_SPAC * 2);
        if (size.width < 10) {
            size.width = 10;
        }
    }
    return _cellHeight;
}

- (CGSize)contentSize {
    if (_contentSize.height == 0) {
        if (self.message == nil || ![self.message isKindOfClass:[NSString class]] || [self.message isEqualToString:@""])
            self.message = @" ";
        
        //气泡最大的宽的 权重是 屏幕的 0.45
        CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(KScreenWidth * 0.6, 10000) textString:self.message];
        
        if (size.width < 10)
            size.width = 10;
        _contentSize.height = size.height + CONTENT_VERTICAL_SPAC * 2;
        _contentSize.width = size.width + CONTENT_HORIZONTAL_SPAC * 2;

    }
    return _contentSize;
}

#pragma mark - private method
//计算文本size
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize textString:(NSString *)textString
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [textString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
