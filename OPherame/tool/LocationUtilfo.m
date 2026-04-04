//
//  LocationUtilfo.m
//  OPherame
//
//  Created by todesk on 2025/6/25.
//

#import "LocationUtilfo.h"
#import "MBProgressHUD.h"
@interface LocationUtilfo () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, copy) LocationFullResultBlock completionBlock;
@property (nonatomic, assign) BOOL isRequestingLocation;
@property (nonatomic, strong) NSDate *lastLocationTime;
@end

@implementation LocationUtilfo

+ (instancetype)sharedManager {
    static LocationUtilfo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocationUtilfo alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
//        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 改为百米精度可能更快  //kCLLocationAccuracyBest;
//        _isRequestingLocation = NO;
        
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 更高精度
        _locationManager.distanceFilter = kCLDistanceFilterNone; // 不限制距离变化
        _isRequestingLocation = NO;
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)hasLocationPermission {
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
            status == kCLAuthorizationStatusAuthorizedAlways);
}




- (void)getFullLocationWithViewController:(UIViewController *)viewController
                             completion:(LocationFullResultBlock)completion {
    
    // 先停止之前的定位（避免多个请求同时进行）
        [self stopLocationUpdates];
    
    // 重置状态
    self.lastLocationTime = nil;
    self.currentViewController = viewController;
    self.completionBlock = completion;
    
//    if (![CLLocationManager locationServicesEnabled]) {
//        [self showLocationServicesDisabledAlert];
//        if (completion) {
//            completion(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid, [self locationServicesDisabledError]);
//        }
//        return;
//    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
       
//        if ([self isToday]) {
//            // 一个自然日只弹一次弹框
//            [self showLocationPermissionAlert];
//        }
        
        [self showLocationPermissionAlert];

        if (completion) {
            completion(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid, [self locationPermissionDeniedError]);
        }
        return;
    }
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        self.isRequestingLocation = YES;
        [self.locationManager requestWhenInUseAuthorization];
        if (completion) {
            completion(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid, [self locationServicesDisabledError]);
        }
        return;
    }
    [self startSingleLocationUpdate];
}

//一个自然日自弹一次弹框
- (BOOL)isToday {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastDate = [userDefault objectForKey:@"lastPopupDate"];
    
    if (![today isEqualToString:lastDate]) {
        // 更新日期
        [userDefault setObject:today forKey:@"lastPopupDate"];
        [userDefault synchronize];
        
        // 显示弹窗
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

- (void)startSingleLocationUpdate {
    
    self.isRequestingLocation = YES;
    if (@available(iOS 9.0, *)) {
        [self.locationManager startUpdatingLocation]; // iOS 9+ 推荐方式，单次定位
    } else {
        // 如果仍需支持iOS 8，可以缩短超时时间
        [self.locationManager startUpdatingLocation];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.isRequestingLocation) {
                [weakSelf.locationManager stopUpdatingLocation];
                weakSelf.isRequestingLocation = NO;
                if (weakSelf.completionBlock) {
                    
                    NSArray *savedAict = (NSArray*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"savedCoordinate"];
                    
                    if(savedAict.count){
                        CLLocationCoordinate2D loadedCoordinate = CLLocationCoordinate2DMake(
                                                                                             [savedAict[7][@"latitude"] doubleValue],
                                                                                             [savedAict[7][@"longitude"] doubleValue]
                                                                                             );
                        self.completionBlock(savedAict[0], savedAict[1], savedAict[2], savedAict[3], savedAict[4], savedAict[5], savedAict[6], loadedCoordinate, nil);
                    }
                    else{
                        weakSelf.completionBlock(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid, [NSError errorWithDomain:@"LocationTimeout" code:-3 userInfo:@{NSLocalizedDescriptionKey: @"定位超时"}]);
                    }
                    
                }
            }
        });
    }
}

- (void)stopLocationUpdates {
    [self.locationManager stopUpdatingLocation];
    if (self.isRequestingLocation) {
        self.isRequestingLocation = NO;
    }
}

