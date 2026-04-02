//
//  NetworkManager.h
//  OPherame
//
//  Created by todesk on 2025/6/16.
//
/*
 GET 请求示例
 [[NetworkManager sharedManager] GET:@"https://api.example.com/users"
                         parameters:@{@"page": @1}
                            headers:nil
                           progress:nil
                            success:^(id responseObject) {
     NSLog(@"获取用户列表成功: %@", responseObject);
 } failure:^(NSError *error) {
     NSLog(@"获取用户列表失败: %@", error.localizedDescription);
 }];
 
 
 POST 请求示例
 [[NetworkManager sharedManager] POST:@"https://api.example.com/login"
                          parameters:@{@"username": @"user1", @"password": @"123456"}
                             headers:nil
                            progress:nil
                             success:^(id responseObject) {
     NSLog(@"登录成功: %@", responseObject);
 } failure:^(NSError *error) {
     NSLog(@"登录失败: %@", error.localizedDescription);
 }];
 
 文件上传示例
 UIImage *image1 = [UIImage imageNamed:@"avatar1"];
 UIImage *image2 = [UIImage imageNamed:@"avatar2"];
 NSData *imageData1 = UIImageJPEGRepresentation(image1, 0.8);
 NSData *imageData2 = UIImageJPEGRepresentation(image2, 0.8);

 [[NetworkManager sharedManager] upload:@"https://api.example.com/upload"
                            parameters:nil
                               headers:nil
                             fileDatas:@[imageData1, imageData2]
                             fileNames:@[@"avatar1.jpg", @"avatar2.jpg"]
                             mimeTypes:@[@"image/jpeg", @"image/jpeg"]
                             formName:@"files"
                             progress:^(NSProgress *progress) {
     NSLog(@"上传进度: %.2f%%", progress.fractionCompleted * 100);
 } success:^(id responseObject) {
     NSLog(@"上传成功: %@", responseObject);
 } failure:^(NSError *error) {
     NSLog(@"上传失败: %@", error.localizedDescription);
 }];
 
 文件下载示例
 [[NetworkManager sharedManager] download:@"https://example.com/largefile.zip"
                              destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
     // 设置下载文件保存路径
     NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
     NSString *filePath = [documentsPath stringByAppendingPathComponent:response.suggestedFilename];
     return [NSURL fileURLWithPath:filePath];
 } progress:^(NSProgress *progress) {
     NSLog(@"下载进度: %.2f%%", progress.fractionCompleted * 100);
 } success:^(NSURLResponse *response, NSURL *filePath) {
     NSLog(@"下载完成，文件保存到: %@", filePath);
 } failure:^(NSError *error) {
     NSLog(@"下载失败: %@", error.localizedDescription);
 }];
 
 */
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^SuccessBlock)(id _Nullable responseObject);
typedef void(^FailureBlock)(NSError * _Nonnull error);
typedef void(^ProgressBlock)(NSProgress * _Nonnull progress);


typedef void (^NetworkStatusCallback)(BOOL hasNetwork, NSString *networkType);
NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject


+ (instancetype)sharedManager;

// GET请求
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                      headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                     progress:(nullable ProgressBlock)progress
                      success:(nullable SuccessBlock)success
                      failure:(nullable FailureBlock)failure;

// POST请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
                       headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      progress:(nullable ProgressBlock)progress
                       success:(nullable SuccessBlock)success
                       failure:(nullable FailureBlock)failure;

// 上传文件
- (NSURLSessionDataTask *)upload:(NSString *)URLString
                     parameters:(nullable id)parameters
                        headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      fileDatas:(nullable NSArray<NSData *> *)fileDatas
                      fileNames:(nullable NSArray<NSString *> *)fileNames
                      mimeTypes:(nullable NSArray<NSString *> *)mimeTypes
                      formName:(NSString *)formName
                      progress:(nullable ProgressBlock)progress
                       success:(nullable SuccessBlock)success
                       failure:(nullable FailureBlock)failure;

// 下载文件
- (NSURLSessionDownloadTask *)download:(NSString *)URLString
                           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                             progress:(nullable ProgressBlock)progress
                              success:(nullable void (^)(NSURLResponse *response, NSURL *filePath))success
                              failure:(nullable FailureBlock)failure;

// 添加公共参数
- (id)addCommonParameters:(nullable id)parameters;

//get原生请求，获取缓存数据。
- (void)GET:(NSString *)urlString
 completion:(void (^)(NSDictionary *response, NSError *error))completion;

//是否有网络
+ (void)startMonitoringNetworkStatusWithCallback:(NetworkStatusCallback)callback;

// 检查当前网络状态
- (BOOL)isNetworkAvailable;



// googleMarket POST请求
- (NSURLSessionDataTask *)googleMarketPOST:(NSString *)URLString
                    parameters:(nullable id)parameters
                       headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      progress:(nullable ProgressBlock)progress
                       success:(nullable SuccessBlock)success
                       failure:(nullable FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
