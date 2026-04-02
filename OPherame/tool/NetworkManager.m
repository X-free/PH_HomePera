//
//  NetworkManager.m
//  OPherame
//
//  Created by todesk on 2025/6/16.
//

#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "BeiMInfoUtil.h"
#import <CommonCrypto/CommonCrypto.h>



NSString *const kAppUrl = @"http://8.220.140.188:8083/blewapi";

@interface NetworkManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        
        // 配置请求序列化器
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _sessionManager.requestSerializer.timeoutInterval = 15.0;
        
        // 配置响应序列化器
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return self;
}

#pragma mark - 私有方法

// 添加公共请求头
- (NSDictionary *)addCommonHeaders:(nullable NSDictionary *)headers {
    NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
    if (headers) {
        [mutableHeaders addEntriesFromDictionary:headers];
    }
    
    // 添加公共请求头
    [mutableHeaders setValue:@"iOS" forKey:@"X-Client-Platform"];
    [mutableHeaders setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"X-Client-Version"];
    
    // 添加认证token
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"];
    if (token) {
        [mutableHeaders setValue:[NSString stringWithFormat:@"%@", token] forKey:@"token"];
    }
    
    return [mutableHeaders copy];
}

// 添加公共参数
- (id)addCommonParameters:(nullable id)parameters {
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [mutableParams setValue:[[UIDevice currentDevice] systemName] forKey:@"enthusiastically"];
        [mutableParams setValue:[BeiMInfoUtil getAppVersion] forKey:@"bursting"];
        [mutableParams setValue:[BeiMInfoUtil getDeviceModel] forKey:@"palm"];
        [mutableParams setValue:[BeiMInfoUtil getOrCreateIDFV] forKey:@"emptied"];
        [mutableParams setValue:[BeiMInfoUtil getOSVersion] forKey:@"believed"];
        [mutableParams setValue:@"yourloanapi" forKey:@"childhood"];
        // 添加认证token
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"];
        if (token) {
            [mutableParams setValue:token forKey:@"slice"];
        }
        [mutableParams setValue:[BeiMInfoUtil getOrCreateIDFV] forKey:@"palate"];
        [mutableParams setValue:[RandomStringGenerator randomlyCallMethod] forKey:@"boyfine"];
        return [mutableParams copy];
    }
    
    return parameters;
}

// 统一错误处理
- (void)handleError:(NSError *)error {
    if (error.code == NSURLErrorTimedOut) {
        NSLog(@"请求超时");
    } else if (error.code == NSURLErrorNotConnectedToInternet) {
        NSLog(@"无网络连接");
    } else {
        NSLog(@"网络错误: %@", error.localizedDescription);
    }
    
    // 可以根据错误码执行特定操作，比如token过期跳转登录
    if (error.code == 401) {
        // token过期处理
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserTokenExpiredNotification" object:nil];
    }
}

