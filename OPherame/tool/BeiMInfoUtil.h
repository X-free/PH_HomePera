//
//  BeiMInfoUtil.h
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import <Foundation/Foundation.h>

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeiMInfoUtil : NSObject
// 获取设备系统版本 (e.g. "15.4.1")
+ (NSString *)getOSVersion;

// 获取App版本号 (e.g. "1.0.0")
+ (NSString *)getAppVersion;

// 获取App构建版本号 (e.g. "123")
+ (NSString *)getAppBuildVersion;

// 获取设备名称 (e.g. "iPhone13,3")
+ (NSString *)getDeviceModel;

// 获取设备用户自定义名称 (e.g. "My iPhone")
+ (NSString *)getDeviceName;

// 获取IDFV (优先从钥匙串获取，没有则生成并存储)
+ (NSString *)getOrCreateIDFV;

// 获取所有设备信息字典
+ (NSDictionary *)getAllDeviceInfo;

/**
 将字典参数拼接到URL后面并进行URL编码
 
 @param baseURL 基础URL
 @param params 参数字典
 @return 拼接后的完整URL字符串
 */
+ (NSString *)appendParamsToURL:(NSString *)baseURL params:(NSDictionary *)params;


//获取IDFA
+ (void)requestIDFAWithCompletion:(void (^)(NSString * _Nullable idfa, BOOL isTrackingAuthorized))completion;


// 获取当前时间的秒级时间戳（double）
+ (NSString*)getCurrentTimestampInSeconds;
@end

NS_ASSUME_NONNULL_END
