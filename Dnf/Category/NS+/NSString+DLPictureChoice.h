//
//  NSString+DLPictureChoice.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/28.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DLPictureChoice)

/**
 根据需求大小获取图片资源代码
 
 @param str 图片大小 比如 头像100-100  最新封面324-324  大厅关注封面800-800;
 
 @return 拼接好的字符串
 */
- (NSString *)stringWithSizeString:(NSString *)str;


@end
