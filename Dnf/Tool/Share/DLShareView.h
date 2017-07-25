//
//  DLShareView.h
//  Dreamer
//
//  Created by frank on 16/10/4.
//  Copyright © 2016年 Beijing Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    weixin,
    weibo,
    pengyou,
    qq,
    kongjian,
    facebook,
    twitter,
    instagram,
}Share;

@interface DLShareView : UIView

@property(nonatomic,copy)NSString *userId;
//是否被拉黑
@property(nonatomic,assign)BOOL isExistsBlack;
//分享的类型(平台)
@property(nonatomic,assign)int type;
//分享的资源类型 （直播前，直播中，回放等）
@property(nonatomic,copy)NSString * resourcesType;
//房间号
@property(nonatomic,copy)NSString *roomId;

@property(nonatomic,strong)NSDictionary *shareDict;

// isShowLaHei是否被拉黑   type分享的类型   roomID房间号

+(void)showMyShareViewWothSuperView:(UIView *)superView
                        isShowLaHei:(BOOL)bl
                             userId:(NSString *)userId
                            andType:(int)type
                      resourcesType:(NSString*)resourceType
                          andRoomID:(NSString *)roomID
                       andShareDict:(NSDictionary*)dict
                          backColor:(UIColor *)backColor;
/**
 移除分享view
 
 @param superView 分享view的父视图
 */
+(void)removeShareViewWithSuperView:(UIView *)superView;


-(instancetype)initWithFrame:(CGRect)frame
                 isShowLaHei:(BOOL)bl
                      userId:(NSString *)userId
                        type:(int)type
               resourcesType:(NSString*)resourceType
                      roomID:(NSString *)roomID
                andShareDict:(NSDictionary *)dict
                   backColor:(UIColor *)backColor;

- (instancetype)initWithScreenshotsShareWithFrame:(CGRect)frame
                                           userId:(NSString *)userId
                                             type:(int)type
                                    resourcesType:(NSString*)resourceType
                                           roomID:(NSString *)roomID
                                     andShareDict:(NSDictionary *)dict
                                        backColor:(UIColor *)backColor;

-(void)tapView;


@end
