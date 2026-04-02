//
//  Base64Tool.h
//  OPherame
//
//  Created by todesk on 2025/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Base64Tool : NSObject
#pragma mark - 字符串Base64编码/解码
/// 字符串Base64编码
+ (NSString *)base64EncodeString:(NSString *)string;
/// 字符串Base64解码
+ (NSString *)base64DecodeString:(NSString *)base64String;

#pragma mark - 数组Base64编码/解码
/// 数组转Base64字符串
+ (NSString *)base64EncodeArray:(NSArray *)array;
/// Base64字符串转数组
+ (NSArray *)base64DecodeToArray:(NSString *)base64String;

#pragma mark - 字典Base64编码/解码
/// 字典转Base64字符串
+ (NSString *)base64EncodeDictionary:(NSDictionary *)dictionary;
/// Base64字符串转字典
+ (NSDictionary *)base64DecodeToDictionary:(NSString *)base64String;

/// Base64 编码（NSData → Base64 NSString）
+ (NSString *)base64EncodeData:(NSData *)inputData;

/// Base64 解码（Base64 NSString → NSData）
+ (NSData *)base64DecodeData:(NSString *)base64String;
@end

NS_ASSUME_NONNULL_END