#pragma mark - 公共方法

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                      headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                     progress:(nullable ProgressBlock)progress
                      success:(nullable SuccessBlock)success
                      failure:(nullable FailureBlock)failure {
    // 显示Loading
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = @"Loading...";
    
    
    
    // 添加公共参数和请求头
//    parameters = [self addCommonParameters:parameters];
//    headers = [self addCommonHeaders:headers];
    URLString = [BeiMInfoUtil appendParamsToURL:[kAppUrl stringByAppendingString:URLString] params:[self addCommonParameters:parameters]];
    
    return [self.sessionManager GET:URLString
                        parameters:nil
                           headers:headers 
            
                          progress:progress
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏Loading
        [MBProgressHUD hideHUDForView:window animated:YES];
        
        if([responseObject[@"heavy"] isEqualToString:@"-2"]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
            window.rootViewController = navOdController;
            [window makeKeyAndVisible];
        }else{
            if (success) {
                success(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleError:error];
        // 隐藏Loading
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (failure) {
            failure(error);
        }
    }];
    
    
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
                       headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      progress:(nullable ProgressBlock)progress
                       success:(nullable SuccessBlock)success
                       failure:(nullable FailureBlock)failure {
   
    // 显示Loading
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = @"loading...";
    

    
    // 添加公共参数和请求头
//    parameters = [self addCommonParameters:parameters];
//    headers = [self addCommonHeaders:headers];
   
    if(headers){
        
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        URLString = [BeiMInfoUtil appendParamsToURL:[kAppUrl stringByAppendingString:URLString] params:[self addCommonParameters:nil]];
        
//        [_sessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        
    }else{
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        URLString = [BeiMInfoUtil appendParamsToURL:[kAppUrl stringByAppendingString:URLString] params:[self addCommonParameters:nil]];
    }
    
    
    
    
    return [self.sessionManager POST:URLString
                          parameters:headers?parameters:nil  // 参数放在body中，所以这里传nil
                             headers:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if(!headers){
            [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *stringValue = nil;
                
                // 处理不同类型的值
                if ([obj isKindOfClass:[NSString class]]) {
                    stringValue = obj;
                } else if ([obj isKindOfClass:[NSNumber class]]) {
                    stringValue = [obj stringValue];
                } else if ([obj isKindOfClass:[NSData class]]) {
                    // 如果是NSData直接添加
                    [formData appendPartWithFormData:obj name:key];
                    return;
                } else {
                    // 其他类型转为字符串
                    stringValue = [obj description];
                }
                
                [formData appendPartWithFormData:[stringValue dataUsingEncoding:NSUTF8StringEncoding]
                                               name:key];
            }];
        }
        
        if(headers){
            [formData appendPartWithFileData:parameters[@"grain"]
                                               name:@"grain"
                                           fileName:[NSString stringWithFormat:@"%@.jpg",[self generateTimeStringWithRandomNumber]]
                                           mimeType:@"image/jpeg"];
        }
        
      
        
        
    } progress:progress
      success:^(NSURLSessionDataTask *task, id responseObject) {
        // 隐藏Loading
        [MBProgressHUD hideHUDForView:window animated:YES];
        
        // 尝试解析JSON
        if([responseObject[@"heavy"] isEqualToString:@"-2"]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
            window.rootViewController = navOdController;
            [window makeKeyAndVisible];
        }else{
            if (success) {
                success(responseObject);
            }
        }
          
        
    }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 隐藏Loading
        [MBProgressHUD hideHUDForView:window animated:YES];
        if (failure) failure(error);
    }];
    

        
    
    
    //    return [self.sessionManager POST:URLString
    //                         parameters:parameters
    //                            headers:headers
    //                           progress:progress
    //                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        if (success) {
    //            success(responseObject);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        [self handleError:error];
    //        if (failure) {
    //            failure(error);
    //        }
    //    }];
}


// googleMarket POST请求
- (NSURLSessionDataTask *)googleMarketPOST:(NSString *)URLString
                    parameters:(nullable id)parameters
                       headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      progress:(nullable ProgressBlock)progress
                       success:(nullable SuccessBlock)success
                                   failure:(nullable FailureBlock)failure{
    
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    URLString = [BeiMInfoUtil appendParamsToURL:[kAppUrl stringByAppendingString:URLString] params:[self addCommonParameters:nil]];
    
    return [self.sessionManager POST:URLString
                          parameters:nil  // 参数放在body中，所以这里传nil
                             headers:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if(!headers){
            [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *stringValue = nil;
                
                // 处理不同类型的值
                if ([obj isKindOfClass:[NSString class]]) {
                    stringValue = obj;
                } else if ([obj isKindOfClass:[NSNumber class]]) {
                    stringValue = [obj stringValue];
                } else if ([obj isKindOfClass:[NSData class]]) {
                    // 如果是NSData直接添加
                    [formData appendPartWithFormData:obj name:key];
                    return;
                } else {
                    // 其他类型转为字符串
                    stringValue = [obj description];
                }
                
                [formData appendPartWithFormData:[stringValue dataUsingEncoding:NSUTF8StringEncoding]
                                               name:key];
            }];
        }
    
    } progress:progress
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        if (failure) failure(error);
    }];
}



