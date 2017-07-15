//
//  DNSendTimeTableViewCell.m
//  Dnf
//
//  Created by 巩鑫 on 2017/7/15.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import "DNSendTimeTableViewCell.h"

#import "NIMKitUtil.h"

@interface  DNSendTimeTableViewCell()
@property(nonatomic, strong)UIButton *showTimeBtn;
@end

@implementation DNSendTimeTableViewCell

- (UIButton *)showTimeBtn {
    if (_showTimeBtn == nil) {
        _showTimeBtn = [[UIButton alloc] init];
    }
    return _showTimeBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.showTimeBtn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = (self.width - self.showTimeBtn.width) / 2;
    CGFloat y = (self.height - self.showTimeBtn.height) / 2;
    
    self.showTimeBtn.x = x;
    self.showTimeBtn.y = y;
}

- (void)setSendTime:(NSInteger)sendTime {
    _sendTime = sendTime;
    NSString *sendTimeString = [NIMKitUtil showTime:sendTime showDetail:NO];
    
    //背景 文字
    //    [self.showTimeBtn setBackgroundImage:[UIImage imageNamed:@"qipao"] forState:UIControlStateNormal];
    [self.showTimeBtn setBackgroundColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1]];
    
    [self.showTimeBtn setTitle:sendTimeString forState:UIControlStateNormal];
    self.showTimeBtn.enabled = NO;
    [self.showTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.showTimeBtn.titleLabel setTextColor:[UIColor whiteColor]];
    
    [self.showTimeBtn sizeToFit];
    self.showTimeBtn.height = 20;
    
    self.showTimeBtn.width = (self.showTimeBtn.width + 4 );
    self.width = self.showTimeBtn.width += 8;
    //    self.showTimeBtn.height = (self.showTimeBtn.height + 2);
    
    self.showTimeBtn.layer.cornerRadius = 5;
    self.showTimeBtn.clipsToBounds = YES;
    
    [self layoutSubviews];
}
@end
