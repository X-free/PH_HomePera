//
//  CameraAlbumManager.h
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

typedef void (^CameraAlbumResultBlock)(UIImage * _Nullable image, NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN

@interface CameraAlbumManager : NSObject

+ (instancetype)sharedManager;

/**
 拍照功能
 @param viewController 呈现相机界面的控制器
 @param allowSwitchCamera 是否允许切换摄像头
 @param frame 相机预览框的位置和大小（非全屏）
 @param completion 完成回调
 */
- (void)takePhotoWithViewController:(UIViewController *)viewController
                 allowSwitchCamera:(BOOL)allowSwitchCamera
                            frame:(CGRect)frame
                       completion:(CameraAlbumResultBlock)completion;

/**
 从相册选择图片
 @param viewController 呈现相册界面的控制器
 @param completion 完成回调
 */
- (void)pickImageFromAlbumWithViewController:(UIViewController *)viewController
                                 completion:(CameraAlbumResultBlock)completion;

@end

NS_ASSUME_NONNULL_END
