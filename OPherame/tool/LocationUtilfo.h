//
//  LocationUtilfo.h
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocationFullResultBlock)(NSString * _Nullable country,
                                      NSString * _Nullable countryCode,
                                      NSString * _Nullable province,
                                      NSString * _Nullable city,
                                      NSString * _Nullable district,
                                      NSString * _Nullable street,
                                      NSString * _Nullable fullAddress,
                                      CLLocationCoordinate2D coordinate,
                                      NSError * _Nullable error);

@interface LocationUtilfo : NSObject

+ (instancetype)sharedManager;


/// 检查是否有定位权限
- (BOOL)hasLocationPermission;

/// 获取当前位置完整信息
/// @param viewController 用于显示提示框的ViewController
/// @param completion 回调block，包含地址信息和经纬度
- (void)getFullLocationWithViewController:(UIViewController *)viewController
                              completion:(LocationFullResultBlock)completion;

@end


NS_ASSUME_NONNULL_END