- (NSURLSessionDataTask *)upload:(NSString *)URLString
                     parameters:(nullable id)parameters
                        headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      fileDatas:(nullable NSArray<NSData *> *)fileDatas
                      fileNames:(nullable NSArray<NSString *> *)fileNames
                      mimeTypes:(nullable NSArray<NSString *> *)mimeTypes
                      formName:(NSString *)formName
                      progress:(nullable ProgressBlock)progress
                       success:(nullable SuccessBlock)success
                       failure:(nullable FailureBlock)failure {
    
    // 显示Loading
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = @"loading...";
    
    
    
    // 添加公共参数和请求头
//    parameters = [self addCommonParameters:parameters];
//    headers = [self addCommonHeaders:headers];
    
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    URLString = [BeiMInfoUtil appendParamsToURL:[kAppUrl stringByAppendingString:URLString] params:[self addCommonParameters:nil]];
    
    return [self.sessionManager POST:URLString
                         parameters:parameters
                            headers:headers
          constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 6. 添加参数到form-data
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *stringValue = nil;
            
            // 处理不同类型的值
            if ([obj isKindOfClass:[NSString class]]) {
                stringValue = obj;
            } else if ([obj isKindOfClass:[NSNumber class]]) {
                stringValue = [obj stringValue];
            } else if ([obj isKindOfClass:[NSData class]]) {
                // 如果是NSData直接添加
                [formData appendPartWithFormData:obj name:key];
                return;
            } else {
                // 其他类型转为字符串
                stringValue = [obj description];
            }
            
            // 添加到form-data
            [formData appendPartWithFormData:[stringValue dataUsingEncoding:NSUTF8StringEncoding]
                                        name:key];
        }];
        
        // 添加多个文件
        for (NSInteger i = 0; i < fileDatas.count; i++) {
            NSString *fileName = fileNames.count > i ? fileNames[i] : [NSString stringWithFormat:@"file%ld", (long)i];
            NSString *mimeType = mimeTypes.count > i ? mimeTypes[i] : @"application/octet-stream";
            
            [formData appendPartWithFileData:fileDatas[i]
                                        name:formName
                                    fileName:fileName
                                    mimeType:mimeType];
        }
        
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *jsonError;
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject
                                                        options:NSJSONReadingAllowFragments
                                                          error:&jsonError];
        
        if (!jsonError) {
            NSLog(@"JSON响应: %@", jsonResponse);
            if([jsonResponse[@"heavy"] isEqualToString:@"-2"]){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                OPhNavigationController *navOdController = [[OPhNavigationController alloc]initWithRootViewController:[[VeiLogController alloc] init]];
                window.rootViewController = navOdController;
                [window makeKeyAndVisible];
            }else{
                if (success) {
                    success(jsonResponse);
                }
            }
        } else {
            NSLog(@"非JSON响应: %@", jsonError);
        }
        
        /*
        // 隐藏Loading
        [MBProgressHUD hideHUDForView:window animated:YES];
        if([responseObject[@"heavy"] isEqualToString:@"-2"]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            VeiLogController *veiLogController = [[VeiLogController alloc] init];
            window.rootViewController = veiLogController;
            [window makeKeyAndVisible];
        }else{
            if (success) {
                success(responseObject);
            }
        }*/
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 隐藏Loading
        [MBProgressHUD hideHUDForView:window animated:YES];
        [self handleError:error];
        if (failure) {
            failure(error);
        }
    }];
}

- (NSURLSessionDownloadTask *)download:(NSString *)URLString
                           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                             progress:(nullable ProgressBlock)progress
                              success:(nullable void (^)(NSURLResponse *response, NSURL *filePath))success
                              failure:(nullable FailureBlock)failure {
    
    URLString = [kAppUrl stringByAppendingString:URLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    return [self.sessionManager downloadTaskWithRequest:request
                                             progress:progress
                                          destination:destination
                                    completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [self handleError:error];
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(response, filePath);
            }
        }
    }];
}

- (NSString *)generateTimeStringWithRandomNumber {
    // 1. 获取当前时间并格式化为字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    
    // 2. 生成一个4位随机数
    int randomNumber = arc4random_uniform(9000) + 1000; // 生成1000-9999之间的随机数
    
    // 3. 组合时间字符串和随机数
    NSString *result = [NSString stringWithFormat:@"%@%d", timeString, randomNumber];
    
    return result;
}


