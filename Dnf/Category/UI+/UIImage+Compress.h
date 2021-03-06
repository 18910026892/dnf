//
//  compress.h
//  WPWProject
//
//  Created by Mr.Lu on 13-7-16.
//  Copyright (c) 2013年 Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_IMAGEPIX 1000.0 // max pix 200.0px
#define MAX_IMAGEDATA_LEN 1000000.0 // max data length 300k

@interface UIImage (Compress)

//图像质量压缩
-(UIImage *)compressedImage;

-(NSData *)compressedData;
-(NSData *)compressedDataSize:(float)size;          //kb

-(NSData *)compressedDataWithRate;

-(NSData *)compressedData:(CGFloat)compressionQuality;

//图像尺寸压缩
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

//模糊
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
//图层过量会有卡顿现象, 特别是弄圆角或者阴影会很卡, 如果设置图片圆角我们一般用绘图来做:
- (UIImage *)cutCircleImage;

/** 切成正方形 */
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;
// 把图片剪切成指定大小的正方形图片
+ (UIImage *)squareImage:(UIImage *)image size:(CGFloat)size;

@end



