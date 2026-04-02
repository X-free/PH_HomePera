//
//  CameraAlbumManager.m
//  OPherame
//
//  Created by todesk on 2025/6/26.
//

#import "CameraAlbumManager.h"
#import "PhotoConfirmation.h"
#import "UIViewController+TopMost.h"
@interface CameraAlbumManager () <AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, copy) CameraAlbumResultBlock completionBlock;
@property (nonatomic, assign) BOOL allowSwitchCamera;

@end

@implementation CameraAlbumManager

+ (instancetype)sharedManager {
    static CameraAlbumManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CameraAlbumManager alloc] init];
    });
    return instance;
}

#pragma mark - 拍照功能

- (void)takePhotoWithViewController:(UIViewController *)viewController
                 allowSwitchCamera:(BOOL)allowSwitchCamera
                            frame:(CGRect)frame
                       completion:(CameraAlbumResultBlock)completion {
    
    self.presentingViewController = viewController;
    self.completionBlock = completion;
    self.allowSwitchCamera = allowSwitchCamera;
    
    // 检查相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        [self showCameraPermissionAlert];
        if (completion) {
            completion(nil, [self errorWithMessage:@"无相机权限" code:1001]);
        }
        return;
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
             
            
        // 未决定，请求权限
        [self requestCameraPermission:frame];
        
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        // 初始化相机界面
        [self setupCameraUIWithFrame:frame];
    }
    
    
}

- (void)requestCameraPermission:(CGRect)frame {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                // 初始化相机界面
                [self setupCameraUIWithFrame:frame];
            } else {
                [self showCameraPermissionAlert];
            }
        });
    }];
}


- (void)setupCameraUIWithFrame:(CGRect)frame {
    
    
    // 创建自定义相机界面
        UIViewController *cameraVC = [[UIViewController alloc] init];
        cameraVC.view.backgroundColor = [UIColor blackColor];
        
        // 初始化AVCaptureSession
        [self setupCaptureSession];
        
        // 添加预览层
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
   
        previewLayer.frame = frame;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [cameraVC.view.layer addSublayer:previewLayer];
        
        // 添加拍照按钮
        UIButton *captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        captureButton.frame = CGRectMake((cameraVC.view.bounds.size.width - 70)/2,
                                       cameraVC.view.bounds.size.height - 100,
                                       70, 70);
        captureButton.backgroundColor = [UIColor whiteColor];
        captureButton.layer.cornerRadius = 35;
        [captureButton addTarget:self action:@selector(capturePhoto) forControlEvents:UIControlEventTouchUpInside];
        [cameraVC.view addSubview:captureButton];
        
        // 添加切换摄像头按钮（如果允许）
        if (self.allowSwitchCamera) {
            UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            switchButton.frame = CGRectMake(cameraVC.view.bounds.size.width - 70, 50, 50, 50);
            [switchButton setImage:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath"] forState:UIControlStateNormal];
            [switchButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
            [cameraVC.view addSubview:switchButton];
        }
        
        // 添加取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(20, 50, 50, 50);
    [cancelButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dismissCamera) forControlEvents:UIControlEventTouchUpInside];
        [cameraVC.view addSubview:cancelButton];
        
        // 呈现相机界面
    cameraVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.presentingViewController presentViewController:cameraVC animated:YES completion:^{
            // 开始会话
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.captureSession startRunning];
            });
        }];
    
}

- (void)dismissCamera {
    // 停止会话
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession stopRunning];
    });
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
   
}

- (void)setupCaptureSession {
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    // 根据allowSwitchCamera决定使用前置还是后置摄像头
        AVCaptureDevicePosition position = self.allowSwitchCamera ?
            AVCaptureDevicePositionBack :  // 允许切换时默认后置
            AVCaptureDevicePositionFront;  // 不允许切换时强制前置
    
    // 获取后置摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                                mediaType:AVMediaTypeVideo
                                                                 position:position];
    
    // 创建输入
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
    
    // 创建输出
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.captureSession canAddOutput:self.photoOutput]) {
        [self.captureSession addOutput:self.photoOutput];
    }
}