- (void)reverseGeocodeLocation:(CLLocation *)location {
    if (!location || !CLLocationCoordinate2DIsValid(location.coordinate)) {
        if (self.completionBlock) {
            
            NSArray *savedAict = (NSArray*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"savedCoordinate"];
            
            if(savedAict.count){
                CLLocationCoordinate2D loadedCoordinate = CLLocationCoordinate2DMake(
                        [savedAict[7][@"latitude"] doubleValue],
                        [savedAict[7][@"longitude"] doubleValue]
                    );
                self.completionBlock(savedAict[0], savedAict[1], savedAict[2], savedAict[3], savedAict[4], savedAict[5], savedAict[6], loadedCoordinate, nil);
            }
            else{
                self.completionBlock(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid,
                                   [NSError errorWithDomain:@"LocationInvalid"
                                                       code:-4
                                                   userInfo:@{NSLocalizedDescriptionKey: @"无效的位置数据"}]);
            }
        }
        return;
    }
    
    // 设置反地理编码超时（如 5 秒）
   __block BOOL geocodingFinished = NO;
   CLGeocoder *geocoder = [[CLGeocoder alloc] init];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       if (!geocodingFinished) {
           [geocoder cancelGeocode]; // 取消未完成的请求
           if (self.completionBlock) {
               
               NSArray *savedAict = (NSArray*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"savedCoordinate"];
               
               if(savedAict.count){
                   CLLocationCoordinate2D loadedCoordinate = CLLocationCoordinate2DMake(
                           [savedAict[7][@"latitude"] doubleValue],
                           [savedAict[7][@"longitude"] doubleValue]
                       );
                   self.completionBlock(savedAict[0], savedAict[1], savedAict[2], savedAict[3], savedAict[4], savedAict[5], savedAict[6], loadedCoordinate, nil);
               }
               else{
                   self.completionBlock(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid, [NSError errorWithDomain:@"GeocodingTimeout" code:-5 userInfo:@{NSLocalizedDescriptionKey: @"反地理编码超时"}]);
               }
               
           }
       }
   });
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        geocodingFinished = YES;
        NSString *country = nil;
        NSString *countryCode = nil;
        NSString *province = nil;
        NSString *city = nil;
        NSString *district = nil;
        NSString *street = nil;
        NSString *fullAddress = nil;
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        if (!error && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            
            // 国家信息
            country = placemark.country ?: @"";
            countryCode = placemark.ISOcountryCode ?: @"";
            
            // 省份信息
            province = (placemark.administrativeArea ?: placemark.subAdministrativeArea) ?: @"";
            
            // 城市信息
            city = (placemark.locality ?: placemark.subLocality) ?: @"";
            
            // 区县信息
            district = placemark.subLocality ?: @"";
            
            // 街道信息
            if (placemark.thoroughfare && placemark.subThoroughfare) {
                street = [NSString stringWithFormat:@"%@%@", placemark.thoroughfare, placemark.subThoroughfare];
            } else {
                street = (placemark.thoroughfare ?: placemark.subThoroughfare) ?: @"";
            }
            
            // 构建完整地址
            NSMutableArray *addressParts = [NSMutableArray array];
            if (country) [addressParts addObject:country];
            if (province && ![province isEqualToString:city]) [addressParts addObject:province];
            if (city) [addressParts addObject:city];
            if (district) [addressParts addObject:district];
            if (street) [addressParts addObject:street];
            
            fullAddress = [addressParts componentsJoinedByString:@""];
        }
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completionBlock) {
                
                NSDictionary *coordinateDict = @{
                    @"latitude": @(coordinate.latitude),
                    @"longitude": @(coordinate.longitude)
                };
                // placemarks 为空或 error 时 country 等仍为 nil，NSArray 字面量不能含 nil
                [[NSUserDefaults standardUserDefaults] setObject:@[
                    country ?: @"",
                    countryCode ?: @"",
                    province ?: @"",
                    city ?: @"",
                    district ?: @"",
                    street ?: @"",
                    fullAddress ?: @"",
                    coordinateDict
                ] forKey:@"savedCoordinate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                self.completionBlock(country, countryCode, province, city, district, street, fullAddress, coordinate, error);
            }
        });
        
    }];
}


#pragma mark - Alert Methods

- (void)showLocationServicesDisabledAlert {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@""
                                message:@"Credit Peso needs to access your location information to determine whether you are within our service coverage area. Additionally, this allows us to recommend personalized loan products based on your location."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil];
    
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Go Setting"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [self openSystemSettings];
    }];
    
    [alert addAction:cancel];
    [alert addAction:settings];
    
    [self.currentViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showLocationPermissionAlert {
    UIAlertController *alert = [UIAlertController

                               alertControllerWithTitle:nil//定位权限未开启
                               message:@"Credit Peso needs to access your location information to determine whether you are within our service coverage area. Additionally, this allows us to recommend personalized loan products based on your location."//请到设置>隐私>定位服务中允许应用使用定位服务

                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil];
    

   

    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings"

                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [self openSystemSettings];
    }];
    
    [alert addAction:cancel];
    [alert addAction:settings];
    
    [self.currentViewController presentViewController:alert animated:YES completion:nil];
}

