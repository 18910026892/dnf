//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.frame = CGRectMake(self.frame.size.width-85, 0, 85, self.frame.size.height);
        _indexLabel.backgroundColor = HexRGBAlpha(0x000000, 0.5);
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_indexLabel.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _indexLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _indexLabel.layer.mask = maskLayer;
        
        [self addSubview:_indexLabel];
    }

}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    NSString * count = [NSString stringWithFormat:@"/%d",(int)_photos.count];
    
    NSString * indexStr = [NSString stringWithFormat:@"%d",(int)_currentPhotoIndex + 1];
    
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:indexStr];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:HexRGBAlpha(0xFb389c, 1),};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:count];
    NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor],};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    [firstPart appendAttributedString:secondPart];
    _indexLabel.attributedText = firstPart;
    
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = photo.image != nil && !photo.save;
    _saveImageBtn.hidden =!_showSaveBtn;
}

@end