- (void)capturePhoto {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)switchCamera {
    [self.captureSession beginConfiguration];
    
    AVCaptureDevice *newCamera = nil;
    AVCaptureDevicePosition position = self.videoInput.device.position;
    if (position == AVCaptureDevicePositionBack) {
        newCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                      mediaType:AVMediaTypeVideo
                                                       position:AVCaptureDevicePositionFront];
    } else {
        newCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                      mediaType:AVMediaTypeVideo
                                                       position:AVCaptureDevicePositionBack];
    }
    
    // 创建新的输入
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    // 移除旧输入，添加新输入
    [self.captureSession removeInput:self.videoInput];
    if ([self.captureSession canAddInput:newInput]) {
        [self.captureSession addInput:newInput];
        self.videoInput = newInput;
    } else {
        [self.captureSession addInput:self.videoInput];
    }
    
    [self.captureSession commitConfiguration];
}



#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output
didFinishProcessingPhoto:(AVCapturePhoto *)photo
                error:(NSError *)error {
    
    if (error) {
        if (self.completionBlock) {
            self.completionBlock(nil, error);
        }
        return;
    }
    
    NSData *imageData = [photo fileDataRepresentation];
    UIImage *image = [UIImage imageWithData:imageData];
    
    // 如果是前置摄像头拍摄的照片，需要水平翻转
    if (self.videoInput.device.position == AVCaptureDevicePositionFront) {
        image = [UIImage imageWithCGImage:image.CGImage
                                   scale:image.scale
                             orientation:UIImageOrientationLeftMirrored];
    }
    
    
    // 显示确认页面
    __weak typeof(self) weakSelf = self;
    PhotoConfirmation *confirmationVC = [[PhotoConfirmation alloc]
        initWithImage:image
        confirmationHandler:^(BOOL confirmed) {
            if (confirmed) {
                // 用户确认使用照片
                // 回调
                if (weakSelf.completionBlock) {
                    
                    weakSelf.completionBlock([weakSelf smartCompressImage:image targetKB:490], nil);
                }
                
                // 关闭相机界面
                [weakSelf dismissCamera];
                
            } else {
                // 用户选择重拍
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self.captureSession startRunning];
                });
            }
        }];
    
    confirmationVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController topMostViewController] presentViewController:confirmationVC animated:YES completion:nil];
    
    
    
   
}

#pragma mark - 相册功能

- (void)pickImageFromAlbumWithViewController:(UIViewController *)viewController
                                 completion:(CameraAlbumResultBlock)completion {
    
    self.presentingViewController = viewController;
    self.completionBlock = completion;
    
    // 检查相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        [self showPhotoLibraryPermissionAlert];
        if (completion) {
            completion(nil, [self errorWithMessage:@"无相册权限" code:1002]);
        }
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    [viewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) {
            self.completionBlock([self smartCompressImage:image targetKB:490], nil);
        }
    }];
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (self.completionBlock) {
        self.completionBlock(nil, [self errorWithMessage:@"用户取消了选择" code:1003]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 权限提示

- (void)showCameraPermissionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil//相机权限未开启
                                                                 message:@"To complete identity verification, Credit Peso needs to use your camera to capture photos of your ID document and a selfie."//请前往设置开启相机权限
                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openSystemSettings];
    }];
    
    [alert addAction:cancel];
    [alert addAction:settings];
    
    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showPhotoLibraryPermissionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil//相册权限未开启
                                                                 message:@"To complete identity verification, Credit Peso requires access to your photo gallery to retrieve your ID document photo."//请前往设置开启相册权限
                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openSystemSettings];
    }];
    
    [alert addAction:cancel];
    [alert addAction:settings];
    
    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
}

- (void)openSystemSettings {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - 辅助方法

- (NSError *)errorWithMessage:(NSString *)message code:(NSInteger)code {
    return [NSError errorWithDomain:@"CameraAlbumError"
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}


//图片压缩到800KB以内
- (NSData *)smartCompressImage:(UIImage *)image targetKB:(NSInteger)targetKB {
    NSInteger maxLength = targetKB * 1024;
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    
    // 如果原始大小已经小于目标大小，直接返回
    if (data.length < maxLength) return data;
    
    // 先尝试压缩质量
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    
    // 如果质量压缩后仍然过大，调整尺寸
    if (data.length > maxLength) {
        UIImage *resultImage = [UIImage imageWithData:data];
        NSUInteger lastDataLength = 0;
        while (data.length > maxLength && data.length != lastDataLength) {
            lastDataLength = data.length;
            CGFloat ratio = (CGFloat)maxLength / data.length;
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            data = UIImageJPEGRepresentation(resultImage, compression);
        }
    }
    
    return data;
}
@end
