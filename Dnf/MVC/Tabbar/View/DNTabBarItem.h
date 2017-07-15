//
//  DNTabBarItem.h
//  Dnf
//
//  Created by 巩鑫 on 2017/7/11.
//  Copyright © 2017年 点寰科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item : NSObject

/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;

/**
 *  正常的Icon
 */
@property (nonatomic,copy) NSString *imageString;

/**
 *  选中的Icon
 */
@property (nonatomic,copy) NSString *imageString_select;

/**
 *  Item初始化方法
 */

-(instancetype)initItemWithDictionary:(NSDictionary *)dict;

@end

typedef void(^Complete)();

@interface DNTabBarItem : UIView


/**
 *  Item 对象 （用来存储每个Item上的标题，图片）
 */

@property(nonatomic,strong)Item        *  item;

/**
 *  Icon 图片视图
 */
@property(nonatomic,strong)UIImageView *  iconImageView;

/**
 *  标题标签
 */
@property(nonatomic,strong)UILabel     *  titleLabel;

/**
 *  选中的样式
 */
-(void)setItemSlected:(Complete)finish;

/**
 *  正常的样式
 */
-(void)setItemNomal;

@end
