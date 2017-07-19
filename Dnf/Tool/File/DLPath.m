//
//  DLPath.m
//  DreamerFoundation
//
//  Created by Ant on 16/12/21.
//  Copyright © 2016年 Ant. All rights reserved.
//

#import "DLPath.h"
#import "DLFile.h"

@implementation DLPath

+(NSString* _Nonnull)fullPathFromAssetsInMainBundle:(NSString * _Nullable)path
{
    NSString *mainBundle = [[NSBundle mainBundle] bundlePath];
    
    if (!path || [path length] == 0) {
        return mainBundle;
    }
    
    return [mainBundle  stringByAppendingPathComponent:path];
}

+ (NSString * _Nonnull)fullPathFromAssetsInLibrary:(NSString* _Nullable)path
{
    NSArray  *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *hPath = [libPaths objectAtIndex:0];
    NSString *fullPath = [hPath stringByAppendingPathComponent:path];
    
    return fullPath;
}

+ (NSString * _Nullable)getFullPathFromBundle:(NSString* _Nonnull)bundle
                                         file:(NSString* _Nonnull)name
                                       ofType:(NSString* _Nullable)type
{
    NSBundle *b = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundle ofType:@"bundle"]];
    if (b) {
        return [b pathForResource:name ofType:type];
    }
    
    return nil;
}

+ (NSString * _Nullable)getFullPathFromBundle:(NSString* _Nonnull)bundle
                                      subpath:(NSString* _Nonnull)subpath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:bundle ofType:@"bundle"];
    if (path) {
        return [path stringByAppendingPathComponent:subpath];
    }
    
    return nil;
}

@end
