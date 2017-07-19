//
//  DLPath.h
//  DreamerFoundation
//
//  Created by Ant on 16/12/21.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLPath : NSObject

/**
 *  获取主 Bundle 目录下文件的完整路径，此方法并不检测目标文件或路径是否存在。
 *
 *  @param path 相对于 Bundle 目录的相对路径，如果传 nil 则返回 Bundle 的全路径
 *
 *  @return 完整路径
 */
+ (NSString * _Nonnull)fullPathFromAssetsInMainBundle:(NSString* _Nullable)path;

/**
 *  获取主Library  目录下文件的完整路径，此方法并不检测目标文件或路径是否存在
 *
 *  @param path 相对于 Library 目录的相对路径，如果传 nil 则返回 Library 的全路径
 *
 *  @return 完整路径
 */
+ (NSString * _Nonnull)fullPathFromAssetsInLibrary:(NSString* _Nullable)path;

/**
 *  获取 Bundle 中的文件的全路径
 *
 *  @param bundle Bundle 名字（不含扩展名）
 *  @param name   文件名字（不含扩展名）
 *  @param type   文件扩展名
 *
 *  @return 如果文件不存在则返回 nil
 */
+ (NSString * _Nullable)getFullPathFromBundle:(NSString* _Nonnull)bundle
                                         file:(NSString* _Nonnull)name
                                       ofType:(NSString* _Nullable)type;

/**
 *  获取 Bundle 中的文件的全路径
 *
 *  @param bundle  Bundle 名字（不含扩展名）
 *  @param subpath 文件子路径（含扩展名）
 *
 *  @return 如果文件不存在则返回 nil
 */
+ (NSString * _Nullable)getFullPathFromBundle:(NSString* _Nonnull)bundle
                                      subpath:(NSString* _Nonnull)subpath;

@end
