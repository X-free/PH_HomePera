//
//  BeiMInfoUtil.m
//  OPherame
//
//  Created by todesk on 2025/6/24.
//

#import "BeiMInfoUtil.h"
#import "KeychainWrapper.h"
#import <sys/utsname.h>

// 钥匙串存储IDFV的key
static NSString *const kIDFVKeychainKey = @"com.yourcompany.idfv";

@implementation BeiMInfoUtil

+ (NSString *)getOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getAppVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getAppBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)getDeviceName {
    return [[UIDevice currentDevice] name];
}

+ (NSString *)getOrCreateIDFV {
    // 1. 尝试从钥匙串获取
    NSString *idfv = [KeychainWrapper stringForKey:kIDFVKeychainKey];
    
    // 2. 如果钥匙串中没有，则获取新的IDFV并存储
    if (!idfv || [idfv length] == 0) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeychainWrapper setString:idfv forKey:kIDFVKeychainKey];
    }
    
    return idfv;
}

+ (NSDictionary *)getAllDeviceInfo {
    return @{
        @"osVersion": [self getOSVersion],
        @"appVersion": [self getAppVersion],
        @"appBuildVersion": [self getAppBuildVersion],
        @"deviceModel": [self getDeviceModel],
        @"deviceName": [self getDeviceName],
        @"idfv": [self getOrCreateIDFV],
        @"systemName": [[UIDevice currentDevice] systemName],
        @"bundleIdentifier": [[NSBundle mainBundle] bundleIdentifier]
    };
}


+ (NSString *)appendParamsToURL:(NSString *)baseURL params:(NSDictionary *)params {
    if (!baseURL || !params || params.count == 0) {
        return baseURL;
    }
    
    // 判断原URL是否已包含参数
    NSString *connector = [baseURL containsString:@"?"] ? @"&" : @"?";
    
    // 生成参数字符串
    NSMutableArray *paramPairs = [NSMutableArray array];
    for (NSString *key in params) {
        id value = params[key];
        
        // 确保key和value都是字符串
        NSString *keyStr = [key description];
        NSString *valueStr = [value description];
        
        // URL编码
        NSString *encodedKey = [self urlEncode:keyStr];
        NSString *encodedValue = [self urlEncode:valueStr];
        
        [paramPairs addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }
    
    NSString *paramsString = [paramPairs componentsJoinedByString:@"&"];
    return [NSString stringWithFormat:@"%@%@%@", baseURL, connector, paramsString];
}

+ (NSString *)urlEncode:(NSString *)string {
    if (!string) return @"";
    
//    // 使用NSCharacterSet定义需要保留的字符
//    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"].invertedSet;
//    
//    // 对字符串进行编码
//    NSString *encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
//    
//    // 处理空格转为+号的情况（可选，根据服务器需求）
//    encodedString = [encodedString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    
//    return encodedString;
    
    
    
    NSString *encodedURLString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    if (encodedURLString) {
//        NSURL *url = [NSURL URLWithString:encodedURLString];
//        if (url) {
//            return url.absoluteString;
//        }
//        
//    }
    return encodedURLString?:@"";
    
    
}



//获取IDFA
+ (void)requestIDFAWithCompletion:(void (^)(NSString * _Nullable idfa, BOOL isTrackingAuthorized))completion {
    
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);
                completion(idfa, YES);
            } else {
                     NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
                completion(@"", NO);
            }
          
        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"%@",idfa);
            completion(idfa, YES);
        } else {
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            completion(@"", NO);
        }
        
    }
   
}

// 获取当前时间的秒级时间戳（double）
+ (NSString*)getCurrentTimestampInSeconds{
    
    // 获取当前时间
    NSDate *currentDate = [NSDate date];

    // 转换为 Unix 时间戳（秒，double 类型）
    NSTimeInterval timestamp = [currentDate timeIntervalSince1970];

    // 转为整数（可选）
    NSInteger integerTimestamp = (NSInteger)timestamp;
    
    return [NSString stringWithFormat:@"%ld",integerTimestamp];
}
@end
