//
//  DeviceInfoCollector.h
//  OPherame
//
//  Created by todesk on 2025/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoCollector : NSObject

+ (instancetype)sharedCollector;

/// 获取完整的设备信息字典
- (NSDictionary *)collectFullDeviceInfo;
@end

NS_ASSUME_NONNULL_END