//get原生请求，获取缓存数据。
- (void)GET:(NSString *)urlString
 completion:(void (^)(NSDictionary *response, NSError *error))completion {
    
    // 1. 检查缓存
    NSDictionary *cachedData = [self getCachedDataForURL:urlString];
    if (cachedData) {
        NSLog(@"Using cached data");
        NSError *error;
        id decodedObject = [NSJSONSerialization JSONObjectWithData:(NSData*)cachedData
                                                             options:kNilOptions
                                                               error:&error];
        completion(decodedObject, nil);
        return;
    }
    
    // 2. 没有缓存则发起网络请求
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }
        
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, jsonError);
            });
            return;
        }
        
        // 3. 缓存响应数据
        [self cacheData:responseDict forURL:urlString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseDict, nil);
        });
    }];
    
    [task resume];
}

#pragma mark - 缓存管理

- (NSDictionary *)getCachedDataForURL:(NSString *)urlString {
    NSString *cacheKey = [self cacheKeyForURL:urlString];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:cacheKey];
}

- (void)cacheData:(NSDictionary *)data forURL:(NSString *)urlString {
    NSString *cacheKey = [self cacheKeyForURL:urlString];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    
    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
//                                                      options:0
//                                                        error:&error];
    
    NSData *jsonData = [self safeJSONDataWithObject:data options:0 error:&error];
    if(error == nil){
        [defaults setObject:jsonData forKey:cacheKey];
        [defaults synchronize];
        
        // 设置缓存过期时间（例如1小时）
        NSTimeInterval expirationInterval = 3600;
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expirationInterval];
        NSString *expirationKey = [NSString stringWithFormat:@"%@_expiration", cacheKey];
        [defaults setObject:expirationDate forKey:expirationKey];
        [defaults synchronize];
    }
   
}

- (NSData *)safeJSONDataWithObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error {
    @try {
        if (![NSJSONSerialization isValidJSONObject:obj]) {
            *error = [NSError errorWithDomain:@"JSONError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"Invalid JSON object"}];
            return nil;
        }
        return [NSJSONSerialization dataWithJSONObject:obj options:opt error:error];
    } @catch (NSException *ex) {
        *error = [NSError errorWithDomain:@"JSONError" code:500 userInfo:@{NSLocalizedDescriptionKey: ex.reason}];
        return nil;
    }
}


- (BOOL)isCacheValidForURL:(NSString *)urlString {
    NSString *cacheKey = [self cacheKeyForURL:urlString];
    NSString *expirationKey = [NSString stringWithFormat:@"%@_expiration", cacheKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *expirationDate = [defaults objectForKey:expirationKey];
    
    if (!expirationDate) {
        return NO;
    }
    
    return [[NSDate date] compare:expirationDate] == NSOrderedAscending;
}

- (NSString *)cacheKeyForURL:(NSString *)urlString {
    // 使用URL的MD5作为缓存键
    const char *ptr = [urlString UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    
    return output;
}


// 在 NetworkManager.m 中添加
+ (void)startMonitoringNetworkStatusWithCallback:(NetworkStatusCallback)callback {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BOOL hasNetwork = NO;
        NSString *networkType = @"无网络";
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                hasNetwork = YES;
                networkType = @"蜂窝网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNetwork = YES;
                networkType = @"WiFi网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                hasNetwork = NO;
                networkType = @"无网络";
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                hasNetwork = NO;
                networkType = @"网络状态未知";
                break;
        }
        
        if (callback) {
            callback(hasNetwork, networkType);
        }
    }];
    
    [manager startMonitoring];
}

// 检查当前网络状态
- (BOOL)isNetworkAvailable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}


// 取消所有请求
- (void)cancelAllRequests {
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        [task cancel];
    }
}

// 取消特定URL的请求
- (void)cancelRequestsWithURL:(NSString *)URLString {
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        if ([task.originalRequest.URL.absoluteString hasPrefix:URLString]) {
            [task cancel];
        }
    }
}

// 设置缓存策略
- (void)setCachePolicy:(NSURLRequestCachePolicy)policy {
    self.sessionManager.requestSerializer.cachePolicy = policy;
}

// 清除缓存
- (void)clearCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



@end
