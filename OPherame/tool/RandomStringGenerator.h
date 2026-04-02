//
//  RandomStringGenerator.h
//  OPherame
//
//  Created by todesk on 2025/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RandomStringGenerator : NSObject

// 随机调用 RandomStringGenerator 中的方法
+ (NSString *)randomlyCallMethod;


// 生成随机字符串（4-8位）
+ (NSString *)generateRandomString;


// 生成指定长度的随机字符串
+ (NSString *)generateRandomStringWithLength:(NSUInteger)length;

// 生成特定类型的随机字符串
+ (NSString *)generateAlphanumericStringWithLength:(NSUInteger)length;
+ (NSString *)generateNumericStringWithLength:(NSUInteger)length;
+ (NSString *)generateLettersStringWithLength:(NSUInteger)length;
+ (NSString *)generateSpecialCharacterStringWithLength:(NSUInteger)length;
@end

NS_ASSUME_NONNULL_END
