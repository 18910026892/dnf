//
//  DLFile.h
//  DreamerFoundation
//
//  Created by Ant on 16/12/21.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLJSONObject.h"
#import "DLJSONArray.h"


@interface DLFile : NSObject


/**
 *  确保子路径在 Library 目录中存在，如果不存则创建它。
 *
 *  @param subPath 子路径
 *  @param skip 当创建子路径时，指示其是否跳过 iCloud 自动备份
 *
 *  @return 如果咱径存在或创建成功返回完成路径，否则返回 nil。
 */
+ (NSString * _Nullable)ensureDirectoryInLibrary:(NSString * _Nonnull)subPath skipBackup:(BOOL)skip;

/**
 *  确保子路径在 Document 目录中存在，如果不存则创建它。
 *
 *  @param subPath 子路径
 *  @param skip 当创建子路径时，指示其是否跳过 iCloud 自动备份
 *
 *  @return 如果咱径存在或创建成功返回完成路径，否则返回 nil。
 */
+ (NSString * _Nullable)ensureDirectoryInDocument:(NSString * _Nonnull)subPath skipBackup:(BOOL)skip;

/**
 *  确保某一个目录存在，如果不存在则尝试创建这个目录。
 *
 *  @param path   路径
 *
 *  @return 如果目录存在 1，如果创建成功返回 2，如果创建失败则返回 0。
 */
+(int)ensureDirectory:(NSString* _Nonnull)path;

/**
 *  判断一个文件或路径是否存在。
 *
 *  @param fullPath 等检测的路径
 *
 *  @return 是否存在
 */
+ (BOOL)isExist:(NSString * _Nonnull)fullPath;

/**
 *  按文本模式读取文件内容
 *
 *  @param fullPath 文件全路径
 *
 *  @return 返回文件内容，如果文件不存在则返回容，如果文件内容为空则返回空串。
 */
+ (NSString* _Nullable) readFileWithString:(NSString * _Nonnull)fullPath;

/**
 *  按 JSONObject 模式读取文件内容
 *
 *  @param fullPath 文件全路径
 *
 *  @return 返回文件内容，如果文件不存在、内容为空、格式正确则返回 null。
 */
+ (DLJSONObject* _Nullable) readFileWithJSONObject:(NSString * _Nonnull)fullPath;

/**
 *  按 JSONArray 模式读取文件内容
 *
 *  @param fullPath 文件全路径
 *
 *  @return 返回文件内容，如果文件不存在、内容为空、格式正确则返回 null。
 */
+ (DLJSONArray* _Nullable) readFileWithJSONArray:(NSString * _Nonnull)fullPath;

/**
 *  解压缩 Zip 文件
 *
 *  @param zipFilePath Zip 文件路径
 *  @param directory   展开目录，如果目录中有文件将会被覆盖。
 *
 *  @return 如果解压缩成功则返回 true。
 */

@end
