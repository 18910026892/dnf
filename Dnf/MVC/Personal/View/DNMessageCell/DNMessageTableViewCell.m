//
//  DNMessageTableViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNMessageTableViewCell.h"
#import "DNTextContentView.h"
@implementation DNMessageTableViewCell


- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"message_official_avatar"];
    
    }
    return _icon;
}


- (UIView *)messageView {
    if (!_messageView) {
        _messageView = [UIView new];
    }
    return _messageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview: self.icon];
        [self.contentView addSubview: self.messageView];
 
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.messageModel == nil) return;

    
    self.icon.width = 42;
    self.icon.height = 42;
    self.icon.y = BACKGROUND_WITH_CELL_SPAC;
    
    self.messageView.height = self.messageModel.contentSize.height < self.icon.height ? self.icon.height : self.messageModel.contentSize.height;
    
    self.messageView.width = self.messageModel.contentSize.width;
    self.messageView.y = BACKGROUND_WITH_CELL_SPAC;

    self.icon.x = 10;
    self.messageView.x = 10 + self.icon.width;
   
    self.icon.layer.cornerRadius = self.icon.width / 2.0;
    self.icon.layer.masksToBounds = YES;

}


- (void)setMessageModel:(DNMessageModel *)messageModel {
    if (!messageModel) return;
    _messageModel = messageModel;
 
    
    //放一个头像占位图就可以了
    self.icon.backgroundColor = kThemeColor;
    self.height = messageModel.cellHeight;  //重新算一下视图的高度

    if (![self.messageView isMemberOfClass:[DNTextContentView class]]) {
        [self.messageView removeFromSuperview];
        
        self.messageView = [[DNTextContentView alloc] init];
        [self.contentView addSubview:self.messageView];
    }
    
    CGRect frame = CGRectMake(0, 0, self.messageModel.contentSize.width, self.messageModel.contentSize.height);
    
    [(DNTextContentView *)self.messageView setMessage:messageModel.message  frame:frame];
    [self layoutIfNeeded];
}






@end
