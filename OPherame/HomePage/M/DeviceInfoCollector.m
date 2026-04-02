//
//  DeviceInfoCollector.m
//  OPherame
//
//  Created by todesk on 2025/7/3.
//

#import "DeviceInfoCollector.h"

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import <mach/mach.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>


#import <AFNetworking/AFNetworking.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@implementation DeviceInfoCollector

+ (instancetype)sharedCollector {
    static DeviceInfoCollector *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DeviceInfoCollector alloc] init];
    });
    return instance;
}

- (NSDictionary *)collectFullDeviceInfo {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    // 系统基本信息
    result[@"deductive"] = @"ios";
    result[@"thatd"] = [[UIDevice currentDevice] systemVersion];
    result[@"draped"] = @((long long)([[NSDate date] timeIntervalSince1970] * 1000));
    result[@"whites"] = [[NSBundle mainBundle] bundleIdentifier] ?: @"";
    
    
    // 电池信息
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    NSMutableDictionary *dig = [NSMutableDictionary dictionary];
    dig[@"thumbs"] = @((int)([UIDevice currentDevice].batteryLevel * 100));
    dig[@"twiddling"] = [UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging ? @1 : @0;
    result[@"dig"] = dig;
    
    
    // 通用数据
    NSMutableDictionary *brainwaves = [NSMutableDictionary dictionary];
    brainwaves[@"tourists"] = [BeiMInfoUtil getOrCreateIDFV] ?: @"";
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [BeiMInfoUtil requestIDFAWithCompletion:^(NSString * _Nullable idfa, BOOL isTrackingAuthorized) {
        brainwaves[@"hordes"] = idfa; // 需要替换为实际获取IDFA的方法
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    brainwaves[@"intently"] = [self getMacAddress] ?: @"";
    brainwaves[@"guns"] = @((long long)([[NSDate date] timeIntervalSince1970] * 1000));
    brainwaves[@"remembers"] = @([self isUsingProxy] ? 1 : 0);
    brainwaves[@"politicians"] = @([self isVPNConnected] ? 1 : 0);
    brainwaves[@"excuses"] = @([self isJailbroken] ? 1 : 0);
    brainwaves[@"promises"] = @([self isSimulator] ? 1 : 0);
    brainwaves[@"minister"] = [[NSLocale preferredLanguages] firstObject] ?: @"";
        
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    brainwaves[@"prime"] = [carrier carrierName] ?: @"";
    brainwaves[@"cupboard"] = [self getNetworkType];
    brainwaves[@"stacking"] = [[NSTimeZone localTimeZone] name];
    brainwaves[@"terrible"] = @([self getSystemUptime]);
    result[@"brainwaves"] = brainwaves;
        
    // 硬件信息
    NSMutableDictionary *throwing = [NSMutableDictionary dictionary];
    throwing[@"hike"] = @"";
    throwing[@"tax"] = @"iPhone";
    throwing[@"consumption"] = @"";
        
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    throwing[@"scowling"] = @((int)screenRect.size.height);
    throwing[@"washing"] = @((int)screenRect.size.width);
    throwing[@"writing"] = [[UIDevice currentDevice] name];
    throwing[@"tracing"] = [self getDeviceModelName];
    throwing[@"troubled"] = [NSString stringWithFormat:@"%.1f",[self getDevicePhysicalSize]];
    throwing[@"growing"] = [[UIDevice currentDevice] systemVersion];
    throwing[@"leafing"] = [self deviceHardwareName];
    result[@"throwing"] = throwing;
    
    
    // 网络信息
    NSMutableDictionary *forte = [NSMutableDictionary dictionary];
    forte[@"finding"] = [self getIPAddress] ?: @"";
        
    NSDictionary *currentWifi = [self getCurrentWifiInfo];
    NSArray *wifiList = currentWifi ? @[currentWifi] : @[];
    
    forte[@"forming"] = wifiList;
    forte[@"louder"] = currentWifi ?: @{};
    forte[@"thumping"] = @(currentWifi ? 1 : 0);
    
    
    result[@"forte"] = forte;
        
    // 存储信息
    NSMutableDictionary *trouble = [NSMutableDictionary dictionary];
    NSDictionary *storageInfo = [self getStorageInfo];
    trouble[@"snatched"] = storageInfo[@"freeDiskSpace"] ?: @"0";
    trouble[@"main"] = storageInfo[@"totalDiskSpace"] ?: @"0";
        
    NSDictionary *memoryInfo = [self getMemoryInfo];
    trouble[@"results"] = memoryInfo[@"totalMemory"] ?: @"0";
    
    unsigned long long availableMemory = [DeviceInfoCollector getAvailableMemorySizeInBytes];
//    NSString *formattedMemory = [DeviceInfoCollector formatMemorySize:availableMemory];
    trouble[@"retreating"] = availableMemory ?[NSString stringWithFormat:@"%llu", availableMemory]: @"0";
    result[@"trouble"] = trouble;
        
    return [result copy];
    
}



#pragma mark - WiFi Information

- (NSDictionary *)getCurrentWifiInfo {
    NSMutableDictionary *wifiInfo = [NSMutableDictionary dictionary];
    
 
    // iOS 12 及以下版本
    NSArray *interfaces = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    for (NSString *interface in interfaces) {
        NSDictionary *networkInfo = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interface);
        if (networkInfo) {
            wifiInfo[@"appreciating"] = networkInfo[@"SSID"];       // Wi-Fi 名称
            wifiInfo[@"wrinkles"] = networkInfo[@"BSSID"];           // BSSID
            wifiInfo[@"intently"] = networkInfo[@"BSSID"];           // MAC (通常与 BSSID 相同)
            wifiInfo[@"series"] = networkInfo[@"SSID"];             // SSID
            break;
        }
    }
    
    
    return wifiInfo;
}

#pragma mark - Private Methods

#pragma mark - WIFI MAC
- (NSString *)getMacAddress {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
         NSLog(@"Supported interfaces: %@", ifs);
         id info = nil;
         for (NSString *ifnam in ifs) {
             info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
             NSLog(@"%@ => %@", ifnam, info);  //单个数据info[@"SSID"]; info[@"BSSID"];
             if (info[@"SSID"]) {
                 NSString *ssid = info[@"SSID"];
                 NSString *bssid = info[@"BSSID"];
//                 info = @{@"SSID":ssid,@"BSSID":bssid};
                 info = bssid;
                 break;
             }
         }
         return info;

  
}


- (BOOL)isUsingProxy {
    NSDictionary *proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSArray *proxies = (__bridge NSArray *)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"http://www.apple.com"], (__bridge CFDictionaryRef)proxySettings);
    
    NSDictionary *settings = proxies.firstObject;
    return ![[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:(NSString *)kCFProxyTypeNone];
}

- (BOOL)isVPNConnected {
    struct ifaddrs *interfaces = NULL;
    if (getifaddrs(&interfaces) != 0) return NO;

    BOOL isVPN = NO;
    struct ifaddrs *temp_addr = interfaces;
    while (temp_addr != NULL) {
        NSString *interfaceName = [NSString stringWithUTF8String:temp_addr->ifa_name];
        
        // 检测到 IPSec 接口
        if ([interfaceName isEqualToString:@"ipsec0"]) {
            // 验证接口是否活跃（ifa_flags 包含 IFF_UP 和 IFF_RUNNING）
            if ((temp_addr->ifa_flags & IFF_UP) && (temp_addr->ifa_flags & IFF_RUNNING)) {
                // 进一步检查 IP 地址
                if (temp_addr->ifa_addr->sa_family == AF_INET) {
                    struct sockaddr_in *addr = (struct sockaddr_in *)temp_addr->ifa_addr;
                    char ip[INET_ADDRSTRLEN];
                    inet_ntop(AF_INET, &addr->sin_addr, ip, INET_ADDRSTRLEN);
                    
                    // 排除私有 IP 和空 IP
                    if (strcmp(ip, "0.0.0.0") != 0 &&
                        strncmp(ip, "192.168.", 8) != 0 &&
                        strncmp(ip, "10.", 3) != 0) {
                        isVPN = YES;
                        break;
                    }
                }
            }
        }
        temp_addr = temp_addr->ifa_next;
    }
    freeifaddrs(interfaces);
    return isVPN;
}

- (BOOL)isJailbroken {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    NSArray *jailbrokenPaths = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt"
    ];
    
    for (NSString *path in jailbrokenPaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    // 尝试写入系统目录
    NSString *testPath = @"/private/jailbreak_test.txt";
    NSError *error;
    [@"test" writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:testPath error:nil];
    
    return error == nil;
#endif
}

- (BOOL)isSimulator {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (NSString *)getNetworkType {
    // 1. 首先检查是否连接WiFi
    
    // 1. 创建并启动监听器
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    // 2. 立即获取当前状态
    AFNetworkReachabilityStatus status = manager.networkReachabilityStatus;
    
    // 3. 停止监听（因为我们只需要一次性检查）
    [manager stopMonitoring];
    
    // 4. 转换状态为字符串
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WIFI";
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return [self syncGetCellularNetworkType]; // 获取蜂窝网络具体类型
        case AFNetworkReachabilityStatusNotReachable:
            return @"NO_NETWORK";
        default:
            return @"UNKNOWN";
    }
    
    
}




- (NSString *)syncGetCellularNetworkType {
    if (@available(iOS 12.0, *)) {
        CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentRadio = netinfo.serviceCurrentRadioAccessTechnology.allValues.firstObject;
        
        if ([currentRadio isEqualToString:CTRadioAccessTechnologyGPRS] ||
            [currentRadio isEqualToString:CTRadioAccessTechnologyEdge]) {
            return @"2G";
        } else if ([currentRadio isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                  [currentRadio isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                  [currentRadio isEqualToString:CTRadioAccessTechnologyHSUPA]) {
            return @"3G";
        } else if ([currentRadio isEqualToString:CTRadioAccessTechnologyLTE]) {
            return @"4G";
        } else if (@available(iOS 14.1, *)) {
            if ([currentRadio isEqualToString:CTRadioAccessTechnologyNRNSA] ||
                [currentRadio isEqualToString:CTRadioAccessTechnologyNR]) {
                return @"5G";
            }
        }
    }
    return @"CELLULAR"; // 无法确定具体蜂窝网络类型
}


- (long long)getSystemUptime {
    // 获取 mach 绝对时间
       uint64_t time = mach_absolute_time();
       
       // 获取时间基准信息
       mach_timebase_info_data_t timebase;
       mach_timebase_info(&timebase);
       
       // 转换为纳秒
       uint64_t nanoseconds = time * timebase.numer / timebase.denom;
       
       // 转换为毫秒（并确保不会溢出int范围）
       uint64_t milliseconds = nanoseconds / 1000000;
       
       // 确保在int范围内（虽然实际不太可能超过）
       if (milliseconds > INT_MAX) {
           return INT_MAX;
       }
       
       return (int)milliseconds;
}

- (NSString *)getIPAddress {
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *deviceNames = @{
        @"iPhone1,1": @"iPhone",
        @"iPhone1,2": @"iPhone 3G",
        // 添加更多设备映射...
        @"iPhone13,1": @"iPhone 12 mini",
        @"iPhone13,2": @"iPhone 12",
        @"iPhone13,3": @"iPhone 12 Pro",
        @"iPhone13,4": @"iPhone 12 Pro Max"
    };
    
    return deviceNames[deviceModel] ?: deviceModel;
}

- (NSString *)devicePhysicalSize {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *deviceSizes = @{
        @"iPhone7,1": @"5.5",  // iPhone 6 Plus
        @"iPhone8,2": @"5.5",  // iPhone 6s Plus
        // 添加更多设备尺寸...
        @"iPhone13,1": @"5.4", // iPhone 12 mini
        @"iPhone13,2": @"6.1", // iPhone 12
    };
    
    return deviceSizes[deviceModel] ?: @"";
}

- (NSString *)deviceHardwareName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)getStorageInfo {
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    unsigned long long totalSpace = [[fileAttributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
    unsigned long long freeSpace = [[fileAttributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    
    return @{
        @"totalDiskSpace": [NSString stringWithFormat:@"%llu", totalSpace],
        @"freeDiskSpace": [NSString stringWithFormat:@"%llu", freeSpace]
    };
}

- (NSDictionary *)getMemoryInfo {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return @{@"totalMemory": @"0", @"freeMemory": @"0"};
    }
    
    natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    
    return @{
        @"totalMemory": [NSString stringWithFormat:@"%u", mem_total],
        @"freeMemory": [NSString stringWithFormat:@"%u", mem_free]
    };
}

#pragma mark - 获取当前可用内存（单位：字节）
+ (unsigned long long)getAvailableMemorySizeInBytes {
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO64_COUNT;
    kern_return_t kernReturn = host_statistics64(mach_host_self(),
                                               HOST_VM_INFO64,
                                               (host_info64_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        NSLog(@"获取内存信息失败: %d", kernReturn);
        return 0;
    }
    
    // 计算可用内存（空闲+非活跃内存）
    unsigned long long availableMemory = (vmStats.free_count + vmStats.inactive_count) * (unsigned long long)vm_page_size;
    return availableMemory;
}

#pragma mark - 格式化内存大小为可读字符串
+ (NSString *)formatMemorySize:(unsigned long long)bytes {
    double convertedValue = bytes;
    int multiplyFactor = 0;
    NSArray *tokens = @[@"bytes", @"KB", @"MB", @"GB"];
    
    while (convertedValue > 1024 && multiplyFactor < (tokens.count - 1)) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@", convertedValue, tokens[multiplyFactor]];
}


- (NSString *)getDeviceModelName {
    struct utsname systemInfo;
        uname(&systemInfo);
        NSString *identifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        NSDictionary *deviceMap = @{
            // 初代 iPhone → iPhone 15 系列（已发布）
            @"iPhone1,1": @"iPhone (1st Generation)",
            @"iPhone1,2": @"iPhone 3G",
            @"iPhone2,1": @"iPhone 3GS",
            @"iPhone3,1": @"iPhone 4 (GSM)",
            @"iPhone3,2": @"iPhone 4 (CDMA)",
            @"iPhone3,3": @"iPhone 4 (Verizon)",
            @"iPhone4,1": @"iPhone 4S",
            @"iPhone5,1": @"iPhone 5 (GSM)",
            @"iPhone5,2": @"iPhone 5 (CDMA)",
            @"iPhone5,3": @"iPhone 5c (GSM)",
            @"iPhone5,4": @"iPhone 5c (CDMA)",
            @"iPhone6,1": @"iPhone 5s (GSM)",
            @"iPhone6,2": @"iPhone 5s (CDMA)",
            @"iPhone7,1": @"iPhone 6 Plus",
            @"iPhone7,2": @"iPhone 6",
            @"iPhone8,1": @"iPhone 6s",
            @"iPhone8,2": @"iPhone 6s Plus",
            @"iPhone8,4": @"iPhone SE (1st Generation)",
            @"iPhone9,1": @"iPhone 7 (GSM)",
            @"iPhone9,2": @"iPhone 7 Plus (GSM)",
            @"iPhone9,3": @"iPhone 7 (CDMA)",
            @"iPhone9,4": @"iPhone 7 Plus (CDMA)",
            @"iPhone10,1": @"iPhone 8 (GSM)",
            @"iPhone10,2": @"iPhone 8 Plus (GSM)",
            @"iPhone10,3": @"iPhone X (GSM)",
            @"iPhone10,4": @"iPhone 8 (CDMA)",
            @"iPhone10,5": @"iPhone 8 Plus (CDMA)",
            @"iPhone10,6": @"iPhone X (CDMA)",
            @"iPhone11,2": @"iPhone XS",
            @"iPhone11,4": @"iPhone XS Max",
            @"iPhone11,6": @"iPhone XS Max (China)",
            @"iPhone11,8": @"iPhone XR",
            @"iPhone12,1": @"iPhone 11",
            @"iPhone12,3": @"iPhone 11 Pro",
            @"iPhone12,5": @"iPhone 11 Pro Max",
            @"iPhone12,8": @"iPhone SE (2nd Generation)",
            @"iPhone13,1": @"iPhone 12 mini",
            @"iPhone13,2": @"iPhone 12",
            @"iPhone13,3": @"iPhone 12 Pro",
            @"iPhone13,4": @"iPhone 12 Pro Max",
            @"iPhone14,2": @"iPhone 13 Pro",
            @"iPhone14,3": @"iPhone 13 Pro Max",
            @"iPhone14,4": @"iPhone 13 mini",
            @"iPhone14,5": @"iPhone 13",
            @"iPhone14,6": @"iPhone SE (3rd Generation)",
            @"iPhone14,7": @"iPhone 14",
            @"iPhone14,8": @"iPhone 14 Plus",
            @"iPhone15,2": @"iPhone 14 Pro",
            @"iPhone15,3": @"iPhone 14 Pro Max",
            @"iPhone15,4": @"iPhone 15",
            @"iPhone15,5": @"iPhone 15 Plus",
            @"iPhone16,1": @"iPhone 15 Pro",
            @"iPhone16,2": @"iPhone 15 Pro Max",
            
            // 2024-2025 预测机型（按苹果命名规则推测）
            @"iPhone17,1": @"iPhone 16 (Predicted)",
            @"iPhone17,2": @"iPhone 16 Pro (Predicted)",
            @"iPhone17,3": @"iPhone 16 Pro Max (Predicted)",
            @"iPhone18,1": @"iPhone 16 (2025, Predicted)",
            @"iPhone18,2": @"iPhone 16 Pro (2025, Predicted)",
            @"iPhone18,3": @"iPhone 16 Pro Max (2025, Predicted)",
            
            // 模拟器标识符
            @"i386": @"iPhone Simulator",
            @"x86_64": @"iPhone Simulator",
            @"arm64": @"iPhone Simulator"
        };
        
        NSString *deviceName = deviceMap[identifier];
        return deviceName ?: identifier;
}



- (CGFloat)getDevicePhysicalSize {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *identifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
        NSDictionary<NSString *, NSNumber *> *sizeMap = @{
            // iPhone 1 → iPhone 16 系列
            @"iPhone1,1": @3.5,
            @"iPhone1,2": @3.5,
            @"iPhone2,1": @3.5,
            @"iPhone3,1": @3.5,
            @"iPhone4,1": @3.5,
            @"iPhone5,1": @4.0,
            @"iPhone5,2": @4.0,
            @"iPhone5,3": @4.0,
            @"iPhone5,4": @4.0,
            @"iPhone6,1": @4.0,
            @"iPhone6,2": @4.0,
            @"iPhone7,1": @5.5,
            @"iPhone7,2": @4.7,
            @"iPhone8,1": @4.7,
            @"iPhone8,2": @5.5,
            @"iPhone8,4": @4.0,
            @"iPhone9,1": @4.7,
            @"iPhone9,2": @5.5,
            @"iPhone9,3": @4.7,
            @"iPhone9,4": @5.5,
            @"iPhone10,1": @4.7,
            @"iPhone10,2": @5.5,
            @"iPhone10,3": @5.8,
            @"iPhone10,4": @4.7,
            @"iPhone10,5": @5.5,
            @"iPhone10,6": @5.8,
            @"iPhone11,2": @5.8,
            @"iPhone11,4": @6.5,
            @"iPhone11,6": @6.5,
            @"iPhone11,8": @6.1,
            @"iPhone12,1": @6.1,
            @"iPhone12,3": @5.8,
            @"iPhone12,5": @6.5,
            @"iPhone12,8": @4.7,
            @"iPhone13,1": @5.4,
            @"iPhone13,2": @6.1,
            @"iPhone13,3": @6.1,
            @"iPhone13,4": @6.7,
            @"iPhone14,2": @6.1,
            @"iPhone14,3": @6.7,
            @"iPhone14,4": @5.4,
            @"iPhone14,5": @6.1,
            @"iPhone14,6": @4.7,
            @"iPhone14,7": @6.1,
            @"iPhone14,8": @6.7,
            @"iPhone15,2": @6.1,
            @"iPhone15,3": @6.7,
            @"iPhone15,4": @6.1,
            @"iPhone15,5": @6.7,
            @"iPhone16,1": @6.1,
            @"iPhone16,2": @6.7,
            // 2024-2025 预测机型
            @"iPhone17,1": @6.1,
            @"iPhone17,2": @6.3,
            @"iPhone17,3": @6.9,
        };
        
        NSNumber *sizeInInches = sizeMap[identifier];
        return sizeInInches ? sizeInInches.floatValue : 0.0; // 未知设备返回 0
}

- (CGFloat)calculateDynamicPPI {
    // 获取屏幕尺寸类别
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    // 计算屏幕长宽比
    CGFloat aspectRatio = MAX(screenWidth, screenHeight) / MIN(screenWidth, screenHeight);
    
    // 根据屏幕特性动态推断PPI
    if (screenScale == 3.0) {
        // iPhone Plus/X/XS/11 Pro/12/13等3x缩放设备
        return aspectRatio > 1.7 ? 458.0 : 401.0;
    } else if (screenScale == 2.0) {
        // 标准Retina设备
        if (aspectRatio > 1.7) {
            // 长屏设备（iPhone 5/SE等）
            return 326.0;
        } else {
            // 传统比例设备（iPhone 4s/6/7/8等）
            return 326.0;
        }
    } else if (screenScale == 1.0) {
        // 非Retina设备（早期iPhone/iPod）
        return 163.0;
    } else {
        // iPad和其他设备
        return 264.0;
    }
}
@end