- (void)openSystemSettings {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }
}

#pragma mark - Error Methods

- (NSError *)locationServicesDisabledError {
    return [NSError errorWithDomain:@"LocationService"
                              code:-1
                          userInfo:@{NSLocalizedDescriptionKey: @"定位服务未开启"}];
}

- (NSError *)locationPermissionDeniedError {
    return [NSError errorWithDomain:@"LocationPermission"
                              code:-2
                          userInfo:@{NSLocalizedDescriptionKey: @"定位权限被拒绝"}];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.isRequestingLocation) {
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
            [self startSingleLocationUpdate];
        } else if (status == kCLAuthorizationStatusDenied) {
            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            [MBProgressHUD hideHUDForView:window animated:YES];
            [self showLocationPermissionAlert];
            if (self.completionBlock) {
                
                NSArray *savedAict = (NSArray*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"savedCoordinate"];
                
                if(savedAict.count){
                    CLLocationCoordinate2D loadedCoordinate = CLLocationCoordinate2DMake(
                            [savedAict[7][@"latitude"] doubleValue],
                            [savedAict[7][@"longitude"] doubleValue]
                        );
                    self.completionBlock(savedAict[0], savedAict[1], savedAict[2], savedAict[3], savedAict[4], savedAict[5], savedAict[6], loadedCoordinate, nil);
                }
                else{
                    self.completionBlock(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid, [self locationPermissionDeniedError]);
                }
                
            }
            [self stopLocationUpdates];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    [self stopLocationUpdates];
    [self reverseGeocodeLocation:location];
    
    double lllasd = location.coordinate.latitude;
    double lllong = location.coordinate.longitude;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:lllasd]] forKey:@"lllasd"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:lllong]] forKey:@"lllong"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"StartTime"] != nil
       &&[[NSUserDefaults standardUserDefaults] objectForKey:@"StopTime"] != nil){
        
        
        NSDictionary *medis = @{
            @"centimetre": @"",   // 产品ID
            @"bill": @"1",         // 看文档首页 上报场景类型：1、注册 2、认证选择 3、证件信息 4、人脸照片 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
            @"flipped": @"",            // 用户申贷全局订单号，不用管, 传空即可
            @"splitting": [BeiMInfoUtil getOrCreateIDFV], // idfv
            @"tight": [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString]?:@"",             // idfa
            @"stroke": [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:lllong]] ?: @"",
            @"surveying": [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:lllasd]] ?: @"",
            @"moneys": [[NSUserDefaults standardUserDefaults] objectForKey:@"StartTime"],    // 开始时间
            @"flatter": [[NSUserDefaults standardUserDefaults] objectForKey:@"StopTime"],     // 结束时间
            @"skills": [RandomStringGenerator randomlyCallMethod]         // 混淆字段
        };
        
        static BOOL hasExecuted = NO;
            if (!hasExecuted) {
                hasExecuted = YES; // 标记为已执行
            
                [[NetworkManager sharedManager]googleMarketPOST:@"/radiating/winds" parameters:medis headers:nil progress:nil success:^(id  _Nullable responseObject) {
                    if([responseObject[@"heavy"] isEqualToString:@"0"]){
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StartTime"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StopTime"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            
        }
       
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.completionBlock) {
        NSArray *savedAict = (NSArray*)[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"savedCoordinate"];
        
        if(savedAict.count){
            CLLocationCoordinate2D loadedCoordinate = CLLocationCoordinate2DMake(
                    [savedAict[7][@"latitude"] doubleValue],
                    [savedAict[7][@"longitude"] doubleValue]
                );
            self.completionBlock(savedAict[0], savedAict[1], savedAict[2], savedAict[3], savedAict[4], savedAict[5], savedAict[6], loadedCoordinate, nil);
        }else{
            self.completionBlock(nil, nil, nil, nil, nil, nil, nil, kCLLocationCoordinate2DInvalid, error);
        }
        
    }
    [self stopLocationUpdates];
}

@end
